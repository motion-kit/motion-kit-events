class LoginStorage

  def login(username, password, &handler)
    errors = []
    if username == 'motion' && password == 'kit'
      user = true
    else
      user = false
      errors << 'Invalid credentials'
    end

    1.later do
      handler.call(user, errors)
    end
  end

end
