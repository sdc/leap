Rails.application.assets.register_engine '.haml', Tilt::HamlTemplate
Rails.application.config.assets.precompile += %w( vendor/modernizr.js )
