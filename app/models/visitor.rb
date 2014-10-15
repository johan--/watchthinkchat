class Visitor < ActiveRecord::Base
  has_many :interactions, dependent: :destroy
  has_many :invited_visitors,
           class_name: 'Visitor',
           dependent: :nullify,
           foreign_key: :invited_id
  has_one :inviter,
          class_name: 'Visitor',
          foreign_key: :id,
          primary_key: :invited_id
  before_validation :ensure_tokens
  devise :database_authenticatable

  def ensure_tokens
    self.invite_token = generate_token(invite_token) if invite_token.nil?
    self.share_token = generate_token(share_token) if share_token.nil?
    return unless authentication_token.nil?
    self.authentication_token = generate_token(authentication_token)
  end

  private

  def generate_token(field)
    loop do
      token = Devise.friendly_token
      break token unless Visitor.where('? = ?', field, token).first
    end
  end
end
