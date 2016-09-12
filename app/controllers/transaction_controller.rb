class TransactionController < ApplicationController
  def new
    data = params['data']
    @receipt = Receipt.create
    if (/^\d.*\.\d{2}$/.match(data))
      @amount = data.to_f
      render 'manual_item'
    else
      @code = data
      @inventory = Inventory.first
      binding.pry
      render 'scanned_item'
    end
  end
end
