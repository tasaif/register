class RootController < ApplicationController
  def neutral
  end
  def new_receipt
    source = params['source']
    if source == "barcode"
      @barcode = params['barcode']
      @item = Item.where(barcode: @barcode).first
      if @item.nil?
        @item = Item.new
        render "new_item", layout: false
      end
    end
    @receipt = Receipt.create
  end
  def add_item
    source = params['source']
    if source == "barcode"
      @barcode = params['barcode']
      @item = Item.where(barcode: @barcode).first
      render json: @item
    end
  end
  def create_item
    barcode = params['barcode']
    price = params['price'].to_f
    tax = params['tax']
    pp = params['pp']
    @item = Item.create barcode: barcode, price: price, tax: tax, pp: pp
    render json: @item
  end
end
