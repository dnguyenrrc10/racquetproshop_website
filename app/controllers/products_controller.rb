class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.includes(:category).order(:name)

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    if params[:q].present?
      term = "%#{params[:q]}%"
      @products = @products.where('products.name ILIKE ? OR products.description ILIKE ?', term, term)
    end
     # Filter by ON SALE products
  if params[:filter] == "sale"
    @products = @products.on_sale
  end

  # Filter by NEW products (added within 3 days)
  if params[:filter] == "new"
    @products = @products.new_products
  end
  end

  def show
    @product = Product.find(params[:id])
  end
end
