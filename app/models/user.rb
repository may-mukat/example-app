class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, length: { maximum: 254 }, uniqueness: true
  validates :password, length: { in: 10..30 }, confirmation: true
  validates :password_confirmation, presence: true

  has_many :location

end
