class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :cart_items
  has_many :addresses
  has_many :orders

    validates :last_name, :first_name, :last_name_kana, :first_name_kana, :postcode, :address, :phone_number, presence: true

  def active_for_authentication?
    super &&(self.is_deleted == false)
  end

  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable
end
