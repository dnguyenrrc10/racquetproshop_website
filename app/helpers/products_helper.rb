module ProductsHelper
  def display_price(product)
    if product.sale_price.present?
      content_tag(:span, number_to_currency(product.current_price), class: "price-original") +
      content_tag(:span, number_to_currency(product.sale_price), class: "price-sale")
    else
      content_tag(:span, number_to_currency(product.current_price), class: "product-card-price")
    end
  end

  def product_badges(product)
    badges = []
    badges << content_tag(:span, "SALE", class: "badge-sale") if product.sale_price.present?
    badges << content_tag(:span, "NEW", class: "badge-new") if product.created_at >= 3.days.ago
    badges.join(" ").html_safe
  end
end
