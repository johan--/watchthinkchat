class Option < ActiveRecord::Base
  enum conditional: [:next, :skip, :finish]
  belongs_to :question
  has_one :conditional_question, class: 'Question'
  validates_presence_of :title, :code, :question, :conditional
  validates_presence_of :conditional_question,
                        if: proc { self.skip? }
  before_validation :generate_code, on: :create

  protected

  def generate_code
    begin
      self.code = SecureRandom.hex(3)
    end while Option.exists?(code: code)
  end
end
