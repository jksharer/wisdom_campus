class AddIndexForUsersRoles < ActiveRecord::Migration
  def change
  	add_index :users_roles, :user_id
    add_index :users_roles, :role_id
    add_index :users_roles,[:user_id, :role_id], unique: true
  end
end
