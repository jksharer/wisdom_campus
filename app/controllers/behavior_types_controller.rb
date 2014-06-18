class BehaviorTypesController < ApplicationController
  before_action :set_behavior_type, only: [:show, :edit, :update, :destroy]
  before_action :authorize

  def index
    @behavior_types = BehaviorType.where(agency: my_agency).order('score asc')
    render 'shared/index.js.erb'
  end

  def show
  end

  def new
    @behavior_type = BehaviorType.new
    render 'shared/new.js.erb'
  end

  def edit
    render 'shared/new.js.erb'
  end

  def create
    @behavior_type = BehaviorType.new(behavior_type_params)
    @behavior_type.agency = my_agency
    respond_to do |format|
      if @behavior_type.save
        format.js {
          @behavior_types = BehaviorType.where(agency: my_agency).order('score asc')
          flash.now[:notice] = 'Behavior type was successfully created.'
          render 'shared/index.js.erb'      
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def update
    respond_to do |format|
      if @behavior_type.update(behavior_type_params)
        format.js {
          @behavior_types = BehaviorType.where(agency: my_agency).order('score asc')
          flash.now[:notice] = 'Behavior type was successfully updated.'
          render 'shared/index.js.erb'        
        }
      else
        format.js { render 'shared/new.js.erb' }
      end
    end
  end

  def destroy
    if @behavior_type.behaviors.empty?
      @behavior_type.destroy
      flash.now[:notice] = 'Behavior type was successfully deleted.'
    else    
      flash.now[:alert] = 'Some Behaviors related to this type, you should not delete it.'
    end
    @behavior_types = BehaviorType.where(agency: my_agency).order('score desc')
    respond_to do |format|
      format.js { render 'shared/index.js.erb' }
    end      
  end

  private
    def set_behavior_type
      @behavior_type = BehaviorType.find(params[:id])
    end

    def behavior_type_params
      params.require(:behavior_type).permit(:name, :description, :score)
    end
end