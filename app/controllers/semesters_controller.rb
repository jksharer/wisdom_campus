class SemestersController < ApplicationController
  before_action :set_semester, only: [:show, :edit, :update, :destroy]
  before_action :authorize
  
  def index
    @semesters = Semester.order('updated_at desc')
    render 'shared/link.js.erb'
  end

  def show
  end

  def new
    @semester = Semester.new
    render 'shared/new.js.erb'
  end

  def edit
    render 'shared/new.js.erb'
  end

  def create
    @semester = Semester.new(semester_params)
    respond_to do |format|
      if @semester.save
        format.js {
          @semesters = Semester.order('updated_at desc')
          render 'shared/link.js.erb'     
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def update
    respond_to do |format|
      if @semester.update(semester_params)
        format.js {
          @semesters = Semester.order('updated_at desc')
          render 'shared/link.js.erb'     
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def destroy
    # @semester.destroy
    respond_to do |format|
      format.js {
        flash.now[:alert] = '为了系统数据完整性, 学期数据不可删除, 如果确实需要请联系管理员从后台删除.'
        @semesters = Semester.order('updated_at desc')
        render 'shared/link.js.erb'     
      }
    end
  end

  private
    def set_semester
      @semester = Semester.find(params[:id])
    end

    def semester_params
      params.require(:semester).permit(:name, :school_year, :start_date, :end_date, :current)
    end
end