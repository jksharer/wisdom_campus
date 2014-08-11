module SessionsHelper
	
  #登陆用户，写入session，将变量@current_user置为刚刚登陆用户
  def sign_in(user)
		session[:user_id] = user.id
    @current_user = user
	end

  # 获取当前已登陆用户
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
    # @current_user ||= User.find(session[:user_id])   # 不能用find! 此处只能用find_by，否则未登陆时报错.
	end

  # 获取用户所在的机构
  def my_agency
    return current_user.agency
  end

  # 注销用户登陆，将session置为无效
	def sign_out
		session[:user_id] = nil
		@current_user = nil
	end

	def authorize
    # 检查是否登陆
    if current_user.nil?
    # unless User.find_by(id: session[:user_id])
      if params[:autologin]
        puts "auto-login......"
        user = User.find_by(username: "default")
        puts user.username
        if user && user.authenticate("12345678")
          sign_in(user)
          redirect_to new_behavior_path(params)
        end
        puts current_user
      else
        redirect_to login_url(params), notice: '请登陆系统.'
        return
      end
    end
    # 检查该操作是否在该用户的功能权限范围之内
		check_if_in_permissions    
  end

  def check_if_in_permissions
    puts params[:controller]
    puts params[:action]
  	current_user.permissions.each do |menu|
  		# if menu.controller == params[:controller]
      if menu.controller.include?(params[:controller])
        return
      end
      # if menu.url.include?(params[:controller])
  		# 	return
  		# end
  	end
  	redirect_to login_url, 
  		notice: "Sorry, 当前用户无操作该功能的权限, 请使用其他用户登陆."	
    return
  end
end