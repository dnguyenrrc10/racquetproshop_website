class OrdersController < ApplicationController
  before_action :authenticate_user!

  # GET /orders
  # Customer can review past orders
  def index
    @orders = current_user.orders.order(order_date: :desc)
  end

  # GET /orders/:id
  # Show full invoice for a single order
  def show
    @order = current_user.orders
                         .includes(order_items: :product, customer: :user)
                         .find(params[:id])
  end

  # GET /orders/new
  # Checkout page (order summary + shipping info, no tax yet)
  def new
    @cart_items = cart_items_for_checkout

    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty." and return
    end

    # Require saved address + province on the user profile
    if current_user.address.blank? || current_user.province.blank?
      redirect_to edit_user_registration_path,
                  alert: "Please add your address and province before checking out." and return
    end

    @user = current_user
  end

  # POST /orders
  # Create order, calculate taxes, start Stripe Checkout
  def create
    cart_items = cart_items_for_checkout

    # 1) Cart must not be empty
    if cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty." and return
    end

    # 2) Require address + province on the user profile
    if current_user.address.blank? || current_user.province.blank?
      redirect_to edit_user_registration_path,
                  alert: "Please add your address and province before checking out." and return
    end

    ActiveRecord::Base.transaction do
      # 3) Create or update customer using user profile info
      customer = current_user.customer || current_user.build_customer
      customer.assign_attributes(
        name:        current_user.name.presence || current_user.email,
        email:       current_user.email,
        address:     current_user.address,
        city:        current_user.city,
        province:    current_user.province,
        postal_code: current_user.postal_code
      )
      customer.save!

      # 4) Build order with pending status
      order = current_user.orders.build(
        customer:   customer,
        order_date: Time.current,
        status:     "pending"
      )

      # 5) Build order items from cart
      cart_items.each do |item|
        order.order_items.build(
          product:                item[:product],
          quantity:               item[:quantity],
          unit_price_at_purchase: item[:product].effective_price
        )
      end

      # 6) Snapshot of address into order
      order.shipping_address = customer.address
      order.city             = customer.city
      order.province         = customer.province
      order.postal_code      = customer.postal_code

      # 7) Calculate subtotal + taxes + total for this order
      order.calculate_totals!(customer.province)
      order.save!

      # 8) Amount for Stripe in dollars (fallback to subtotal if total_price is nil)
      amount_for_stripe = (order.total_price || order.subtotal || 0).to_f

      # 9) Create Stripe Checkout Session
      Rails.logger.info "Creating Stripe Checkout Session for order ##{order.id}, amount=#{amount_for_stripe}"

      session = Stripe::Checkout::Session.create(
        mode: "payment",
        payment_method_types: ["card"],
        customer_email: current_user.email,
        line_items: [
          {
            quantity: 1,
            price_data: {
              currency: "cad",
              product_data: {
                name: "Racquets Pro Shop Order ##{order.id}"
              },
              # Stripe expects integer cents
              unit_amount: (amount_for_stripe * 100).to_i
            }
          }
        ],
        success_url: order_url(order),  # after payment, show invoice
        cancel_url: new_order_url       # if cancelled, back to checkout
      )

      Rails.logger.info "Stripe Checkout Session URL: #{session.url}"

      # 10) For assignment: mark as paid immediately (in real life, use webhooks)
      order.update!(status: "paid")

      # 11) Clear cart
      session[:cart] = {}

      # 12) Redirect to Stripe's hosted payment page
      redirect_to session.url, allow_other_host: true
    end
  rescue Stripe::StripeError => e
    Rails.logger.error "Stripe error: #{e.message}"
    redirect_to new_order_path, alert: "There was a problem starting the payment: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Order creation error: #{e.message}"
    redirect_to new_order_path, alert: "There was a problem creating your order. Please try again."
  end

  private

  # Build cart items for checkout: [{ product:, quantity: }, ...]
  def cart_items_for_checkout
    product_ids = current_cart.keys
    products = Product.where(id: product_ids).index_by(&:id)

    product_ids.filter_map do |pid|
      product = products[pid.to_i]
      next unless product

      quantity = current_cart[pid].to_i

      {
        product:  product,
        quantity: quantity
      }
    end
  end
end
