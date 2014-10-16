class Visitor
  class Invitation < ActiveRecord::Base
    belongs_to :campaign
    belongs_to :invitee
    belongs_to :inviter
    before_validation :generate_token, on: :create
    validates :invitee, presence: true
    validates :inviter, presence: true
    validates :campaign, presence: true

    private

    def generate_token
      loop do
        self.token = Devise.friendly_token
        break unless Visitor::Invitation.where(token: token).first
      end
    end
  end
end
