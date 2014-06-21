module ReportsHelper

	def generate_behavior_content(behavior)
		"于#{time_format_min(behavior.time)}, 在#{behavior.address}发生#{behavior.behavior_type.name}行为.
			被扣#{behavior.score}分.  详细:#{behavior.description}"
	end

	# 计算某个年级在某个学期的学生总数量
	def total_students_of_grade(grade, semester)
		ClassReport.where(grade: grade, semester: semester).pluck(:students).inject(:+)
	end

	# 计算某个年级在某个学期的违反秩序行为总数量
	def total_behaviors_of_grade(grade, semester)
		ClassReport.where(grade: grade, semester: semester).pluck(:behaviors).inject(:+)
	end	

	# 更新class_report报表中班级的学生数量和行为数量, 参数scope指定更新的属性
	def update_report(iclass, semester, scope)
		report = ClassReport.find_by(iclass: iclass, semester: semester)
		if report
			puts "update class report: #{iclass.name}"
			case scope
			when "students"
				report.update_attribute(:students, iclass.students.size)
			when "behaviors"
				report.update_attribute(:behaviors, behaviors_of_class(iclass, semester))
			when "grade"
				report.update_attribute(:grade_id, iclass.grade.id)
			when "all"
				report.update_attributes(grade_id: iclass.grade.id, students: iclass.students.size, 
					behaviors: behaviors_of_class(iclass, semester))
			end
		else
			puts "create class report: #{iclass.name}"
			report = ClassReport.create(grade_id: iclass.grade.id, iclass_id: iclass.id, semester_id: semester.id, 
				students: iclass.students.size, behaviors: behaviors_of_class(iclass, semester))
		end
	end

	# 计算某个班级在某个学期的总违反行为数量
	def behaviors_of_class(iclass, semester)
		total = 0
		iclass.students.each do |student|
			total += Behavior.where(student_id: student.id, 
				created_at: semester.start_date..semester.end_date).size
		end
		return total
	end

end