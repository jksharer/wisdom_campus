class ChangeTypeColumnForAnnouncement < ActiveRecord::Migration
  def change
  	change_table :announcements do |t|
  		t.rename :type, :announcement_type
  	end
  end
end
