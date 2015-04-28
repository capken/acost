module Service
  class Auth < Sinatra::Base

    post '/auth/session' do
      params = JSON.parse request.body.read.to_s

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

    delete '/auth/session' do
      #TODO: reset access token to be empty string
    end

    post '/auth/unauthenticated' do
      status 401
      json msg: 'Unauthenticated'
    end

    use Warden::Manager do |config|
      config.scope_defaults :default,
                            strategies: [:access_token],
                            action: '/auth/unauthenticated'

      config.failure_app = self
    end

    Warden::Manager.before_failure do |env,opts|
      env['REQUEST_METHOD'] = 'POST'
    end

    Warden::Strategies.add(:access_token) do
      def valid?
        access_token = request.env["HTTP_ACCESS_TOKEN"]

        access_token.is_a?(String) and !access_token.empty?
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
end
