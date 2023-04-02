# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'
gem 'bootsnap', require: false
gem 'jwt'
gem 'pagy', '~> 6.0', '>= 6.0.3'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4'
gem 'socialization'
gem 'sqlite3', '~> 1.4'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'byebug', '~> 11.1'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'timecop'
end

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end
