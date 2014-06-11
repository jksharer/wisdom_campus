class GradesController < ApplicationController
  before_action :set_grade, only: [:show, :edit, :update, :destroy]

  def index
    @grades = Grade.where(agency: my_agency)
    render 'shared/link.js.erb'
  end

  def show
  end

  def new
    @grade = Grade.new
    render 'shared/new.js.erb'
  end

  def edit
    render 'shared/new.js.erb'
  end

  def create
    @grade = Grade.new(grade_params)
    @grade.agency = my_agency
    respond_to do |format|
      if @grade.save
        format.js {
          @grades = Grade.where(agency: my_agency)
          flash.now[:notice] = 'Grade was successfully created.'
          render 'shared/link.js.erb'     
        }
      else
        format.js { render 'shared/new.js.erb' }  
      end
    end
  end

  def update
    respond_to do |format|
      if @grade.update(grade_params)
        format.js {
          @grades = Grade.where(agency: my_agency)
          flash.now[:notice] = 'Grade was successfully updated.'
          render 'shared/link.js.erb'     
        }  
      else
        format.js { render 'shared/new.js.erb' }  
      end
    end
  end

  def destroy
    if @grade.iclasses.size > 0
      respond_to do |format|
        format.js {
          flash.now[:alert] = "There are classes related to the grade, you should not delete it."
          @grades = Grade.where(agency: my_agency)
          render 'shared/link.js.erb'
        }
      end      
    else
      @grade.destroy
      respond_to do |format|
        format.js {
          flash.now[:alert] = "The grade was deleted successfully."
          @grades = Grade.where(agency: my_agency) 
          render 'shared/link.js.erb'
        }
      end  
    end
  end

  private
    def set_grade
      @grade = Grade.find(params[:id])
    end

    def grade_params
      params.require(:grade).permit(:name, :description)
    end
end