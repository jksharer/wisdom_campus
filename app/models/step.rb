class Step < ActiveRecord::Base
  belongs_to :user
  belongs_to :procedure

  validates :view_order, presence: true
  validates :user, presence: true
  validates :procedure, presence: true
end