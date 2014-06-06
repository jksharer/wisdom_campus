class CreateSms < ActiveRecord::Migration
  def change
    create_table :sms do |t|
      t.string :mid
      t.string :phone
      t.string :content
      t.datetime :send_time
      t.string :status
      t.references :behavior
      t.references :agency

      t.timestamps
    end
  end
end
