class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, length: { maximum: 254 }, uniqueness: true, on: [:create, :update_email]
  validates :password, length: { minimum: 10, maximum: 30 }, confirmation: true, on: [:create, :update_password]
  validates :password_confirmation, presence: true, on: [:create, :update_password]

  has_many :location

end
