module Shoppe
  class TaxRate < ActiveRecord::Base
    
    self.table_name = 'shoppe_tax_rates'
    
    include Shoppe::AssociatedCountries
    include Shoppe::AssociatedCountrySubdivisions
    
    # The order address types which may be used when choosing how to apply the tax rate
    ADDRESS_TYPES = ['billing', 'delivery']
    
    # Validations
    validates :name, :presence => true
    validates :address_type, :inclusion => {:in => ADDRESS_TYPES}
    validates :rate, :numericality => true
    
    # All products which are assigned to this tax rate
    has_many :products, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Product'
    
    # All delivery service prices which are assigned to this tax rate
    has_many :delivery_service_prices, :dependent => :restrict_with_exception, :class_name => 'Shoppe::DeliveryServicePrice'
    
    # All tax rates ordered by their ID
    scope :ordered, -> { order(:id)}
    
    # Set the address type if appropriate
    before_validation { self.address_type = ADDRESS_TYPES.first if self.address_type.blank? }
    
    # A description of the tax rate including its name & percentage
    #
    # @return [String]
    def description
      "#{name} (#{rate}%)"
    end
    
    # The rate for a given order based on the rules on the tax rate
    #
    # @return [BigDecimal]
    def rate_for(order)
      return rate if countries.empty? && country_subdivisions.empty?
      
      case address_type
      when 'billing'
        country = order.billing_country
        subdivision = order.billing_subdivision
      when 'delivery'
        country = order.delivery_country
        subdivision = order.delivery_subdivision
      end
      
      return rate if (country.nil? || country?(country)) && (subdivision.nil? || country_subdivision?(subdivision)) 

      BigDecimal(0)
    end
    
  end
end
