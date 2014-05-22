class Review < ActiveRecord::Base
  belongs_to :object
  belongs_to :step


  def initial?
  	self.state == "initial"
  end

  def current_review?
  	self.state == "current_review"
  end

  def accepted?
  	self.state == "accepted"
  end

  def rejected?
  	self.state == "rejected"
  end
end
