class Customer < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates :province, presence: true
end
