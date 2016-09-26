class LineItem < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :item

  def barcode
    item.barcode
  end
  def tax
    if item.tax
      (Rails.application.config.sales_tax * item.price).round(2)
    else
      0.0
    end
  end
  def price
    item.price
  end
  def cost
    (price + price * tax).round(2)
  end

  def barcode_pretty
    item.barcode
  end
  def tax_pretty
    "%.2f" % tax
  end
  def price_pretty
    retval = "%.2f" % price
    retval = "#{retval}/lb" if pp
    retval
  end
  def weight_pretty
    if pp
      weight
    else
      return ""
    end
  end
  def cost_pretty
    "%.2f" % cost
  end
end
