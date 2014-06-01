module BehaviorsHelper

	def generate_serial_number
		last_behavior = Behavior.where('created_at > ?', Time.now.midnight).order('created_at asc').last
		if last_behavior.nil? 
			return "#{Time.now.strftime('%Y%m%d')}001".to_i
		else
			return last_behavior.serial_number + 1
		end
	end

	# 根据行为记录单的英文确认状态，转化为中文状态名称
	def transfer_confirm_state(confirm_state)
		state = case confirm_state
							when "initial"    
								"未确认"
							when "confirming"
								"确认中"
							when "confirmed"
							  "已确认"
							when "canceled"
							   "已取消"
							else
							   "未知"
							end
		return state
	end
end
