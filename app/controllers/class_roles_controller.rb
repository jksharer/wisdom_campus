class ClassRolesController < ApplicationController
  before_action :set_class_role, only: [:show, :edit, :update, :destroy]

  def index
    @class_roles = ClassRole.all
    render 'shared/link.js.erb'
  end

  def show
  end

  def new
    @class_role = ClassRole.new
  end

  def edit
    respond_to do |format|
      format.js { render 'new.js.erb' }
      format.html
    end    
  end

  def create
    @class_role = ClassRole.new(class_role_params)

    respond_to do |format|
      if @class_role.save
        format.js {
          @class_roles = ClassRole.all
          flash.now[:notice] = 'Class role was successfully created.'
          render 'index.js.erb'     
        }
        format.html { redirect_to @class_role, notice: 'Class role was successfully created.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @class_role.update(class_role_params)
        format.js {
          @class_roles = ClassRole.all
          flash.now[:notice] = 'Class role was successfully updated.'
          render 'index.js.erb'     
        }
        format.html { redirect_to @class_role, notice: 'Class role was successfully updated.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    if @class_role.students.empty?
      @class_role.destroy
      respond_to do |format|
        format.js {
          @class_roles = ClassRole.all
          flash.now[:notice] = 'Class role was successfully deleted.'
          render 'index.js.erb'     
        }
        format.html { redirect_to class_roles_url }
      end
    else
      respond_to do |format|
        format.js {
          @class_roles = ClassRole.all
          flash.now[:alert] = 'You should not delete this class role.'
          render 'index.js.erb'  
        }
        format.html { redirect_to class_roles_url }
      end
    end
  end

  private
    def set_class_role
      @class_role = ClassRole.find(params[:id])
    end

    def class_role_params
      params.require(:class_role).permit(:name, :description)
    end
end