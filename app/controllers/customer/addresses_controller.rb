class Customer::AddressesController < ApplicationController
 
 before_action :authenticate_customer!

 def index
  @addresses = current_customer.addresses
  @address = Address.new
 end

 def create
  @address = Address.new(address_params)
  @address.customer_id = current_customer.id
  if @address.save
   flash[:notice] = "You have created Shipping address successfully."
   redirect_to addresses_path
  else
   @addresses = current_customer.addresses
   render 'index'
  end
 end

 def edit
  @address = Address.find(params[:id])
 end

 def update
  @address = Address.find(params[:id])
   if @address.update(address_params)
     flash[:notice] = "address was successfully updated"
     redirect_to addresses_path
   else
     render "edit"
   end
 end

 def destroy
  @address = Address.find(params[:id])
  @address.destroy
  @address = current_customer.addresses
  flash[:notice] = "address was successfully deleted"
  redirect_to addresses_path
 end

 private
 def address_params
  params.require(:address).permit(:post_code, :address, :name)
 end
end
