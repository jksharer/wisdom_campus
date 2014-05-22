class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :name
      t.string :type
      t.text :content
      t.string :workflow_state

      t.timestamps
    end
  end
end
