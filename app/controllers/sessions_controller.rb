class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(username: params[:session][:username])
  	if user && user.authenticate(params[:session][:password])
  		sign_in(user)
  		redirect_to root_url
  	else 
      redirect_to login_url, alert: "Invalid username/password combination."
  	end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: "You have loged out."
  end
end