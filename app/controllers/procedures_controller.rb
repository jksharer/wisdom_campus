class ProceduresController < ApplicationController
  before_action :authorize
  before_action :set_procedure, only: [:show, :edit, :update, :destroy]

  def index
    @procedures = Procedure.where(agency: my_agency)
    respond_to do |format|
      format.js { render 'shared/index' }
      format.html
    end    
  end

  def show
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @procedure = Procedure.new
    respond_to do |format|
      format.js { render 'shared/new' }
      format.html {
        render layout: 'empty'    
      }
    end
  end

  def edit
    respond_to do |format|
      format.js 
      format.html {
        render layout: 'empty'    
      }
    end
  end

  def create
    @procedure = Procedure.new(procedure_params)
    @procedure.agency = current_user.agency
    respond_to do |format|
      if @procedure.save
        flash.now[:notice] = '流程创建成功, 请为该流程设置流转顺序和审批人.'
        format.js { render 'show.js.erb' }
        format.html { redirect_to @procedure, 
          notice: 'Procedure was successfully created.' }
      else
        format.js { render 'shared/new' }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @procedure.update(procedure_params)
        format.js { render 'show.js.erb' }
        format.html { redirect_to @procedure, notice: 'Procedure was successfully updated.' }
      else
        format.js { render 'shared/new' }
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    respond_to do |format|
      format.js { 
        flash.now[:alert] = "不建议删除流程, 可能会导致以前的公文、公告无法打开."
        render 'shared/notice_heavy'
      }
      format.html { redirect_to procedures_url }
      format.json { head :no_content }
    end
  end

  private
    def set_procedure
      @procedure = Procedure.find_by(id: params[:id], agency: my_agency)
    end

    def procedure_params
      params.require(:procedure).permit(:name)
    end
end