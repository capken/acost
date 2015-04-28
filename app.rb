require './config/load'

class App < Sinatra::Base

  use Service::Auth
  use Service::Account

  get '/' do
    "User authenticated? => #{env['warden'].authenticate?}"
  end

  get '/protected' do
    env['warden'].authenticate!(:access_token)
    env['warden'].user.to_json
  end

end
