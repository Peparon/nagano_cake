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
      @order.postcode = current_customer.postcode
      @order.address = current_customer.address
      @order.name = current_customer.last_name + " " + current_customer.first_name
      render 'confirm'
    elsif params[:order][:address_option] == "1"
      @ship_city = ShipCity.find(params[:order][:id])
      @order.postcode = @ship_city.postcode
      @order.address = @ship_city.address
      @order.name = @ship_city.name
      render 'confirm'
    elsif params[:order][:address_option] == "2"
      @ship_city = current_customer.addresses.new
      @ship_city.address = params[:order][:address]
      @ship_city.name = params[:order][:name]
      @ship_city.postcode = params[:order][:postcode]
      @ship_city.customer_id = current_customer.id
      if @ship_city.save
      @order.postcode = @ship_city.postcode
      @order.name = @ship_city.name
      @order.address = @ship_city.address
      else
       render 'new'
      end
    end
  end

  def thanks
  end

  private

  def order_params
    params.require(:order).permit(:payment, :postcode, :address, :name, :shipping, :total_fee)
  end

  def ship_city_params
    params.require(:ship_city).permit(:customer_id, :postcode, :address, :name)
  end
end
