class Validation < ActiveRecord::Base

  def send_mail
    puts self.inspect
    Pony.mail :to => self.email,
              :from => 'capken@gmail.com',
              :subject => 'Email Confirmation',
              :body => self.code
    self.save
  end
end