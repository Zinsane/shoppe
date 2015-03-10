module Shoppe
  module CountrySubdivisionImporter
    def self.import
      
      subdivisions = File.read(File.join(Shoppe.root, 'db', 'country_subdivisions.txt')).gsub(/\r/, "\n").split("\n").map { |c| c.split(/\t/) }
      subdivisions.each do |code, name, country_code|
        country = Country.find_by_code2 country_code
        subdivision = CountrySubdivision.new(:name => name, :code => code, :country => country)
        subdivision.save
      end
      
    end
  end
end
