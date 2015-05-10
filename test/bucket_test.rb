require File.join(File.expand_path(File.dirname(__FILE__)), '../config/test')

class BucketTest < MiniTest::Unit::TestCase

  SAMPLE_TOKEN = SecureRandom.hex

  include Rack::Test::Methods

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
  end

  def teardown
    User.delete_all
    Bucket.delete_all
  end

  def test_create_or_update_bucket
    params = { name: 'sample_bucket', region: 'us-west-1' }
    headers = { 'HTTP_ACCESS_TOKEN' => SAMPLE_TOKEN }

    post '/buckets', params, headers
    assert last_response.ok?

    data = JSON[last_response.body]['data']
    assert data

    bucket = Bucket.find data['id']
    assert bucket
    assert_equal 'sample_bucket', bucket.name
    assert_equal 'us-west-1', bucket.region

    put "/buckets/#{bucket.id}", { name: 'another-bucket' }, headers

    bucket = Bucket.find data['id']
    assert bucket
    assert_equal 'another-bucket', bucket.name
    assert_equal 'us-west-1', bucket.region
  end

end
