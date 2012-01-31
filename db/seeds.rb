User.find_or_create_by_email(:email => 'user@example.com',
                             :password => 'password',
                             :password_confirmation => 'password')
