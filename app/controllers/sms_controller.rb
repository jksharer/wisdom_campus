class SmsController < ApplicationController
  before_action :set_sm, only: [:show, :edit, :update, :destroy]

  def index
    @sms = Sm.order('created_at desc')
  end

  def show
  end

  def new
    @sm = Sm.new
  end

  def edit
  end

  def create
    @sm = Sm.new(sm_params)

    respond_to do |format|
      if @sm.save
        format.html { redirect_to @sm, notice: 'Sm was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sm }
      else
        format.html { render action: 'new' }
        format.json { render json: @sm.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sm.update(sm_params)
        format.html { redirect_to @sm, notice: 'Sm was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sm.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sm.destroy
    respond_to do |format|
      format.html { redirect_to sms_url }
      format.json { head :no_content }
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