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
    receipt_id = (if params['receipt_id'] == '' then nil else params['receipt_id'].to_i end)
    @receipt = Receipt.where(id: receipt_id).first
    should_create_receipt = params['implicit_receipt'] == 'true'
    response = {}
    if source == "barcode"
      @barcode = params['barcode']
      @item = Item.where(barcode: @barcode).first
      response['item'] = (if @item.nil? then Item.new(barcode: @barcode) else @item end)
    end
    if @receipt.nil?
      if should_create_receipt and !@item.nil?
        @receipt = Receipt.create
        response['receipt'] = @receipt
        @line_item = LineItem.create(item_id: @item.id, receipt_id: @receipt.id)
      else
        response['receipt'] = Receipt.new
      end
    else
      response['receipt'] = @receipt
    end
    render json: response
  end
  def create_item
    receipt_id = (if params['receipt_id'] == '' then nil else params['receipt_id'].to_i end)
    @receipt = Receipt.where(id: receipt_id).first
    if @receipt.nil?
      @receipt = Receipt.create
    end
    barcode = params['barcode']
    price = params['price'].to_f
    tax = params['tax']
    pp = params['pp']
    @item = Item.create barcode: barcode, price: price, tax: tax, pp: pp
    @line_item = LineItem.create(item_id: @item.id, receipt_id: @receipt.id)
    @receipt.line_items.push @line_item
    resp = {receipt: @receipt, item: @item, line_item: @line_item, line_items: @receipt.lines_to_items}
    render json: resp
  end
  def update_receipt_display
    receipt_id = (if params['receipt_id'] == '' then nil else params['receipt_id'].to_i end)
    @receipt = Receipt.where(id: receipt_id).first
    render partial: 'line_items'
  end
end
