class Project < ActiveRecord::Base

  # simpler version:
  has_many :project_users
  has_many :users, through: :project_users
  has_many :tasks

  accepts_nested_attributes_for :project_users


  # # complicated version: 

  ROLE = {
    viewer: 1,
    owner:  10
  }
  
  has_many :project_viewers, class_name: :ProjectUser, conditions: {role: ROLE[:viewer]}
  has_many :viewers, source: :user, through: :project_viewers

  has_many :project_owners, class_name: :ProjectUser, conditions: {role: ROLE[:owner]}
  has_many :owners, source: :user, through: :project_owners

  def self.role_ranking(role)
    ROLE[role.to_sym]
  end

  def self.return_role_options
    [
      ["owner", ROLE[:owner]],
      ["viewer", ROLE[:viewer]]
    ]
  end

end
