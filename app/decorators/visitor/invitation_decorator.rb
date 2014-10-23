class Visitor
  class InvitationDecorator < Draper::Decorator
    delegate_all
    decorates_association :invitee
    decorates_association :inviter
    decorates_association :campaign
  end
end
