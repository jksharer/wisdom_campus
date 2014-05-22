class ApplicationController < ActionController::Base
  include SessionsHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :detect_device_type
  before_action :set_two_level_menus
 
  def set_two_level_menus
    #点击顶部导航栏一级菜单
    if params[:parent]  
      @current_menu = Menu.find(params[:parent]) 
      @two_level_menus = current_user.sub_menus(@current_menu) 
    #点击左侧导航二级菜单  
    elsif params[:menu_id]
      @current_menu = Menu.find(params[:menu_id])
      @two_level_menus = current_user.sub_menus(@current_menu.parent_menu)
    #从其他途径访问系统  
    else
      unless current_user.nil?
        @current_menu = current_user.one_level_menus.first
        @two_level_menus = current_user.sub_menus(@current_menu)
      end
    end
  end

  private
	  def detect_device_type
	    case request.user_agent
      when /iPad/i
        request.variant = :tablet
      when /iPhone/i
        request.variant = :phone
      when /Android/i && /mobile/i
        request.variant = :phone
      when /Android/i
        request.variant = :tablet
      when /Windows Phone/i
        request.variant = :phone
      end
	  end
end