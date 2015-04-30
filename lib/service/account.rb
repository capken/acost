module Service
  class Account < Sinatra::Base

    TOKEN_HEADER = 'HTTP_ACCESS_TOKEN'

    post '/validation' do
      case params['purpose']
      when /^(email_check|password_reset)$/
        validation = Validation.new do |v|
          v.code = SecureRandom.hex 5
          v.purpose = params['purpose']
          v.email = params['email']
        end
        validation.send_mail
        status 200
      else
        status 403
        json errors: [{ title: 'Purpose value is not correct' }]
      end
    end

    put '/validation' do
      validation = Validation.find_by code: params['code'],
                                      email: params['email'],
                                      purpose: params['purpose']
      if validation
        status 200
      else
        status 403
        json errors: [{ title: 'Validation and code mismatch' }]
      end
    end

    post '/access_token' do
      user = User.find_by email: params['email']
      if user and user.authenticate(params['password'])
        user.access_token = SecureRandom.hex
        user.save

        status 200
        json data: { type: 'access_token', value: user.access_token }
      else
        status 404
        json errors: [{ title: 'Email not found or password mismatch' }]
      end
    end

    delete '/access_token/:token' do
      count = User.update_all(
          "access_token = ''", "access_token = #{params['token']}")
      if count > 0
        status 200
      else
        status 403
        json errors: [{ title: 'Access token is invalid' }]
      end
    end

    post '/unauthenticated' do
      status 401
      json errors: { title: 'Unauthenticated' }
    end

    use Warden::Manager do |config|
      config.scope_defaults :default,
                            strategies: [:access_token],
                            action: '/unauthenticated'

      config.failure_app = self
    end

    Warden::Manager.before_failure do |env, opts|
      env['REQUEST_METHOD'] = 'POST'
    end

    Warden::Strategies.add(:access_token) do
      def valid?
        access_token = request.env[TOKEN_HEADER]
        access_token.is_a?(String) and !access_token.empty?
      end

      def authenticate!
        user = User.find_by access_token: request.env[TOKEN_HEADER]

        if user.nil?
          fail!('Access token not found')
        else
          success!(user)
        end
      end
    end

  end
end
