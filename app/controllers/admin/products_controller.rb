class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.includes(:category).order(:name)
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: 'Product created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    old_price = @product.current_price
    if @product.update(product_params)
      if old_price != @product.current_price
        @product.price_histories.create!(
          old_price: old_price,
          new_price: @product.current_price,
          changed_at: Time.current
        )
      end
      redirect_to admin_products_path, notice: 'Product updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: 'Product deleted.'
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :current_price, :sale_price, :category_id)
  end
end
