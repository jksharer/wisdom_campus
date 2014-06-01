class ReportsController < ApplicationController
  def home
  end

  def via_classes
  	@iclasses = Iclass.where(agency: my_agency).order('grade_id asc')
  	respond_to do |format|
  		format.js {
  			@view = 'via_classes'
  			render 'reports.js.erb'
  		}
  		format.html {
  			render layout: 'print'
  		}
  	end
  end

  def via_students
  end

  def query
  end
end