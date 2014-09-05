class User::Translator::Invite < ActiveType::Object
  attribute :campaign_id, :integer
  attribute :locale_id, :integer
  attribute :invited_user_id, :integer

  attribute :first_name
  attribute :last_name
  attribute :email

  belongs_to :campaign
  belongs_to :locale
  belongs_to :invited_user, class_name: 'User'

  validates :campaign, presence: true
  validates :locale, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, email: true

  after_save :find_or_create_invited_user
  after_save :add_translator_role_to_invited_user
  after_save :add_permission_to_invited_user
  after_save :save_invited_user

  private

  def find_or_create_invited_user
    self.invited_user = User.find_by(email: email)
    return if invited_user # send added to email
    self.invited_user = User.invite! email: email,
                                     first_name: first_name,
                                     last_name: last_name
  end

  def add_translator_role_to_invited_user
    invited_user.roles << :translator
  end

  def add_permission_to_invited_user
    Permission.where(user: invited_user,
                     resource: campaign,
                     state: Permission.states[:translator],
                     locale: locale).first_or_create
  end

  def save_invited_user
    invited_user.save
  end
end
