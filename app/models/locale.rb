class Locale < ActiveRecord::Base
  # associations
  has_many :translations, dependent: :destroy
  has_many :available_locales, dependent: :destroy
  has_many :locales, through: :available_locales

  # validations
  validates :code, presence: true
  validates :name, presence: true
end
