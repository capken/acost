require File.join(File.expand_path(File.dirname(__FILE__)), '/config/load')

class App < Sinatra::Base

  use Service::Account

  get '/' do
    "User authenticated? => #{env['warden'].authenticate?}"
  end

  get '/protected' do
    env['warden'].authenticate!(:access_token)

    json env['warden'].user
  end

  post '/buckets' do
    env['warden'].authenticate!(:access_token)

    bucket = Bucket.new do |b|
      b.name = params['name']
      b.region = params['region']
    end

    bucket.user = env['warden'].user
    bucket.save

    status 200
    json data: { type: 'bucket', id: bucket.id, name: bucket.name, region: bucket.region }
  end

  put '/buckets/:id' do
    env['warden'].authenticate!(:access_token)
    user_id = env['warden'].user.id

    bucket = Bucket.find_by id: params['id'], user_id: user_id
    if bucket
      bucket.name = params['name'] if params['name']
      bucket.region = params['region'] if params['region']
      bucket.save

      status 200
      json data: { type: 'bucket', id: bucket.id, name: bucket.name, region: bucket.region }
    else
      status 404
      json errors: [{ title: 'Bucket not found' }]
    end
  end

end
