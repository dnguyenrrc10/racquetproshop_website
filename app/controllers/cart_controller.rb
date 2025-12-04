
class CartController < ApplicationController
  def show
    @cart_items = build_cart_items
  end

  def add
    product_id = params[:product_id].to_s
    current_cart[product_id] ||= 0
    current_cart[product_id] += 1
    redirect_back fallback_location: products_path, notice: 'Added to cart.'
  end

  def update
    product_id = params[:product_id].to_s
    qty = params[:quantity].to_i
    if qty <= 0
      current_cart.delete(product_id)
    else
      current_cart[product_id] = qty
    end
    redirect_to cart_path, notice: 'Cart updated.'
  end

  def remove
    product_id = params[:product_id].to_s
    current_cart.delete(product_id)
    redirect_to cart_path, notice: 'Item removed from cart.'
  end

  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: 'Cart cleared.'
  end

  private

  def build_cart_items
  product_ids = current_cart.keys
  products = Product.where(id: product_ids).index_by(&:id)

  product_ids.filter_map do |pid|
    product = products[pid.to_i]
    next unless product # skip if product was deleted

    quantity   = current_cart[pid].to_i
    unit_price = product.effective_price

    {
      product:  product,
      quantity: quantity,
      subtotal: unit_price * quantity
    }
  end
end

end
