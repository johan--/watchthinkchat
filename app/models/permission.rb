class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, polymorphic: true
  belongs_to :locale

  enum state:
  [
    :nobody,
    :viewer,
    :editor,
    :owner,
    :translator
  ]

  validates :user, presence: true
  validates :resource, presence: true
  validates :state, presence: true
  validates :locale, presence: true, if: -> { self.translator? }
end
