ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

require File.join(File.expand_path(File.dirname(__FILE__)), '../app')
