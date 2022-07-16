class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @customers = Customer.all
  end
  
  def show
    @customers = Customer.find(params[:id])
  end
  
  def edit
    @customers = Customer.find(params[:id])
  end
  
  def update
    @customers = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to admin_customer_path, notice: 'You have updated book successfully'
    else
      render "edit"
    end
  end 
  
end
