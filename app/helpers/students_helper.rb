module StudentsHelper

	# 在新建、修改、删除班级、学生信息后，重新查询、设置初始化数据
	def set_initial_data
		@iclasses = Iclass.where(agency: my_agency).order('grade_id asc').paginate(page: params[:page], per_page: 10)
    @grades = Grade.where(agency: my_agency, graduated: false).order('id asc')
	end

end