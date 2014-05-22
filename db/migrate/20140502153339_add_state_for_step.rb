class AddStateForStep < ActiveRecord::Migration
  def change
  	add_column :announcements, :state, :string, :default => "initial"
  end
end