class Permission < ActiveRecord::Base
  # associations
  belongs_to :user
  belongs_to :resource, polymorphic: true
  belongs_to :locale

  # validations
  validates :user, presence: true
  validates :resource, presence: true
  validates :state, presence: true
  validates :locale, presence: true, if: -> { self.translator? }

  # definitions
  enum state:
  [
    :nobody,
    :viewer,
    :editor,
    :owner,
    :translator,
    :visitor
  ]

  delegate :campaign, to: :resource
end
