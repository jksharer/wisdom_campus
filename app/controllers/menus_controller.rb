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
        format.js { 
          @menus = Menu.where(parent_menu_id: nil).order('display_order asc')
          flash.now[:notice] = 'Menu was successfully created.'
          render 'index.js.erb' 
        }
        format.html { redirect_to menus_url, 
          notice: 'Menu was successfully created.' }
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
          render 'new.js.erb' 
        }
        format.html { redirect_to menus_url, 
          notice: 'Menu was successfully updated.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @menus = Menu.where(parent_menu_id: nil).order('display_order asc')
    if @menu.sub_menus.size > 0
      respond_to do |format|
        format.js { 
          flash.now[:notice] = "The menu has sub menus, you can't delete it."
          render 'index.js.erb'
        }
        format.html {
          redirect_to menus_path, notice: "The menu has sub menus, you can't delete it."
        }
      end
    else
      @menu.roles.clear
      @menu.destroy
      respond_to do |format|
        format.js {
          flash.now[:notice] = "The menu #{@menu.name} deleted."
          render 'index.js.erb'  
        }
        format.html { redirect_to menus_url }
      end
    end
  end

  private
    def set_menu
      @menu = Menu.find(params[:id])
    end

    def menu_params
      params.require(:menu).permit(:name, :url, :controller, :action, :parent_menu_id, :status, :display_order)
    end
end