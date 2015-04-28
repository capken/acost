module Service
  class Account < Sinatra::Base

    get '/email_confirmation' do
      validation = Validation.new do |v|
        v.code = SecureRandom.hex 5
        v.purpose = :email_confirmation
        v.email = params['email']
      end
      validation.send_mail
    end

    post '/email_confirmation' do
      v = Validation.find_by code: params['code']
      if v and v.email == params['email']
        #TODO: set validation as used one
        status 200
      else
        status 404
      end
    end

  end
end
