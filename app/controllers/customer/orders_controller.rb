class Customer::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def index
    @orders = current_customer.orders.all.page(params[:page]).per(6).order('created_at DESC')
  end

  def new
    @order = Order.new
    @customer = current_customer
    @addresses = current_customer.addresses
  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    if @order.save!
      @cart_items = current_customer.cart_items
      @cart_items.each do |cart_item|
        order_detail = OrderDetail.new(order_id: @order.id)
        order_detail.price = cart_item.item.price
        order_detail.amount = cart_item.amount
        order_detail.item_id = cart_item.item_id
        order_detail.save!
      end
      @cart_items.destroy_all
      redirect_to orders_thanks_path
    else
      render "new"
    end
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details.all
  end

  def confirm
    @cart_items = current_customer.cart_items
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.payment = params[:order][:payment]
    @total_price = current_customer.cart_items.cart_items_total_price(@cart_items)
    @order.shipping = 800

    if params[:order][:address_option] == "0"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + " " + current_customer.first_name
      render 'confirm'
    elsif params[:order][:address_option] == "1"
      @address = Address.find(params[:order][:id])
      @order.post_code = @address.post_code
      @order.address = @address.address
      @order.name = @address.name
      render 'confirm'
    elsif params[:order][:address_option] == "2"
      @address = current_customer.addresses.new
      @address.address = params[:order][:address]
      @address.name = params[:order][:name]
      @address.post_code = params[:order][:post_code]
      @address.customer_id = current_customer.id
      if @address.save
      @order.post_code = @address.post_code
      @order.name = @address.name
      @order.address = @address.address
      else
       render 'new'
      end
    end
  end

  def thanks
  end

  private

  def order_params
    params.require(:order).permit(:payment, :post_code, :address, :name, :shipping, :total_payment)
  end

  def address_params
    params.require(:address).permit(:customer_id, :post_code, :address, :name)
  end
end
