class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  before_validation :set_unit_price
  before_validation :set_subtotal

  private

  def set_unit_price
    # 🔹 Use the sale price if available when order item is created
    self.unit_price_at_purchase ||= product.effective_price
  end

  def set_subtotal
    self.subtotal = unit_price_at_purchase.to_f * quantity.to_i
  end
end
