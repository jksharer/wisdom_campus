class BehaviorsController < ApplicationController
  include ApplicationHelper

  before_action :set_behavior, only: [:show, :edit, :print, :confirm, :update, :destroy]
  before_action :authorize
  after_action :update_behaviors_report, only: [:confirm, :destroy]

  # 更新相应班级的行为数量统计数据
  def update_behaviors_report
    update_report(@behavior.student.iclass, Semester.find_by(current: true), "behaviors")
  end

  def index
    if params[:time]
      @scope = params[:time]
      @behaviors = Behavior.where(agency: my_agency).where("created_at > ?", params[:time].to_i.days.ago).
        order('created_at desc')
    else
      @scope = 3
      @behaviors = Behavior.where(agency: my_agency).where("created_at > ?", 3.days.ago).
        order('created_at desc')
    end
    respond_to do |format|
      format.js { render 'shared/index.js.erb' }
      format.html { 
        redirect_to behaviors_path(format: 'xls', time: @scope)
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
    if params[:student_id]
      @behavior.student = Student.find(params[:student_id])

    else
      respond_to do |format|    
        format.js { render 'new.js.erb' }
        format.html
      end
    end
  end

  def edit
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
            flash.now[:notice] = "成功添加一条行为记录."  
            format.js {
              render 'show.js.erb'
            }
            format.html { redirect_to @behavior }
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
            flash.now[:notice] = "成功更新记录."
            format.js {
              render 'show.js.erb'
            }
            format.html { redirect_to @behavior }
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
    @message = generate_message(@behavior)
    respond_to do |format|
      if @message.save
        @message.update_attribute(:mid, "#{my_agency.id}#{@message.id}")
        format.js {
          flash.now[:notice] = "已确认，正在发送短信. \n手机号码：#{@message.phone}, 短信内容：#{@message.content}"
          @require_send = true
          render 'show.js.erb'
        }     
      else
        format.js {
          flash.now[:notice] = "该学生信息不全，无法发送短信，请查看手机号码是否正确."
          render 'show.js.erb' 
        }
      end
    end  
  end

  def send_behavior_message
    begin
    response = send_message(@message)
    rescue Exception => e
      @message.update_attribute(:status, "failue")
      flash.now[:alert] = "短信服务器没有响应，请检查网络及咨询短信服务供应商.详细信息: #{e.message}"
      render 'show.js.erb'
    else
      @sms = Sm.where(agency: my_agency).order('created_at desc').paginate(page: params[:page], per_page: 8)
        case response
          when Net::HTTPSuccess, Net::HTTPRedirection
            @message.update_attribute(:status, "success")         # 如果发送成功，则更新短信信息的状态为success
            flash[:notice] = "已确认并发送短信至家长手机, 手机号为:#{@behavior.student.phone}"
            render 'show.js.erb' 
          else
            @message.update_attribute(:status, "failue")
            flash.now[:alert] = "短信发送失败，请检查网络及短信服务是否运行正常."
            render 'show.js.erb' 
          end
      end
  end

  # 设为无效
  def destroy
    @behavior.update_attribute(:confirm_state, "canceled")
    respond_to do |format|
      format.js {
        flash.now[:notice] = '该行为记录已设为无效状态.'
        render 'show.js.erb'  
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