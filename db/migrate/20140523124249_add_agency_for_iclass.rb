class AddAgencyForIclass < ActiveRecord::Migration
  def change
  	add_reference :iclasses, :agency, index: true
  end
end