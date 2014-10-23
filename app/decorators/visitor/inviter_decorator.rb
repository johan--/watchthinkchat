class Visitor
  class InviterDecorator < Draper::Decorator
    delegate_all
  end
end
