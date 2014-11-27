class Visitor
  class Invitee
    class Email < ActiveType::Object
      attribute :subject, :string
      attribute :message, :string
      attribute :invitation_id, :integer

      belongs_to :invitation

      validates :subject, presence: true
      validates :message, presence: true
      validates :invitation, presence: true

      validate :invitee_email_and_first_name
      validate :inviter_email_and_first_name

      after_save :send_email

      delegate :inviter, to: :invitation, allow_nil: true
      delegate :invitee, to: :invitation, allow_nil: true
      delegate :campaign, to: :invitation, allow_nil: true

      private

      def invitee_email_and_first_name
        return if invitee.try(:email) && invitee.try(:first_name)
        errors.add(:invitation, 'invitee email and first name must be present')
      end

      def inviter_email_and_first_name
        return if inviter.try(:email) && inviter.try(:first_name)
        errors.add(:invitation, 'inviter email and first name must be present')
      end

      def send_email
        Api::V1::Invitees::Mailer.send_invitation(decorate).deliver
      end
    end
  end
end
