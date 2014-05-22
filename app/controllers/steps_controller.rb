class StepsController < ApplicationController
  before_action :set_step, only: [ :show, :edit, :update, :destroy ]

  def index
    @steps = Step.all
  end

  def show
  end

  def new
    @step = Step.new
    if params[:procedure_id].nil?
      redirect_to procedures_url
      return
    end
    @procedure = Procedure.find(params[:procedure_id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @procedure = @step.procedure
    respond_to do |format|
      format.js { render 'new.js.erb' }
      format.html
    end
  end

  def create
    @step = Step.new(step_params)
    @procedure = Procedure.find(params[:procedure_id]) #在保存失败render 'new'时起作用，使其不出错
    @step.procedure = @procedure
    respond_to do |format|
      if @step.save
        format.js {
          flash.now[:notice] = "Already added a step."
          render 'index.js.erb'  
        }
        format.html { redirect_to @step.procedure, 
          notice: 'Step was successfully created.' }
      else
        format.js { render 'new.js.erb' }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @step.update(step_params)
        format.html { redirect_to @step.procedure, 
          notice: 'Step was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @step.destroy
    respond_to do |format|
      format.html { redirect_to @step.procedure,
        notice: 'Step was successfully deleted.' }
    end
  end

  private
    def set_step
      @step = Step.find(params[:id])
    end

    def step_params
      params.require(:step).permit(:view_order, :user_id, :procedure_id)
    end
end