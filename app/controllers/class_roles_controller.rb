class ClassRolesController < ApplicationController
  before_action :set_class_role, only: [:show, :edit, :update, :destroy]
  before_action :authorize
  
  def index
    @class_roles = ClassRole.all
    render 'shared/link.js.erb'
  end

  def show
  end

  def new
    @class_role = ClassRole.new
    render 'shared/new.js.erb'
  end

  def edit
    render 'shared/new.js.erb'
  end

  def create
    @class_role = ClassRole.new(class_role_params)
    respond_to do |format|
      if @class_role.save
        format.js {
          @class_roles = ClassRole.all
          flash.now[:notice] = 'Class role was successfully created.'
          render 'shared/link.js.erb'     
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def update
    respond_to do |format|
      if @class_role.update(class_role_params)
        format.js {
          @class_roles = ClassRole.all
          flash.now[:notice] = 'Class role was successfully updated.'
          render 'shared/link.js.erb'     
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def destroy
    if @class_role.students.empty?
      @class_role.destroy
      respond_to do |format|
        format.js {
          flash.now[:notice] = 'Class role was successfully deleted.'
        }
      end
    else
      respond_to do |format|
        format.js {
          flash.now[:alert] = 'You should not delete this class role.'
        }
      end
    end
    @class_roles = ClassRole.all
    render 'shared/link.js.erb'     
  end

  private
    def set_class_role
      @class_role = ClassRole.find(params[:id])
    end

    def class_role_params
      params.require(:class_role).permit(:name, :description)
    end
end