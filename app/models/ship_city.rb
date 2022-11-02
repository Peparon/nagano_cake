class Address < ApplicationRecord

  belongs_to :customer
  validates :name, presence: true
  validates :address, presence: true
  validates :post_code, presence: true, format: {with: /\A\d{7}\z/}, numericality: { only_integer: true }

  def order_ship
    self.postcode + self.address + self.name
  end

end
