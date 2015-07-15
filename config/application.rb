require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module RafflrRedux
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.assets.precompile += %w(soundmanager2.swf soundmanager2_flash9.swf)
  end
end
