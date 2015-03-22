class Blip < ActiveRecord::Base
  validates :city, presence: true
  validates :country, presence: true
end

class FacebookKey < ActiveRecord::Base
end