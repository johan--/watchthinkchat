class User
  class Visitor < ActiveType::Record[User]
    has_many :interactions, dependent: :destroy
  end
end
