class Address < ApplicationRecord

  belongs_to :customer
  validates :name, presence: true
  validates :city, presence: true
  validates :postcode, presence: true, format: {with: /\A\d{7}\z/}, numericality: { only_integer: true }

  def order_ship
    self.postcode + self.city + self.name
  end

end
