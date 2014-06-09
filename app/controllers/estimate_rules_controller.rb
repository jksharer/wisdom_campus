class EstimateRulesController < ApplicationController
  before_action :set_estimate_rule, only: [:show, :edit, :update, :destroy]

  def index
    @estimate_rules = EstimateRule.where(agency: my_agency).order('updated_at desc')
    render 'shared/index.js.erb' 
  end

  def show
  end

  def new
    @estimate_rule = EstimateRule.new
    
  end

  def edit
    render 'shared/new.js.erb' 
  end

  def create
    @estimate_rule = EstimateRule.new(estimate_rule_params)
    @estimate_rule.agency = my_agency
    respond_to do |format|
      if @estimate_rule.save
        format.js { 
          flash.now[:notice] = 'Estimate rule was successfully created.'
          @estimate_rules = EstimateRule.order('updated_at desc')
          render 'shared/index.js.erb' 
        }
        format.html { redirect_to @estimate_rule, notice: 'Estimate rule was successfully created.' }
      else
        format.js { render 'shared/new.js.erb' }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @estimate_rule.update(estimate_rule_params)
        format.js { 
          flash.now[:notice] = 'Estimate rule was successfully updated.'
          @estimate_rules = EstimateRule.order('updated_at desc')
          render 'shared/index.js.erb' 
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def destroy
    @estimate_rule.destroy
    respond_to do |format|
      format.js { 
        flash.now[:notice] = 'Estimate rule was successfully deleted.'
        @estimate_rules = EstimateRule.order('updated_at desc')
        render 'shared/index.js.erb' 
      }
    end
  end

  private
    def set_estimate_rule
      @estimate_rule = EstimateRule.find(params[:id])
    end

    def estimate_rule_params
      params.require(:estimate_rule).permit(:lower, :higher, :description)
    end
end