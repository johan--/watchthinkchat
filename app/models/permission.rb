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

  validates_presence_of :user, :resource, :state
end
