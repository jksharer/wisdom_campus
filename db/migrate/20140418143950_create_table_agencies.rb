class CreateTableAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :description
      t.references :higher_agency

      t.timestamps
    end
  end
end
