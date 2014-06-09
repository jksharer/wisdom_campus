module ReportsHelper

	def generate_behavior_content(behavior)
		"于#{time_format_min(behavior.time)}, 在#{behavior.address}发生#{behavior.behavior_type.name}行为.
			被扣#{behavior.score}分.  详细:#{behavior.description}"
	end
end
