class MySchoolController < ApplicationController
	include ApplicationHelper
	before_action :authorize
  def home
  	@school = my_agency
  	render 'shared/index.js.erb'
  end
end