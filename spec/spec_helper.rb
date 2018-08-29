# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  track_files 'lib/**/*.rb'
  add_filter '/spec/'
  add_filter 'lib/happymapper/version.rb'
end

if ENV['CI']
  begin
    require 'coveralls'
    Coveralls.wear!
  rescue LoadError
    nil
  end
end

require 'rspec'

require 'nokogiri-happymapper'

def fixture_file(filename)
  File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
end
