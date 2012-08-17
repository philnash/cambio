require 'rubygems'
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'

require File.join(File.dirname(__FILE__), '..', 'lib', 'cambio')

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
end