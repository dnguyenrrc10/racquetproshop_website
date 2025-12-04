class Order < ApplicationRecord
  belongs_to :user
  belongs_to :customer, optional: true
  has_many :order_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items


  STATUSES = %w[pending paid shipped cancelled].freeze

  validates :status, inclusion: { in: STATUSES }

  # Tax rates by province/territory
  TAX_RATES = {
    'AB' => { gst: 0.05, pst: 0.0,   hst: 0.0 },
    'BC' => { gst: 0.05, pst: 0.07,  hst: 0.0 },
    'MB' => { gst: 0.05, pst: 0.07,  hst: 0.0 },
    'SK' => { gst: 0.05, pst: 0.06,  hst: 0.0 },
    'QC' => { gst: 0.05, pst: 0.09975, hst: 0.0 },

    'ON' => { gst: 0.0, pst: 0.0,   hst: 0.13 },
    'NB' => { gst: 0.0, pst: 0.0,   hst: 0.15 },
    'NL' => { gst: 0.0, pst: 0.0,   hst: 0.15 },
    'NS' => { gst: 0.0, pst: 0.0,   hst: 0.15 },
    'PE' => { gst: 0.0, pst: 0.0,   hst: 0.15 },

    'NT' => { gst: 0.05, pst: 0.0,   hst: 0.0 },
    'NU' => { gst: 0.05, pst: 0.0,   hst: 0.0 },
    'YT' => { gst: 0.05, pst: 0.0,   hst: 0.0 }
  }.freeze

  def self.tax_breakdown_for(province, subtotal)
    province_code = province.to_s.upcase
    rates = TAX_RATES[province_code] || { gst: 0.05, pst: 0.0, hst: 0.0 }

    gst = (subtotal * rates[:gst]).round(2)
    pst = (subtotal * rates[:pst]).round(2)
    hst = (subtotal * rates[:hst]).round(2)

    { gst: gst, pst: pst, hst: hst }
  end

  def calculate_totals!(province)
  # Use in-memory order_items (even before the order is saved)
  line_subtotals = order_items.map do |item|
    # Ensure subtotal is set
    if item.subtotal.present?
      item.subtotal.to_f
    else
      item.unit_price_at_purchase.to_f * item.quantity.to_i
    end
  end

  self.subtotal = line_subtotals.sum.round(2)

  tax = Order.tax_breakdown_for(province, subtotal)
  self.gst_amount = tax[:gst]
  self.pst_amount = tax[:pst]
  self.hst_amount = tax[:hst]

  self.total_price = subtotal.to_f + gst_amount.to_f + pst_amount.to_f + hst_amount.to_f
end

end
