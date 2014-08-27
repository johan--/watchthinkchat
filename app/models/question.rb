class Question < ActiveRecord::Base
  belongs_to :survey
  acts_as_list scope: :survey
  validates_presence_of :survey, :title
  has_many :options, dependent: :destroy
  default_scope { order('position ASC') }
  after_save :generate_code, on: :create
  validates_presence_of :code, on: :update

  protected

  def generate_code
    update_column(:code, Base62.encode(id))
  end
end
