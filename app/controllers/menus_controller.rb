class MenusController < ApplicationController
  before_action :authorize
  before_action :set_menu, only: [:show, :edit, :update, :destroy]
  
  def index
    @menus = Menu.where(parent_menu_id: nil).order('display_order asc')
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    
  end

  def new
    @menu = Menu.new
  end

  def edit
    respond_to do |format|
      format.js { render 'new.js.erb' }
      format.html
    end
  end

  def create
    @menu = Menu.new(menu_params)
    respond_to do |format|
      if @menu.save
        flash.now[:notice] = '模块添加成功.'
        format.js { 
          @menus = Menu.where(parent_menu_id: nil).order('display_order asc')
          render 'index.js.erb' 
        }
        format.html { redirect_to menus_url }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'new', layout: 'empty' }
      end
    end
  end

  def update
    respond_to do |format|
      if @menu.update(menu_params)
        format.js {
          @menus = Menu.where(parent_menu_id: nil).order('display_order asc') 
          render 'index.js.erb' 
        }
      else
        format.js { render 'new.js.erb' }
      end
    end
  end

  def destroy
    @menus = Menu.where(parent_menu_id: nil).order('display_order asc')
    if @menu.sub_menus.size > 0
      respond_to do |format|
        format.js { 
          flash.now[:notice] = '该菜单有子菜单, 不可删除.'
          render 'index.js.erb'
        }
      end
    else
      @menu.roles.clear
      @menu.destroy
      respond_to do |format|
        format.js {
          flash.now[:notice] = '菜单删除成功.'
          render 'index.js.erb'  
        }
        format.html { redirect_to menus_url }
      end
    end
  end

  private
    def set_menu
      @menu = Menu.find_by(id: params[:id])
    end

    def menu_params
      params.require(:menu).permit(:name, :url, :controller, :action, :parent_menu_id, :status, :display_order, :icon)
    end
end