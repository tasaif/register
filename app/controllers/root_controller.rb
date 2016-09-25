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
      # If this is a known item respond with the known item otherwise give a template for the new one
      @barcode = params['barcode']
      @item = Item.where(barcode: @barcode).first

      # Neither the item nor the receipt exist
      if @item.nil? and @receipt.nil?
        response['item'] = Item.new(barcode: @barcode)
        response['receipt'] = Receipt.new

      # The item doesn't exist, but the receipt does
      elsif @item.nil? and !@receipt.nil?
        response['item'] = Item.new(barcode: @barcode)
        response['receipt'] = @receipt

      # The item exists, but a receipt doesn't
      elsif !@item.nil? and @receipt.nil?
        response['item'] = @item
        if should_create_receipt
          @receipt = Receipt.create
          @line_item = LineItem.create(item_id: @item.id, receipt_id: @receipt.id)
          @item.stamp @line_item
          response['receipt'] = @receipt
        else
          response['receipt'] = Receipt.new
        end

      # The item exists, and the receipt exists
      elsif !@item.nil? and !@receipt.nil?
        response['item'] = @item
        response['receipt'] = @receipt
        @line_item = LineItem.create(item_id: @item.id, receipt_id: @receipt.id)
      end

      render json: response
    end
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
    @item.stamp @line_item
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
