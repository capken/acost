require './config/load'

class App < Sinatra::Base

  use Service::Account

  get '/' do
    "User authenticated? => #{env['warden'].authenticate?}"
  end

  get '/protected' do
    env['warden'].authenticate!(:access_token)

    json env['warden'].user
  end

end
