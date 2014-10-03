class User
  class Visitor < ActiveType::Record[User]
    has_many :interactions, dependent: :destroy
    before_save :ensure_authentication_token

    def ensure_authentication_token
      return unless authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end

    private

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
  end
end
