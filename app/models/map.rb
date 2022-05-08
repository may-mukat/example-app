class Map < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  has_many :location
  has_one_attached :map_image

  def to_param
    name
  end
end
