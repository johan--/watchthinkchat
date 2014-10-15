class VisitorDecorator < Draper::Decorator
  delegate_all

  def name
    "#{first_name} #{last_name}".strip
  end
end
