class RenamePhotoUrlForStudents < ActiveRecord::Migration
  def change
  	change_table :students do |t|
  		t.rename :photo_url, :photo
  	end
  end
end
