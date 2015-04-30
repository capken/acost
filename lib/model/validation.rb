class Validation < ActiveRecord::Base

  def send_mail
    Pony.mail :to => self.email,
              :from => 'capken@gmail.com',
              :subject => 'Email Confirmation',
              :body => self.code
    self.save
  end
end