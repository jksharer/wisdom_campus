class User < ActiveRecord::Base
  attr_accessor :for_updating           # 用于在更新用户信息时跳过密码验证

  has_secure_password

  belongs_to :agency
  belongs_to :department
  has_many :steps
  has_many :announcements

  validates :username, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :password, length: { in: 3..20 }, 
    unless: Proc.new { |a| a.for_updating }
  validates :agency, presence: true

  has_and_belongs_to_many :roles, -> { uniq }, :join_table => 'users_roles'   # user和role的组合必须唯一

  def updating_userinfo

  end

  # 获取用户所拥有角色下的所有菜单权限
  def permissions
  	permissions = []
  	self.roles.each	do |role|
  		permissions |= role.menus
  	end
  	return permissions
  end

  def one_level_menus
    Menu.where(parent_menu_id: nil).order('display_order asc').
      find_all { |menu| permissions.include?(menu) }
  end

  # 获取用户某个一级菜单下的二级菜单权限
	def sub_menus(parent_menu)
		(parent_menu.sub_menus & permissions).sort { |ma, mb| ma.display_order <=> mb.display_order }
	end  
end