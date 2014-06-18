class SessionsController < ApplicationController
  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
  	user = User.find_by(username: params[:session][:username])
  	if user && user.authenticate(params[:session][:password])
  		sign_in(user)
  		redirect_to root_url
  	else 
      redirect_to login_url, alert: "错误的用户名和密码组合, 请重新输入."
  	end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: "您已退出系统."
  end
end