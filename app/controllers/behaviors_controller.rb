class BehaviorsController < ApplicationController
  include ApplicationHelper

  before_action :set_behavior, only: [:show, :edit, :print, :confirm, :update, :destroy]

  def index
    @behaviors = Behavior.order('created_at desc')
    respond_to do |format|
      format.js 
      format.html { 
        redirect_to '/behaviors.xls'
      }
      format.csv { send_data @behaviors.to_csv }
      format.xls  
    end
  end

  def show
  end

  def new
    @behavior = Behavior.new
    @current_time = Time.now
  end

  def edit
    respond_to do |format|    
      format.js { render 'new.js.erb' }
      format.html
    end
  end

  def print
    render layout: 'empty' 
  end

  def create
    @result_student = Student.find_by(sid: params[:behavior][:student_id])
    if params[:query]  # 点击查找按钮         
      respond_to do |format|    
        format.js { render 'query.js.erb' }
      end
    else  # 点击保存按钮
      if @result_student.nil?   # 未找到学生
        respond_to do |format|    
          format.js { render 'query.js.erb' }
        end    
      else                      # 成功找到学生
        @behavior = Behavior.new(behavior_params)
        @behavior.student_id = @result_student.id
        @behavior.serial_number = generate_serial_number
        @behavior.recorder = current_user
        @behavior.agency = my_agency 
        @behavior.score = BehaviorType.find(behavior_params[:behavior_type_id]).score if behavior_params[:behavior_type_id]
        respond_to do |format|
          if @behavior.save
            format.js {
              flash.now[:notice] = "成功添加一条行为记录."
              render 'show.js.erb'
            }
            format.html { redirect_to @behavior, notice: 'Behavior was successfully created.' }
          else
            format.js {
              render 'new.js.erb'
            }
            format.html { render action: 'new' }
          end
        end    
      end
    end
  end

  def update
    @result_student = Student.find_by(sid: params[:behavior][:student_id])
    if params[:query]  # 点击查找按钮         
      respond_to do |format|    
        format.js { render 'query.js.erb' }
      end
    else  # 点击保存按钮
      if @result_student.nil?   # 未找到学生
        respond_to do |format|    
          format.js { render 'query.js.erb' }
        end    
      else                      # 成功找到学生
        @behavior.student_id = @result_student.id
        @behavior.behavior_type_id = behavior_params[:behavior_type_id]
        @behavior.time = behavior_params[:time]
        @behavior.address = behavior_params[:address]
        @behavior.description = behavior_params[:description]
        @behavior.recorder = current_user
        @behavior.score = BehaviorType.find(behavior_params[:behavior_type_id]).score if behavior_params[:behavior_type_id]
        respond_to do |format|
          if @behavior.save
            format.js {
              flash.now[:notice] = "成功更新记录."
              render 'show.js.erb'
            }
            format.html { redirect_to @behavior, notice: 'Behavior was successfully updated.' }
          else
            format.js {
              render 'new.js.erb'
            }
            format.html { render action: 'new' }
          end
        end
      end
    end
  end

  # 设为已确认状态
  def confirm
    @behavior.update_attribute(:confirm_state, "confirmed")
    response = send_message(@behavior)    # 给家长发送短信
    puts response
    respond_to do |format|
      format.js {
        @behaviors = Behavior.order('created_at desc')
        render 'show.js.erb'  
      }
      format.html { redirect_to behaviors_url }
    end  
  end

  # 设为无效
  def destroy
    # @behavior.confirm_state = "canceled"
    @behavior.update_attribute(:confirm_state, "canceled")
    respond_to do |format|
      format.js {
        @behaviors = Behavior.order('created_at desc')
        render 'index.js.erb'  
      }
      format.html { redirect_to behaviors_url }
    end
  end

  private
    def set_behavior
      @behavior = Behavior.find(params[:id])
    end

    def behavior_params
      params.require(:behavior).permit(:student_id, :behavior_type_id, :time, :address, :description)
    end
end