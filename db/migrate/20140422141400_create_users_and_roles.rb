class CreateUsersAndRoles < ActiveRecord::Migration
  def change
    create_table :users_roles, id: false do |t|
    	t.belongs_to :user
    	t.belongs_to :role

    	t.timestamps
    end
  end
end