class CreateCountrySubdivisions < ActiveRecord::Migration
  def change
    create_table :shoppe_country_subdivisions do |t|
      t.belongs_to :country
      t.string  :name
      t.string  :code
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
