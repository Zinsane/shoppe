module Shoppe
  class Country < ActiveRecord::Base
  
    # All subdivisions which belong to this country
    has_many :subdivisions, :dependent => :restrict_with_exception, :class_name => 'Shoppe::CountrySubdivision', :foreign_key => 'country_id'
  
    # Used for setting an array of country subdivisions which will be updated. Usually
    # received from a web browser.
    attr_accessor :subdivisions_array
    
    # After saving automatically try to update the subdivisions based on the
    # the contents of the subdivisions_array array.
    after_save do
      if subdivisions_array.is_a?(Array)
        self.subdivisions.update_from_array(subdivisions_array)
      end
    end
  
  end
end
