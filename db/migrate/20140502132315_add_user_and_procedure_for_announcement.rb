class AddUserAndProcedureForAnnouncement < ActiveRecord::Migration
  def change
  	add_reference :announcements, :user, index: true
  	add_reference :announcements, :procedure, index: true 
  end
end