require File.join(File.expand_path(File.dirname(__FILE__)), '../config/test')

class AccountTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  SAMPLE_TOKEN = SecureRandom.hex
  SAMPLE_VALIDATION_CODE = SecureRandom.hex 5

  def app
    App
  end

  def setup
    @user = User.new do |u|
      u.name = 'allen'
      u.email = 'cap.ken@gmail.com'
      u.password = 'test'
      u.access_token = SAMPLE_TOKEN
    end
    @user.save

    validation = Validation.new do |v|
      v.code = SAMPLE_VALIDATION_CODE
      v.purpose = 'email_check'
      v.email = 'c.apken@gmail.com'
    end
    validation.save

    validation = Validation.new do |v|
      v.code = SAMPLE_VALIDATION_CODE
      v.purpose = 'password_reset'
      v.email = 'cap.ken@gmail.com'
    end
    validation.save
  end

  def teardown
    User.delete_all
    Validation.delete_all
  end

  def test_create_new_token
    post '/access_tokens', { email: 'cap.ken@gmail.com', password: 'test' }
    assert last_response.ok?
  end

  def test_delete_token
    delete "/access_tokens/#{SAMPLE_TOKEN}"
    assert last_response.ok?

    user = User.find_by email: @user.email
    assert user
    assert_equal '', user.access_token
  end

  def test_create_new_validation
    post '/validations', { email: 'capk.en@gmail.com', purpose: 'email_check' }
    assert last_response.ok?
  end

  def test_validation_check
    put "/validations/#{SAMPLE_VALIDATION_CODE}", { email: 'cap.ken@gmail.com', purpose: 'password_reset' }
    assert last_response.ok?
  end

  def test_create_new_user
    post '/users', { email:'c.apken@gmail.com',
                     name: 'Bill Gates',
                     password: 'test',
                     code: SAMPLE_VALIDATION_CODE }
    assert last_response.ok?
  end

  def test_change_password
    put '/users/password', { email:'cap.ken@gmail.com',
                             password: 'new_password',
                             code: SAMPLE_VALIDATION_CODE }
    assert last_response.ok?
  end

end
