class Customer::AddressesController < ApplicationController
 
 before_action :authenticate_customer!

 def index
  @addresses = current_customer.addresses
  @ship_city = ShipCity.new
 end

 def create
  @ship_city = ShipCity.new(ship_city_params)
  @ship_city.customer_id = current_customer.id
  if @ship_city.save
   flash[:notice] = "You have created Shipping address successfully."#英語に統一
   redirect_to addresses_path
  else
   @addresses = current_customer.addresses
   render 'index'
  end
 end

 def edit
  @ship_city = ShipCity.find(params[:id])
 end

 def update
  @ship_city = ShipCity.find(params[:id])
   if @ship_city.update(ship_city_params)
     flash[:notice] = "address was successfully updated"
     redirect_to addresses_path
   else
     render "edit"
   end
 end

 def destroy
  @ship_city = ShipCity.find(params[:id])
  @ship_city.destroy
  @ship_city = current_customer.addresses
  flash[:notice] = "address was successfully deleted"
  redirect_to addresses_path
 end

 private
 def ship_city_params
  params.require(:ship_city).permit(:postcode, :address, :name)
 end
end
