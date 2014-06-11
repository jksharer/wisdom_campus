class MySchoolController < ApplicationController
	include ApplicationHelper
  def home
  	@school = my_agency
  	render 'shared/index.js.erb'
  end
end
