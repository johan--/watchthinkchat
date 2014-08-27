class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, polymorphic: true

  enum state:
  [
    :nobody,
    :viewer,
    :editor,
    :owner
  ]

  validates :user, presence: true
  validates :resource, presence: true
  validates :state, presence: true
end
