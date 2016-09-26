class LineItem < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :item

  def barcode
    item.barcode
  end
  def tax_amount
    if tax
      if pp
        retval = price * weight
      else
        retval = price
      end
      retval *= Rails.application.config.sales_tax
      retval = retval.round(2)
    else
      0.0
    end
  end
  def price
    item.price
  end
  def cost(pretax=false)
    if pp
      retval = price * weight
    else
      retval = price
    end
    retval += tax_amount if !pretax
    retval.round(2)
  end

  def barcode_pretty
    item.barcode
  end
  def tax_pretty
    "%.2f" % tax_amount
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
