class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.string :url
      t.integer :status
      t.integer :order
      t.references :parent_menu

      t.timestamps
    end
  end
end
