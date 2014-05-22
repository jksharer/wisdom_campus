module SessionsHelper
	
  #登陆用户，写入session，将变量@current_user置为刚刚登陆用户
  def sign_in(user)
		session[:user_id] = user.id
    @current_user = user
	end

  # 获取当前已登陆用户
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
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
      redirect_to login_url, notice: 'Please log in.'
      return
    end
    # 检查该操作是否在该用户的功能权限范围之内
		check_if_in_permissions    
  end

  def check_if_in_permissions
  	current_user.permissions.each do |menu|
  		if menu.url.include?(params[:controller])
  			return
  		end
  	end
  	redirect_to login_url, 
  		notice: "Sorry, the current user does not have the permission, 
  							please use other user to access."	
    return
  end
end