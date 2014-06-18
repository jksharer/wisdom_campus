class EstimateRulesController < ApplicationController
  before_action :set_estimate_rule, only: [:show, :edit, :update, :destroy]
  before_action :authorize

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
        flash.now[:notice] = '成功添加评价规则.'
        format.js { 
          @estimate_rules = EstimateRule.order('updated_at desc')
          render 'shared/index.js.erb' 
        }
        format.html { redirect_to @estimate_rule }
      else
        format.js { render 'shared/new.js.erb' }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @estimate_rule.update(estimate_rule_params)
        flash.now[:notice] = '更新成功.'
        format.js { 
          @estimate_rules = EstimateRule.order('updated_at desc')
          render 'shared/index.js.erb' 
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def destroy
    flash.now[:alert] = '评价规则不可删除, 如果需要的话您可以修改.'
    @estimate_rules = EstimateRule.order('updated_at desc')
    render 'shared/index.js.erb' 
  end

  private
    def set_estimate_rule
      @estimate_rule = EstimateRule.find(params[:id])
    end

    def estimate_rule_params
      params.require(:estimate_rule).permit(:lower, :higher, :description)
    end
end