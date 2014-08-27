class GodChat < ActiveRecord::Base
  belongs_to :campaign

  has_many :user_operators
  has_many :operators, through: :user_operators, source: :user
  belongs_to :admin1, class_name: 'User'
  belongs_to :admin2, class_name: 'User'
  belongs_to :admin3, class_name: 'User'

  def available_operator
    if max_chats
      operators = operators.online.select do |o|
        o.count_operator_open_chats_for(self) < max_chats
      end
    else
      operators = self.operators.online
    end
    operators.sort do |o1, o2|
      open1 = o1.count_operator_open_chats_for(self)
      open2 = o2.count_operator_open_chats_for(self)
      if open1 == open2
        o1.count_operator_chats_for(self) <=> o2.count_operator_chats_for(self)
      else
        open1 <=> open2
      end
    end
    operators.first
  end

  def password
    return nil unless password_hash
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    return unless new_password.present?
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
