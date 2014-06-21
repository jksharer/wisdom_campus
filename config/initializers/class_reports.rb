def behaviors_of_class(iclass, semester)
	total = 0
	iclass.students.each do |student|
		total += Behavior.where(student_id: student.id, 
			created_at: semester.start_date..semester.end_date).size
	end
	return total
end

grades = Grade.where(agency: Agency.find(1), graduated: false)
classes = []
grades.each do |grade|
	classes.concat(grade.iclasses)
end
semester = Semester.find_by(current: true)
classes.each do |iclass|
	report = ClassReport.find_by(iclass: iclass, semester: semester)
	if report
		puts "update class report: #{iclass.name}"
		report.update_attributes(grade_id: iclass.grade.id, students: iclass.students.size, 
			behaviors: behaviors_of_class(iclass, semester))
	else
		puts "create class report: #{iclass.name}"
		ClassReport.create(grade_id: iclass.grade.id, iclass_id: iclass.id, semester_id: semester.id, 
			students: iclass.students.size, behaviors: behaviors_of_class(iclass, semester))
	end
end