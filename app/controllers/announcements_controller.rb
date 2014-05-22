class AnnouncementsController < ApplicationController
  include ApplicationHelper
  require 'will_paginate/array'

  before_action :authorize
  before_action :set_announcement, only: [ :show, :edit, :update, :destroy, 
    :handle_workflow, :handle_review ]

  def index
    # 如果没有查询条件和参数，则返回所有已审批发布公告
    if params[:conditions].nil?
      @announcements = Announcement.where(workflow_state: "accepted").order('created_at DESC').
        page(params[:page]).per_page(10)
      @scope = "all"
    else
      conditions = ""
      params[:conditions].each { |key, value| conditions << "#{key} = #{value}" }
      @announcements = Announcement.where(conditions).order('created_at DESC').
        page(params[:page]).per_page(10)
      @scope = "mine"
    end
    respond_to do |format|
      format.js 
      format.html          
      format.html.phone    
      format.html.tablet   
    end  
  end

  #待审批通知公告
  def being_reviewed
    @announcements = needed_my_review("Announcement").paginate(page: params[:page], per_page: 10)
    # @announcements = WillPaginate::Collection.create(params[:page], 10, @announcements.length) do |pager|
    #   pager.replace @announcements
    # end
    @scope = "being_reviewed"
    render 'index'
  end

  def show
    @reviews = Review.where(model_type: "Announcement", object: @announcement).
      sort { |a, b| a.step.view_order <=> b.step.view_order }
    if params[:from] == "home"
      @announcements = needed_my_review("Announcement").paginate(page: params[:page], per_page: 10)
    end
    respond_to do |format|
      puts "#{params[:from]}"
      format.js
      format.html
    end
  end

  def new
    @announcement = Announcement.new
    respond_to do |format|
      format.js 
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.js { render 'new.js.erb' }
      format.html
    end
  end

  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.user = current_user
    puts params[:commit]
    respond_to do |format|
      if @announcement.save
        format.js {
          @reviews = Review.where(model_type: "Announcement", object: @announcement).
            sort { |a, b| a.step.view_order <=> b.step.view_order }
        }
        format.html {
          # 点击"保存和提交
          # if params[:save_and_submit]
          #   redirect_to handle_workflow_path(id: @announcement.id, event: "submit!")
          #   return
          # end
          redirect_to @announcement, 
          notice: 'Announcement was successfully created.'  
        }
      else
        format.js
        format.html { render action: 'new' }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.js { 
          flash.now[:notice] = "It's been updated."
          render 'create.js.erb' 
        }
        format.html { redirect_to @announcement, notice: 'Announcement was successfully updated.' }
      else
        format.js { render 'create.js.erb' }  
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @announcement.destroy
    respond_to do |format|
      format.js {
        flash.now[:notice] = "It's been deleted."
        @announcements = Announcement.where(user_id: current_user).order('created_at DESC').
          page(params[:page]).per_page(10)
        @scope = "mine"
        render 'index.js.erb'
      }
      format.html { redirect_to announcements_url }
    end
  end

  def handle_workflow
    method = @announcement.method(params[:event].to_sym)
    method.call
    respond_to do |format|
      format.js {
        @reviews = Review.where(model_type: "Announcement", object: @announcement).
          sort { |a, b| a.step.view_order <=> b.step.view_order }
        render 'show.js.erb'
      }
      format.html { redirect_to @announcement, 
        notice: "#{method.name}  has called." }
      format.json { head :no_content }
    end
  end

  def handle_review
    review = Review.find(params[:review])
    review.state = params[:judge]
    review.save
    @reviews = Review.where(model_type: "Announcement", object: @announcement).
          sort { |a, b| a.step.view_order <=> b.step.view_order }
    if review.state == "rejected"
      @announcement.method(:reject!).call
    else 
      # 获取该通知公告的所有审批状态，如果全部都通过则设置通知公告为审批通过
      states = Review.where(model_type: "Announcement", object: @announcement).pluck(:state)
      if states.count("accepted") == states.size  
        @announcement.method(:accept!).call
      else 
        #如果没有拒绝，而且审批没有结束，则设置下一个审批状态为当前审批
        set_next_review_to_current(@announcement)
      end
    end
    respond_to do |format|
      format.js { render 'show.js.erb' }
      format.html { redirect_to @announcement }  
    end
  end

  private
    def set_announcement
      @announcement = Announcement.find(params[:id])
    end

    def announcement_params
      params.require(:announcement).permit(:name, :announcement_type, :content, :procedure_id)
    end
end