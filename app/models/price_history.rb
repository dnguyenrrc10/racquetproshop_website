class PriceHistory < ApplicationRecord
  belongs_to :product

  validates :old_price, :new_price, presence: true
end

