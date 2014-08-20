class Question < ActiveRecord::Base
  belongs_to :survey
  acts_as_list scope: :survey
  validates_presence_of :survey
  has_many :options, dependent: :destroy
end
