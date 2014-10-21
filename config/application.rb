require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module WatchThinkChat
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.assets.initialize_on_precompile = false
    config.i18n.default_locale = :en
    config.i18n.load_path +=
      Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.active_record.observers = :campaign_observer
  end
end
