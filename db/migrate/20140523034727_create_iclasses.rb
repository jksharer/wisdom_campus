class CreateIclasses < ActiveRecord::Migration
  def change
    create_table :iclasses do |t|
      t.string :name
      t.references :grade, index: true
      t.string :header

      t.timestamps
    end
  end
end