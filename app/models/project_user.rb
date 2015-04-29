class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  validates :project_id, presence: true
  validates :user_id, presence: true
  validates :role, presence: true
end
