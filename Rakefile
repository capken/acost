require 'sinatra/activerecord/rake'
require 'rake/testtask'

require File.expand_path(File.dirname(__FILE__)) + '/config/load'

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
end
