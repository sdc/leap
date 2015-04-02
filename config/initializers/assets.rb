Rails.application.config.assets.precompile += %w( vendor/modernizr.js )
Slim::Engine.set_options attr_list_delims: {'(' => ')', '[' => ']'}
