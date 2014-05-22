class ProceduresController < ApplicationController
  before_action :authorize
  before_action :set_procedure, only: [:show, :edit, :update, :destroy]

  def index
    @procedures = Procedure.all
    respond_to do |format|
      format.js
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
      format.js
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
    respond_to do |format|
      if @procedure.save
        format.js { render 'show.js.erb' }
        format.html { redirect_to @procedure, 
          notice: 'Procedure was successfully created.' }
        format.json { render action: 'show', status: :created, location: @procedure }
      else
        format.html { render action: 'new' }
        format.json { render json: @procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @procedure.update(procedure_params)
        format.html { redirect_to @procedure, notice: 'Procedure was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @procedure.destroy
    respond_to do |format|
      format.html { redirect_to procedures_url }
      format.json { head :no_content }
    end
  end

  private
    def set_procedure
      @procedure = Procedure.find(params[:id])
    end

    def procedure_params
      params.require(:procedure).permit(:name)
    end
end