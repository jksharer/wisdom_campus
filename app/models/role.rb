class Role < ActiveRecord::Base
	validates :name, presence: true, uniqueness: { scope: :agency,  
		message: ": 已经存在名称相同的角色啦." }

	#如果表名为roles_users，则无需制定表名
	has_and_belongs_to_many :users, -> { uniq }, :join_table => 'users_roles'
	has_and_belongs_to_many :menus

	belongs_to :agency

end