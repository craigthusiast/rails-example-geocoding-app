class Location < ApplicationRecord
  belongs_to :neighbourhood

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  def self.nearest_neighbourhood(coords)
    # self.near(coords, 2, units: :km).first.neighbourhood # returns first location's neighbourhood
    # self.near(coords, 2, units: :km).first(2) # returns an array containing first 2 locations

    nearest_neighbourhoods = self.near(coords, 2, units: :km).first(5) # array of first 5 locations
    hoods = []
    nearest_neighbourhoods.each do |loc|
      hoods << loc.neighbourhood.name  # loc.neighbourhood.name returns :name string
    end
    hoods

  end

end
