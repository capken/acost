require 'rubygems'
require 'bundler/setup'

require 'logger'
require 'json'
require 'yaml'

require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra/json'

require 'warden'

require 'securerandom'

CODE_ROOT = File.join(
    File.expand_path(File.dirname(__FILE__)),
    '..'
) unless defined? CODE_ROOT

%w[model].each do |dir|
  Dir.glob(File.join(CODE_ROOT, "lib/#{dir}/*.rb")).each do |lib_name|
    warn "loading ==> #{lib_name}"
    require lib_name
  end
end