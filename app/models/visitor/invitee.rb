class Visitor
  class Invitee < ActiveType::Record[Visitor]
    has_many :invitations
    has_many :inviters, through: :invitations
  end
end
