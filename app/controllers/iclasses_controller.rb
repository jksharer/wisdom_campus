class IclassesController < ApplicationController
  before_action :set_iclass, only: [:show, :edit, :update, :destroy]

  def index
    @iclasses = Iclass.where(agency: my_agency).order('grade_id asc')
    @grades = Grade.where(agency: my_agency).order('id asc')
  end

  def show
  end

  def new
    @iclass = Iclass.new
    @grades = Grade.where(agency: my_agency).order('id asc')
    render 'shared/new.js.erb'
  end

  def edit
    @grades = Grade.where(agency: my_agency).order('id asc')
    render 'shared/new.js.erb' 
  end

  def create
    @iclass = Iclass.new(iclass_params)
    @iclass.agency = current_user.agency
    respond_to do |format|
      if @iclass.save
        format.js {
          set_initial_data
          flash.now[:notice] = 'Class was successfully created.'
          render 'index.js.erb'     
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def update
    respond_to do |format|
      if @iclass.update(iclass_params)
        format.js {
          set_initial_data
          flash.now[:notice] = 'Class was successfully updated.'
          render 'index.js.erb'     
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def destroy
    if @iclass.students.size > 0
      respond_to do |format|
        format.js {
          flash.now[:alert] = "There are students in this class, you should not delete it."
          render 'shared/notice.js.erb'
        }
      end  
    else
      @iclass.destroy
      respond_to do |format|
        format.js {
          set_initial_data
          # @iclasses = Iclass.where(agency: my_agency).order('grade_id asc')
          flash.now[:notice] = "Class was successfully deleted."
          render 'index.js.erb'
        }
      end  
    end
  end

  private
    def set_iclass
      @iclass = Iclass.find_by(id: params[:id], agency: my_agency)
    end

    def iclass_params
      params.require(:iclass).permit(:name, :grade_id, :header)
    end
end