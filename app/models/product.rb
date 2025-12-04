class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :price_histories, dependent: :destroy

  validates :name, presence: true
  validates :current_price, presence: true, numericality: { greater_than_or_equal_to: 0 }




  scope :racquets, -> { joins(:category).where(categories: { name: 'Racquets' }) }
  scope :on_sale, -> { where.not(sale_price: nil) }
  scope :new_products, -> { where("created_at >= ?", 3.days.ago) }

  def effective_price
    sale_price.present? ? sale_price : current_price
  end

end

