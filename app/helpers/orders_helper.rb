module OrdersHelper
  def tax_rate_percentage(amount, subtotal)
    return nil if subtotal.to_f <= 0 || amount.to_f <= 0
    ((amount.to_f / subtotal.to_f) * 100).round(1) # e.g. 5.0 => 5.0%
  end
end
