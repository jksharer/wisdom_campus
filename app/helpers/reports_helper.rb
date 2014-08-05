module ReportsHelper
	include SessionsHelper

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

	# 新建学期，或将某学期设为“当前学期”后，对该学期的报表进行初始化
	def initialize_reports(semester)
		grades = Grade.where(agency: Agency.find(1), graduated: false)
		classes = []
		grades.each do |grade|
			classes.concat(grade.iclasses)
		end
		puts "#{semester.id}"
		classes.each do |iclass|
			report = ClassReport.find_by(iclass: iclass, semester: semester)
			if report
				puts "update class report: #{iclass.name}"
				report.update_attributes(grade_id: iclass.grade.id, 
																 students: Student.where(iclass: iclass, graduated: false).size, 
																behaviors: behaviors_of_class(iclass, semester))
			else
				puts "create class report: #{iclass.name}"
				ClassReport.create(grade_id: iclass.grade.id, 
													iclass_id: iclass.id, 
												semester_id: semester.id, 
													 students: Student.where(iclass: iclass, graduated: false).size, 
													behaviors: behaviors_of_class(iclass, semester))
			end
		end
	end

	# 更新class_report报表中班级的学生数量和行为数量, 参数scope指定更新的属性
	# 在下列事件发生后调用该方法: 
	# 增加、删除学生、学生调换班级
	# 增加、删除行为
	def update_report(iclass, semester, scope)
		report = ClassReport.find_by(iclass: iclass, semester: semester)
		if report
			puts "update class report: #{iclass.name}"
			case scope
			when "students"
				report.update_attribute(:students, Student.where(iclass: iclass, graduated: false).size)
			when "behaviors"
				report.update_attribute(:behaviors, behaviors_of_class(iclass, semester))			
			when "grade"
				report.update_attribute(:grade_id, iclass.grade.id)
			when "all"
				report.update_attributes(grade_id: iclass.grade.id, 
																 students: Student.where(iclass: iclass, graduated: false).size, 
					                      behaviors: behaviors_of_class(iclass, semester))
			end
		else
			puts "create class report: #{iclass.name}"
			report = ClassReport.create(grade_id: iclass.grade.id, 
																 iclass_id: iclass.id, 
														   semester_id: semester.id, 
																	students: Student.where(iclass: iclass, graduated: false).size, 
																 behaviors: behaviors_of_class(iclass, semester))
		end
	end

	def update_all_report
		grades = Grade.where(agency: Agency.find(1), graduated: false)
		classes = []
		grades.each do |grade|
			classes.concat(grade.iclasses)
		end
		semester = Semester.find_by(current: true)
		puts "#{semester.id}"
		classes.each do |iclass|
			report = ClassReport.find_by(iclass: iclass, semester: semester)
			if report
				puts "update class report: #{iclass.name}"
				report.update_attributes(grade_id: iclass.grade.id, 
																 students: Student.where(iclass: iclass, graduated: false).size, 
																behaviors: behaviors_of_class(iclass, semester))
			else
				puts "create class report: #{iclass.name}"
				ClassReport.create(grade_id: iclass.grade.id, 
													iclass_id: iclass.id, 
												semester_id: semester.id, 
													 students: Student.where(iclass: iclass, graduated: false).size, 
													behaviors: behaviors_of_class(iclass, semester))
			end
		end
	end

	# 计算某个班级在某个学期的总违反行为数量
	def behaviors_of_class(iclass, semester)
		total = 0
		iclass.students.each do |student|
			# 注意：针对枚举类型的查询只能用index表示，而不能用字符串，如"confirmed"
			total += Behavior.where(student_id: student.id, confirm_state: 2,   
				created_at: semester.start_date..semester.end_date).size
		end
		puts "#{iclass.name}: #{total}"
		return total
	end

	def hinted_text_field_tag(name, value = nil, hint = "Click and enter text", options={})
  	value = value.nil? ? hint : value
  	text_field_tag name, value, {:onclick => "if($(this).value == '#{hint}'){$(this).value = ''}", :onblur => "if($(this).value == ''){$(this).value = '#{hint}'}" }.update(options.stringify_keys)
	end

end