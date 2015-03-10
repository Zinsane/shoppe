module Shoppe
  module AssociatedCountrySubdivisions
    
    def self.included(base)
      base.serialize :country_subdivision_ids, Array
      base.before_validation { self.country_subdivision_ids = self.country_subdivision_ids.map(&:to_i).select { |i| i > 0} if self.country_subdivision_ids.is_a?(Array) }
    end
    
    def country_subdivision?(id)
      id = id.id if id.is_a?(Shoppe::CountrySubdivision)
      self.country_subdivision_ids.is_a?(Array) && self.country_subdivision_ids.include?(id.to_i)
    end
    
    def country_subdivisions
      return [] unless self.country_subdivision_ids.is_a?(Array) && !self.country_subdivision_ids.empty?
      Shoppe::CountrySubdivision.where(:id => self.country_subdivision_ids)
    end
    
  end
end