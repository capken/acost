
User.delete_all

user = User.new do |u|
  u.name = 'allen'
  u.email = 'cap.ken@gmail.com'
  u.password = 'test'
  u.access_token = SecureRandom.hex
end

user.save
