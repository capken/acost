require './config/load'

class App < Sinatra::Base

  get '/' do
    'Hello World'
  end

  get '/protected' do
    env['warden'].authenticate!(:access_token)

    'Protected'
  end

  post '/api/session' do
    params = JSON.parse request.body.read.to_s

    warn params.inspect

    user = User.find_by email: params['email']
    if user and user.authenticate(params['password'])
      user.access_token = SecureRandom.hex
      user.save

      status 200
      json access_token: user.access_token
    else
      status 404
      json msg: 'Not found or password mismatch'
    end
  end

  post '/unauthenticated' do
    'Unauthenticated'
  end

  use Warden::Manager do |config|
    config.scope_defaults :default,
       strategies: [:access_token],
       action: '/unauthenticated'

    config.failure_app = self
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:access_token) do
    def valid?
      request.env["HTTP_ACCESS_TOKEN"].is_a?(String)
    end

    def authenticate!
      user = User.find_by access_token: request.env["HTTP_ACCESS_TOKEN"]

      if user.nil?
        fail!("The username you entered does not exist.")
      else
        success!(user)
      end
    end
  end

end