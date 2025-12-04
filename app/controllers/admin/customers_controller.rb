class Admin::CustomersController < Admin::BaseController
  def index
    # Only customers who actually have orders
    @customers = User
                   .joins(:orders)
                   .distinct
                   .includes(orders: { order_items: :product })
                   .order(:email)
  end

  def show
    @customer = User
                  .includes(orders: { order_items: :product })
                  .find(params[:id])
  end
end
