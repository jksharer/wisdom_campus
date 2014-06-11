class SmsController < ApplicationController
  before_action :set_sm, only: [:show, :edit, :update, :destroy]

  def index
    @sms = Sm.order('created_at desc')
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

  def create
    @sm = Sm.new(sm_params)

    respond_to do |format|
      if @sm.save
        format.js { render 'shared/index.js.erb' }   
        format.html { redirect_to @sm, notice: 'Sm was successfully created.' }
      else
        format.js { render 'shared/new.js.erb' }   
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @sm.update(sm_params)
        format.js { render 'shared/index.js.erb' }
        format.html { redirect_to @sm, notice: 'Sm was successfully updated.' }
      else
        format.js { render 'shared/new.js.erb' }   
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @sm.destroy
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
      params.require(:sm).permit(:mid, :phone, :content, :send_time, :status)
    end
end