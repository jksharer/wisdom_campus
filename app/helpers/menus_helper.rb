module MenusHelper

	# 根据controller名称找到相应的二级菜单
	def find_menu(controller_name)
		Menu.where(controller: controller_name).each do |menu|
			return menu if menu.parent_menu
		end
	end

	def two_level_menus
		menus = []
		Menu.all.map { |menu| menus << menu unless menu.parent_menu.nil? }
		return menus
	end
end