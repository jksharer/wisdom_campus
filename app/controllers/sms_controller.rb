class SmsController < ApplicationController
  include ApplicationHelper

  before_action :set_sm, only: [:show, :edit, :update, :destroy, :send_sm]
  before_action :authorize

  def index
    @sms = Sm.where(agency: my_agency).order('created_at desc').paginate(page: params[:page], per_page: 8)
    render 'shared/index.js.erb'
  end

  def show
  end

  def new
    @sm = Sm.new
    render 'shared/new.js.erb'
  end

  def edit
    render 'shared/new.js.erb'
  end

  # 发送短信
  def send_sm
    begin
    response = send_message(@sm)
    rescue Exception => e
      @sm.update_attribute(:status, "failue")
      flash.now[:alert] = "短信服务器没有响应，请检查网络及咨询短信服务供应商.详细信息: #{e.message}"
      if params[:from] == "behavior"  # 在行为记录时发起短信请求，渲染行为记录页面
        @behavior = @sm.behavior
        render 'behaviors/show.js.erb'
      else
        render 'shared/new.js.erb'
      end
    else
      puts response.code
      puts response.message
      @sms = Sm.where(agency: my_agency).order('created_at desc').paginate(page: params[:page], per_page: 8)
      case response
        when Net::HTTPSuccess, Net::HTTPRedirection
          @sm.update_attribute(:status, "success")         # 如果发送成功，则更新短信信息的状态为success
          flash.now[:notice] = "短信发送成功."
          if params[:from] == "behavior"
            @behavior = @sm.behavior
            render 'behaviors/show.js.erb'
          else
            render 'shared/index.js.erb'
          end
        else
          @sm.update_attribute(:status, "failue")
          flash.now[:alert] = "短信发送失败，请检查手机号码和网络是否正常."
          if params[:from] == "behavior"
            @behavior = @sm.behavior
            render 'behaviors/show.js.erb'
          else
            render 'shared/index.js.erb'
          end
        end
    end
  end

  def create
    @sm = Sm.new(sm_params)
    @sm.agency = my_agency
    @sm.status = "new"
    respond_to do |format|
      if @sm.save
        @sm.update_attribute(:mid, "#{my_agency.id}#{@sm.id}")
        format.js {
          flash.now[:notice] = "短信创建成功，准备发送."
          redirect_to send_message_path(id: @sm.id)
        }   
      else
        format.js { 
          flash.now[:alert] = "短信创建失败."
          render 'shared/new.js.erb' 
        }   
      end
    end
  end

  def update
    respond_to do |format|
      if @sm.update(sm_params)
        format.js { 
          flash.now[:notice] = "短信内容更新成功，准备发送."
          redirect_to send_message_path(id: @sm.id) 
        }
      else
        format.js { 
          flash.now[:alert] = "短信更新失败."
          render 'shared/new.js.erb' 
        }   
      end
    end
  end

  def destroy
    @sm.destroy
    @sms = Sm.where(agency: my_agency).order('created_at desc').paginate(page: params[:page], per_page: 8)
    respond_to do |format|
      format.js { render 'shared/index.js.erb' }
      format.html { redirect_to sms_url }
    end
  end

  private
    def set_sm
      @sm = Sm.find(params[:id])
    end

    def sm_params
      params.require(:sm).permit(:phone, :content)
    end
end