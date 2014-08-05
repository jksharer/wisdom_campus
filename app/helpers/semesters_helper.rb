module SemestersHelper
	def check_only_one_current(current_semester)
		Semester.all.all.each do |semester|
			if semester != current_semester && current_semester.current?
				semester.update_attribute(:current, false)
			end
		end
	end
end