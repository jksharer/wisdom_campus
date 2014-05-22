class Menu < ActiveRecord::Base
	has_many :sub_menus, class_name: "Menu", foreign_key: "parent_menu_id"
	belongs_to :parent_menu, class_name: "Menu"
	has_and_belongs_to_many :roles

	validates :name, presence: true, uniqueness: true
	validates :url, presence: true
	validates :status, presence: true, inclusion: { in: [1, 0] }
	validates :display_order, numericality: { greater_than: 0 }
	

	def is_one_level?
		self.parent_menu_id.nil?
	end

	def has_kids?
		self.sub_menus.count > 0
	end
end