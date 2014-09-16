class User < ActiveRecord::Base
  include RoleModel

  devise :invitable, :registerable,
         :trackable,
         :database_authenticatable,
         :rememberable,
         :recoverable
  devise :omniauthable, omniauth_providers: [:facebook]

  validates :first_name, presence: true
  validates :email, uniqueness: true, email: true

  roles_attribute :roles_mask
  roles :nobody, :manager, :translator, :operator, :visitor

  has_many :permissions, dependent: :destroy

  def name
    "#{first_name} #{last_name}".strip
  end

  alias_method :fullname, :name

  def esc(s)
    ERB::Util.url_encode(s)
  end

  def as(role)
    return becomes "User::#{role.to_s.camelize}".constantize if self.is? role
    raise ActiveRecordError
  end
end
