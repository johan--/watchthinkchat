class Option < ActiveRecord::Base
  enum conditional: [:next, :skip, :finish]
  belongs_to :question
  has_one :conditional_question, class: 'Question'
  validates_presence_of :title, :conditional
  validates_presence_of :question, on: :update
  validates_presence_of :conditional_question_id,
                        if: proc { self.skip? }
  after_save :generate_code, on: :create
  default_scope { order('created_at ASC') }

  protected

  def generate_code
    update_column(:code, Base62.encode(id))
  end
end
