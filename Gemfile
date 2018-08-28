# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

gem 'pry'

if ENV['CI']
  gem 'coveralls', group: :development if ENV['TRAVIS_RUBY_VERSION'] == '2.5'
end
