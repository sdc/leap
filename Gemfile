source 'http://rubygems.org'
#gem 'rails', "~> 4.2.0"
gem 'rails', git: 'https://github.com/rails/rails.git', branch: '4-2-stable'
gem 'coffee-rails', "~> 4.1.0"
gem 'haml', "~> 4.0.6"
gem "less-rails", "~> 2.6.0"
gem 'twitter-bootstrap-rails', "~> 3.2.0"
gem 'jquery-rails', '~> 4.0.3'
gem 'jquery-ui-rails', '~> 5.0.0'
gem 'symbolize'
gem 'scoped_search'
gem 'rails-settings-cached', "~> 0.4.1"
gem 'rails-latex'
gem 'nokogiri', "~> 1.6.0"
gem 'uglifier', "~> 2.7.0"
gem 'yui-compressor'
gem 'icalendar'
gem 'protected_attributes'
gem 'activerecord-deprecated_finders', require: 'active_record/deprecated_finders'
gem 'bootstrap-datepicker-rails'
gem 'angularjs-rails', '~> 1.3.10'
gem 'activeresource', require: 'active_resource'
gem 'whenever', :require => false
gem 'memcache-client'
gem 'debugger'

platforms :ruby do
  gem 'mysql2'
  gem 'therubyracer'
  gem 'activerecord-sqlserver-adapter', '~> 4.2'
  gem 'activerecord-oracle_enhanced-adapter', github: 'rsim/oracle-enhanced', branch: 'rails42'
  gem 'activerecord-mysql-adapter'
  gem 'ruby-oci8', '~> 2.1.0'
  gem 'tiny_tds', "~> 0.6.2"
  gem 'sqlite3'
end
  

platforms :jruby do
  gem 'activerecord-jdbcmysql-adapter'
  #gem 'activerecord-jdbcmssql-adapter', :git => "https://github.com/kevtufc/activerecord-jdbc-adapter.git"
  gem 'therubyrhino'
  gem 'trinidad'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
end
