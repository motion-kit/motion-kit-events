class LoginLayout < MK::WindowLayout

  def layout
    frame [[335, 390], [340, 139]]
    styleMask NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask
    contentMinSize [340, 117]
    contentMaxSize [340, 117]

    @username_field = add NSTextField, :username_field
    @password_field = add NSSecureTextField, :password_field
    @status_field = add NSTextField, :status_field
    add NSButton, :login_button
  end

  def pause_ui
    @username_field.enabled = false
    @password_field.enabled = false
  end

  def resume_ui
    @username_field.enabled = true
    @password_field.enabled = true
  end

  def username_field_style
    constraints do
      top.equals(:superview).plus(8)
      left.equals(:superview).plus(8)
      right.equals(:superview).minus(8)
    end

    editable true
    selectable true
    bordered true
    font NSFont.fontWithName('Monaco', size: 12)

    cell do
      alignment NSLeftTextAlignment
      scrollable false
      drawsBackground false
    end

    initial do
      stringValue 'Username'
    end

    setTarget self
    setAction :next_input
  end

  def next_input
    @password_field.becomeFirstResponder
  end

  def password_field_style
    constraints do
      top.equals(:username_field, :bottom).plus(8)
      left.equals(:superview).plus(8)
      right.equals(:superview).minus(8)
    end

    editable true
    selectable true
    bordered true
    font NSFont.fontWithName('Monaco', size: 12)

    cell do
      alignment NSLeftTextAlignment
      scrollable false
      drawsBackground false
    end

    initial do
      stringValue 'Password'
    end

    setTarget self
    setAction :submit
  end

  def login_button_style
    constraints do
      top.equals(:password_field, :bottom).plus(8)
      right.equals(:superview).minus(8)
    end

    setTitle 'Login'
    setButtonType NSMomentaryLightButton
    setBezelStyle NSRoundedBezelStyle

    setTarget self
    setAction :submit
  end

  def submit
    username = @username_field.stringValue
    password = @password_field.stringValue
    trigger :login, username, password
  end

  def status_field_style
    constraints do
      left.equals(:username_field)
      center_y.equals(:login_button)
      right.equals(:login_button, :left)
    end

    editable false
    selectable false
    bordered false
    font NSFont.fontWithName('Monaco', size: 12)

    cell do
      alignment NSLeftTextAlignment
      scrollable false
      drawsBackground false
    end

    initial do
      stringValue ''
    end
  end

  def status(value)
    get(:status_field).stringValue = value
  end

end
