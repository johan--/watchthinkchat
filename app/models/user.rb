class User < ActiveRecord::Base
  include RoleModel

  # associations
  has_many :permissions, dependent: :destroy

  # validations
  validates :first_name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: true
  validates :password, confirmation: true, on: :create

  # definintions
  devise :invitable, :registerable,
         :trackable,
         :database_authenticatable,
         :rememberable,
         :recoverable

  devise :omniauthable, omniauth_providers: [:facebook]

  roles_attribute :roles_mask
  roles :nobody, :manager, :translator, :visitor

  def as(role)
    return becomes "User::#{role.to_s.camelize}".constantize if self.is? role
    fail ActiveRecord::ActiveRecordError
  end
end
