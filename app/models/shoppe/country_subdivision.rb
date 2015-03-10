module Shoppe
  
  # The Shoppe::CountrySubdivision model stores states/provinces which can be used for delivery & billing
  # addresses for orders.
  #
  # You can use the Shoppe::CountrySubdivisionImporter to import a pre-defined list of country subdivisions 
  # into your database. This automatically happens when you run the 'shoppe:setup' 
  # rake task.
  
  class CountrySubdivision < ActiveRecord::Base
    
    self.table_name = 'shoppe_country_subdivisions'
    
    belongs_to :country, :class_name => 'Shoppe::Country'
    
    # All orders which have this subdivision set as their billing subdivision
    has_many :billed_orders, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Order', :foreign_key => 'billing_subdivision_id'
    
    # All orders which have this subdivision set as their delivery subdivision
    has_many :delivered_orders, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Order', :foreign_key => 'delivery_subdivision_id'
    
    # All subdivisions ordered by their name asending
    scope :ordered, -> { order(:name => :asc) }
    
    # Validations
    validates :name, :presence => true
  
    # Create/update subdivisions for a country.
    #
    # @param array [Array]
    def self.update_from_array(array)
      existing_codes = self.pluck(:code)
      array.each do |hash|
        next if hash['code'].blank?
        params = hash
        if existing_attr = self.where(:code => hash['code']).first
          if hash['name'].blank?
            existing_attr.destroy
          else
            existing_attr.update_attributes(params)
          end
        else
          attribute = self.create(params)
        end
      end
      self.where(:code => existing_codes - array.map { |h| h['code']}).delete_all
      true
    end
    
  end
end
