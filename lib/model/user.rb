class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create

  has_one :bucket
  has_many :email_verifications
end
