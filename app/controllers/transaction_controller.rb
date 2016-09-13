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
      if (@inventory.items.where(code: @code).count == 0)
        redirect_to controller: 'items', action: 'new', code: @code, receipt_id: @receipt.id
      else
        render 'add_item'
      end
    end
  end
end
