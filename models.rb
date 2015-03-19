class Blip < ActiveRecord::Base
  validates :city, presence: true
  validates :country, presence: true
end