class CartItem < ApplicationRecord
  
    belongs_to :item, optional: true
    belongs_to :customer, optional: true

    validates :amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

    def sub_total
    (product.price * amount * 1.1).floor
    end

    def self.cart_items_total_price(cart_products)
    array = []
    cart_products.each do |cart_product|
      array << cart_product.product.price * cart_product.amount
    end
    return (array.sum * 1.1).floor
    end
    
end
