class ItemsController < ApplicationController
  def new
    @code = params['code']
    @receipt_id = params['receipt_id'].to_i
    @item = Item.new
  end
  def create
    receipt = Receipt.where(id: params['receipt_id'].to_i).first
    code = params['code']
    price = params['price'].to_f
    tax = params['tax'].to_i
    pp = params['pp'].to_i
    @item = Item.create(code: code, price: price, tax: tax, pp: pp)
    binding.pry
  end
  def update
    binding.pry
  end
end
