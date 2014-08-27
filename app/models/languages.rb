class Languages < ActiveRecord::Base
  # attr_accessible :locale, :name
  has_many :user_languages
  has_many :users, through: :user_languages
end
