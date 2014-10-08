# rubocop:disable Style/ClassAndModuleChildren
class Campaign::Survey::Question::OptionDecorator < Draper::Decorator
  decorates Campaign::Survey::Question::Option
  delegate_all

  def permalink
    "#{campaign.decorate.permalink}/#/o/#{code}"
  end
end
# rubocop:enable Style/ClassAndModuleChildren
