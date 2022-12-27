class Customer::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @cart_items = current_customer.cart_items
    @cart_items = CartItem.new
    @total_price = current_customer.cart_items.cart_items_total_price(@cart_items)
  end

  def update
    @cart_item = CartItem.where(params[:id])
    if params[:cart_item][:amount] == "0"
      @cart_item.destroy
      redirect_to cart_items_path
    elsif @cart_item.update(amount: params[:cart_item][:amount])
      redirect_to cart_items_path
    else
      @cart_items = current_customer.cart_items
      @total_price = current_customer.cart_items.cart_items_total_price(@cart_items)
      render "cart_items/index"
    end
  end

  def create
    @cart_item = current_customer.cart_items.new(params_cart_item)
    if current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id]).present?
      cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
      cart_item.amount += params[:cart_item][:amount].to_i
      cart_item.save
      redirect_to cart_items_path
    elsif @cart_item.save!
      redirect_to cart_items_path
    end
  end

  def destroy
    current_customer.cart_items.find(params[:id]).destroy
    redirect_to cart_items_path
  end

  def destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path
  end

  def params_cart_item
    params.require(:cart_item).permit(:amount, :item_id)
  end
end
