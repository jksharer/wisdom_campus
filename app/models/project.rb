class Project < ActiveRecord::Base
  # include Enumerize
  extend Enumerize

  belongs_to :user
  belongs_to :department

  enumerize :priority, in: [ :high, :medium, :low ], default: :high
  enumerize :status, in: [ :normal, :delay, :completed ], default: :normal

  validates :name, presence: true
  validates :user, presence: true
  validates :department, presence: true
  validates :priority, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :status, presence: true

end
