class LineItem < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :item

  def barcode
    item.barcode
  end
  def tax
    if item.tax
      Rails.application.config.sales_tax * item.price
    else
      0.0
    end
  end
  def price
    item.price
  end
  def cost
    price + price * tax
  end
end
