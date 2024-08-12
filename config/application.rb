require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Erpweb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    # config.autoload_paths += %W[#{config.root}/app/models]

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    # config.autoload_lib(ignore: %w[assets tasks])

    # Ensure the asset pipeline is enabled
    # config.assets.enabled = true
    # # config.assets.paths << Rails.root.join('app', 'assets', 'images')
    # config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif]

    # config.middleware.delete Rack::Sendfile

    config.generators do |g|
      g.template_engine = :haml
      g.test_framework(:rspec, fixtures: false, view_specs: false, helper_specs: false, routing_specs: false)
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end