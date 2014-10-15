class Visitor < ActiveRecord::Base
  has_many :interactions, dependent: :destroy
  before_save :ensure_authentication_token
  devise :database_authenticatable

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
