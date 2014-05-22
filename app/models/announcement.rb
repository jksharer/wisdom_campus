class Announcement < ActiveRecord::Base
	include ApplicationHelper

	belongs_to :user
	belongs_to :procedure 	

	validates :name, presence: true
	validates :announcement_type, presence: true, length: { maximum: 30 }
	validates :content, presence: true, length: { minimum: 10, maximum: 100 }
	validates :user, presence: true
	validates :procedure, presence: true

	include Workflow
	workflow do
		state :new do
			event :submit, :transitions_to => :being_reviewed
		end

		state :being_reviewed do
			event :accept, :transitions_to => :accepted
			event :reject, :transitions_to => :rejected
		end
		
		state :accepted
		state :rejected do
			event :resubmit, :transitions_to => :being_reviewed
		end
	end

	def submit
		initialize_reviews(self)
	end

	def resubmit
		reset_states(self)
	end

  def accept
  end
  
  def reject
  end
end