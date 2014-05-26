class IclassesController < ApplicationController
  before_action :set_iclass, only: [:show, :edit, :update, :destroy]

  def index
    @iclasses = Iclass.where(agency: my_agency)
    @grades = Grade.all
  end

  def show
  end

  def new
    @iclass = Iclass.new
  end

  def edit
    respond_to do |format|
      format.js { render 'new.js.erb' }
      format.html
    end
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
        format.html { redirect_to @iclass, notice: 'Iclass was successfully created.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'new' }
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
        format.html { redirect_to @iclass, notice: 'Iclass was successfully updated.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    if @iclass.students.size > 0
      respond_to do |format|
        format.js {
          flash.now[:alert] = "There are students in this class, you should not delete it."
          set_initial_data
          render 'index.js.erb'
        }
        format.html { redirect_to iclasses_url }
      end  
    else
      @iclass.destroy
      respond_to do |format|
        format.js {
          flash.now[:notice] = "Class was successfully deleted."
          set_initial_data
          render 'index.js.erb'
        }
        format.html { redirect_to iclasses_url }
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