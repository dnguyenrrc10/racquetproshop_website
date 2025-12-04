class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create, :update, :destroy]

  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    if @line_item.save
      redirect_to cart_path(@cart), notice: "Product added to cart."
    else
      redirect_to products_path, alert: "Could not add product."
    end
  end
end
