class GradesController < ApplicationController
  before_action :set_grade, only: [:show, :edit, :update, :destroy]

  def index
    @grades = Grade.all
  end

  def show
  end

  def new
    @grade = Grade.new
  end

  def edit
    respond_to do |format|
      format.js { render 'new.js.erb' }
      format.html
    end    
  end

  def create
    @grade = Grade.new(grade_params)
    respond_to do |format|
      if @grade.save
        format.js {
          @grades = Grade.all
          flash.now[:notice] = 'Grade was successfully created.'
          render 'index.js.erb'     
        }
        format.html { redirect_to @grade, notice: 'Grade was successfully created.' }
      else
        format.js { render 'new.js.erb' }  
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @grade.update(grade_params)
        format.js {
          @grades = Grade.all
          flash.now[:notice] = 'Grade was successfully updated.'
          render 'index.js.erb'     
        }  
        format.html { redirect_to @grade, notice: 'Grade was successfully updated.' }
      else
        format.js { render 'new.js.erb' }  
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    if @grade.iclasses.size > 0
      respond_to do |format|
        format.js {
          flash.now[:alert] = "There are classes related to the grade, you should not delete it."
          render 'index.js.erb'
        }
      end      
    else
      @grade.destroy
      respond_to do |format|
        format.js {
          flash.now[:alert] = "The grade was deleted successfully."
          render 'index.js.erb'
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