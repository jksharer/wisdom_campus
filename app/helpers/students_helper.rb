module StudentsHelper

	# 在新建、修改、删除班级、学生信息后，重新查询、设置初始化数据
	def set_initial_data
		@iclasses = Iclass.where(agency: my_agency).order('grade_id asc')
    @grades = Grade.order('id asc')
	end

end
