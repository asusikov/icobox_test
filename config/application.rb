require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require './lib/hitbtc_importer'
require './lib/last_ticker_notificator'

module App
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :delayed_job
    config.after_initialize do
      if ActiveRecord::Base.connection.tables.include?('delayed_jobs') && Delayed::Job.all.count == 0
        ImportTickersJob.perform_later
      end
    end
  end
end
