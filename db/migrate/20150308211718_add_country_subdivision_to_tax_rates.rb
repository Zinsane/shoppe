class AddCountrySubdivisionToTaxRates < ActiveRecord::Migration
  def change
    add_column :shoppe_tax_rates, :country_subdivision_ids, :text
  end
end
