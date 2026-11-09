require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FirstStage
  class Application < Rails::Application
    config.action_controller.raise_on_missing_callback_actions = false if Rails.version >= "7.1.0"
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :test_unit, fixture: false
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    config.yjit = true

    # Dart Sass warns about features Dart Sass 3 will remove. Bootstrap 5 and
    # Font Awesome still use them (and Bootstrap 5 is built around @import), so
    # hide warnings from gems and about @import; warnings about our own Sass
    # still show. Revisit when moving to Bootstrap 6 / Sass modules (@use).
    config.sass.quiet_deps = true
    config.sass.silence_deprecations = ["import"]

    # Images are resized by Cloudinary (cl_image_tag), never by Active Storage
    # variants, so no image_processing gem is needed.
    config.active_storage.variant_processor = :disabled

    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
