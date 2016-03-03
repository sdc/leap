source 'http://rubygems.org'
gem 'rails', "~> 4.2.1"
gem 'coffee-rails', "~> 4.1.0"
gem 'slim-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'color'
gem 'font-awesome-sass'
gem 'symbolize'
gem 'scoped_search'
gem 'rails-settings-cached', "~> 0.4.1"
gem 'rails-latex'
gem 'nokogiri', "~> 1.6.0"
gem 'icalendar'
gem 'activerecord-deprecated_finders', require: 'active_record/deprecated_finders'
gem 'activeresource', require: 'active_resource'
gem 'whenever', :require => false
gem 'memcache-client'
gem 'identicon'
gem 'responders', '~> 2.0'
gem 'modernizr-rails'

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
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'unicorn'
end

group :test, :development do
  gem 'pry-rails'
end