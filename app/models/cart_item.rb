class CartItem < ApplicationRecord
  
    belongs_to :item, optional: true
    belongs_to :customer, optional: true

    validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

    def sub_total
    (item.price * amount * 1.1).floor
    end

    def self.cart_items_total_price(cart_items)
    array = []
    cart_items.each do |cart_item|
      array << cart_item.item.price * cart_item.amount
    end
    return (array.sum * 1.1).floor
    end
    
end
