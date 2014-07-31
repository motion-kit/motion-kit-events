class LoginStorage

  def login(username, password, &handler)
    errors = []
    if username == 'motion' && password == 'kit'
      user = true
    else
      user = false
      errors << 'Invalid credentials'
    end

    3.later do
      handler.call(nil, errors)
    end
  end

end
