class QueryController < ApplicationController
	include ApplicationHelper
	require 'date'  
  def index
  	render 'shared/index.js.erb'
  end

  def switch
  	@switch = params[:switch]
  end

  def query_via_class
  	start_date = params[:start_date]
  	end_date = Date.parse(params[:end_date]) + 1
		case params[:iclass]
		when "all_classes"
			case params[:behavior_type]
			when "all_types"
				case params[:address]
				when "所有地点"
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						order('student_id asc')
					# @behaviors = Behavior.where(time: start_date..end_date).where(confirm_state: params[:confirm_state])					
				else
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(address: params[:address]).order('student_id asc')
				end
			else
				case params[:address]
				when "所有地点"
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(behavior_type_id: params[:behavior_type]).order('student_id asc')
				else
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(behavior_type_id: params[:behavior_type]).where(address: params[:address]).order('student_id asc')
				end
			end
		else
			student_ids = Student.where(iclass_id: params[:iclass]).pluck(:id)
			puts params[:iclass]
			puts student_ids.size
			case params[:behavior_type]
			when "all_types"
				case params[:address]
				when "所有地点"
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(student_id: student_ids).order('student_id asc')	
				else
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(student_id: student_ids).where(address: params[:address]).order('student_id asc')
				end
			else
				case params[:address]
				when "所有地点"
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(student_id: student_ids).where(behavior_type_id: params[:behavior_type]).order('student_id asc')
				else
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(student_id: student_ids).where(behavior_type_id: params[:behavior_type]).where(address: params[:address]).order('student_id asc')
				end
			end
		end
		respond_to do |format|
      format.html {
  			redirect_to query_via_class_path(params.merge(:format => :xls))
  		}
      format.js { render 'query.js.erb' }
      format.csv { send_data @behaviors.to_csv }
      format.xls  
    end
  end

  def query_via_grade
  	start_date = params[:start_date]
  	end_date = Date.parse(params[:end_date]) + 1
		case params[:grade]
		when "all_grades"
			case params[:behavior_type]
			when "all_types"
				case params[:address]
				when "所有地点"
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state])
				else
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(address: params[:address])
				end
			else
				case params[:address]
				when "所有地点"
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(behavior_type_id: params[:behavior_type])
				else
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(behavior_type_id: params[:behavior_type]).where(address: params[:address])
				end
			end
		else
			student_ids = []
			Grade.find(params[:grade]).iclasses.each do |c|
				student_ids << Student.where(iclass_id: c.id).pluck(:id)	
			end
			case params[:behavior_type]
			when "all_types"
				case params[:address]
				when "所有地点"
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(student_id: student_ids)	
				else
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(student_id: student_ids).where(address: params[:address])
				end
			else
				case params[:address]
				when "所有地点"
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(student_id: student_ids).where(behavior_type_id: params[:behavior_type])
				else
					@behaviors = Behavior.where("time >= ?", start_date).where("time <= ?", end_date).where(confirm_state: params[:confirm_state]).
						where(student_id: student_ids).where(behavior_type_id: params[:behavior_type]).where(address: params[:address])
				end
			end
		end
		respond_to do |format|
      format.html {
  			redirect_to query_via_class_path(format: 'xls')
  		}
      format.js { render 'query.js.erb' }
      format.csv { send_data @behaviors.to_csv }
      format.xls  
    end
  end

end