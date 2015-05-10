ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require File.join(File.expand_path(File.dirname(__FILE__)), '../app')

class AccountTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    App
  end

  def setup
    User.delete_all

    @token = SecureRandom.hex
    @user = User.new do |u|
      u.name = 'allen'
      u.email = 'cap.ken@gmail.com'
      u.password = 'test'
      u.access_token = @token
    end
    @user.save
  end

  def test_create_new_token
    post '/access_tokens', { email: 'cap.ken@gmail.com', password: 'test' }
    assert last_response.ok?
  end

  def test_delete_token
    delete "/access_tokens/#{@token}"
    warn last_response.body
    #assert last_response.ok?

    user = User.find_by email: @user.email
    assert user
    assert_equal '', user.access_token
  end
end
