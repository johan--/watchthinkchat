class Visitor
  class Inviter < ActiveType::Record[Visitor]
    has_many :invitations
    has_many :invitees, through: :invitations
  end
end
