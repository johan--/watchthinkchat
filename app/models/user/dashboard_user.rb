class User
  class DashboardUser < ActiveType::Record[User]
    self.abstract_class = true

    # validations
    validates :first_name, presence: true
    validates :email, presence: true, uniqueness: true, email: true
    validates :password, presence: true
    validates :password, confirmation: true, on: :create
  end
end
