class Admin::DashboardController < Admin::BaseController
  def index
    @orders_count = Order.count
    @products_count = Product.count
    @users_count = User.count
  end
end
