class AddAgencyForBehavior < ActiveRecord::Migration
  def change
  	add_reference :behaviors, :agency, index: true
  end
end
