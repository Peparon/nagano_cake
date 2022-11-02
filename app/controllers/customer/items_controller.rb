class Customer::ItemsController < ApplicationController

  def top
    @genres = Genre.where(is_active: true)
    @items = Item.all
    @random = Item.order("RANDOM()").limit(4)
  end

  def about
  end

  def index
    @genres = Genre.where(is_active: true)
    if params[:genre_id]
		  @genre = Genre.find(params[:genre_id])
		  @items = @genre.items.where(is_active: true).page(params[:page]).reverse_order
    else
      @items = Item.where(is_active: true).page(params[:page]).reverse_order
    end
  end

  def show
    @item = Item.find(params[:id])
    @genres = Genre.where(is_active: true)
    @cart_item = CartItem.new
  end

  private

	def params_item
		parmas.require(:item).permit(:image ,:name )
	end
end
