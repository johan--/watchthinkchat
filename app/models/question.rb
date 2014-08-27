class Question < ActiveRecord::Base
  belongs_to :survey
  acts_as_list scope: :survey
  validates_presence_of :survey, :title
  has_many :options, dependent: :destroy
  default_scope { order('position ASC') }
  after_save :generate_code, on: :create
  validates_presence_of :code, on: :update
  accepts_nested_attributes_for :options, allow_destroy: true

  def options_attributes
    options
  end

  protected

  def generate_code
    update_column(:code, Base62.encode(id))
  end
end
