#encoding: utf-8
module ApplicationHelper
	include SessionsHelper
	include ProjectsHelper

	#初始化对象的审批流程
	#每个审批有三个状态：
	#"initial" = >初始化状态，不可审批，"current_review" => 当前审批，可操作, "accepted"/"rejected" => 单个审批结果
	def initialize_reviews(object)
		object.procedure.steps.each do |step|
			review = Review.new
			review.model_type = object.class.name
			review.object = object
			review.step = step
			review.state = "initial"
			review.save
		end

		#将对象的第一个审批步骤的状态设为当前审批
		reviews_of_object(object).first.update(state: "current_review")
	end

	#重置对象的审批流程，在一个流程被拒绝后重新发起审批时使用此方法
	def reset_states(object)
		Review.where(model_type: object.class.name, object: object).update_all(state: "initial")
		reviews_of_object(object).first.update(state: "current_review")
	end

	#当前审批人同意审批后，将下一个审批人的状态设为当前审批
	def set_next_review_to_current(object)
		reviews = reviews_of_object(object)
		puts reviews.size
		reviews.each_with_index do |review,index|
			puts review 
			puts index
			if review.state == "accepted" && (reviews[index+1].state == "initial")
				reviews[index+1].state = "current_review"
				reviews[index+1].save
			end
		end
	end

	#获取一个对象（比如通知公告）的所有审批流程，返回的数组按照审批顺序排序
	def reviews_of_object(object)
		Review.where(model_type: object.class.name, object: object).
      sort { |a, b| a.step.view_order <=> b.step.view_order }
	end

	# 获取当前需要我审批的对象，如通知公告
	def needed_my_review(model_type)
		os = []
		Review.where(state: "current_review", model_type: model_type).each do |review|
      if review.step.user == current_user
      	puts "--------------#{review.model_type}--#{review.object_id}"
        os << Kernel.const_get(model_type).find(review.object_id)
      end
    end
    return os
	end

	def steps_of_procedure(procedure)
		procedure.steps.map { |step| step.user.username }.join('->')
	end

	def time_format(time)
		"#{time.year}-#{time.month }-#{time.day} #{time.strftime("%A")}"
	end

	def time_format_min(time)
		time.strftime("%Y-%m-%d %H:%M")
	end

	#根据对象的工作流的状态，返回相应的中文状态名称
	def state_format(state)
		case state
			when "new"
				return "未提交审批"
			when "being_reviewed"
				return "审批中"
			when "accepted"
				return "审批通过"
			when "rejected"
				return "审批已驳回"
			when "initial"
				return "未审批"
			when "current_review"
				return "正在审批"	
			when "high"
				return "高"
			when "medium"
				return "中"
			when "low"
				return "低"										
			when "normal"
				return "正常"
			when "delay"
				return "延迟"
			when "completed"
				return "已完成"	
			else                   
				return "未知"	
		end
	end

end