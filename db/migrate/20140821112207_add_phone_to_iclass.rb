class AddPhoneToIclass < ActiveRecord::Migration
  def change
    add_column :iclasses, :phone, :string
  end
end