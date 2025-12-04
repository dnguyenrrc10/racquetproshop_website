class PagesController < ApplicationController
  def home
    @categories = Category.all
    @featured_products = Product.racquets.limit(8)
  end

  def about
    @page = Page.find_by!(slug: 'about')
  end

  def contact
    @page = Page.find_by!(slug: 'contact')
  end
end
