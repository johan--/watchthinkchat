class AvailableLocale < ActiveRecord::Base
  # associations
  belongs_to :campaign
  belongs_to :locale

  # validations
  validates :campaign, presence: true
  validates :locale, presence: true

  def permissions
    Permission.where(resource: campaign,
                     locale: locale,
                     state: Permission.states[:translator]).all
  end

  def completion
    ((Translation.where(campaign: campaign,
                      locale: locale)
    .count.to_d /
    Translation.where(campaign: campaign,
                      base: true).count.to_d) * 100).to_i
  end
end
