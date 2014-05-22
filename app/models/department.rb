class Department < ActiveRecord::Base
	belongs_to :agency
	has_many :users
	
	has_many :sub_departments, class_name: "Department", foreign_key: "parent_department_id"
	belongs_to :parent_department, class_name: "Department"

	validates :name, presence: true, length: { maximum: 20 }, uniqueness: { scope: :agency,
		message: ": One agency should not have 2 same departments." }
	validates :description, length: { maximum: 200 }

end
