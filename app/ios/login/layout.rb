class LoginLayout < MK::Layout

  def layout
    background_color UIColor.whiteColor

    @username_field = add UITextField, :username_field do
      delegate self
      placeholder 'Username'
      autocorrectionType UITextAutocorrectionTypeNo
      spellCheckingType UITextSpellCheckingTypeNo
      autocapitalizationType UITextAutocapitalizationTypeNone

      frame from_top_left right: 8, down: 64, size: ['100% - 8', 30]
      autoresizing_mask :pin_to_top_left
    end

    @password_field = add UITextField, :password_field do
      delegate self
      placeholder 'Password'
      secureTextEntry true

      frame below :username_field, down: 8, size: ['100% - 8', 30]
      autoresizing_mask :pin_to_top_left
    end

    add UIButton, :login_button do
      title 'Submit'
      title_color UIColor.blackColor

      size :auto
      frame below :password_field
      right '100% - 8'
      autoresizing_mask :pin_to_top_left
    end

    @spinner = add UIActivityIndicatorView.gray do
      center ['50%', '50%']
      hidden true
    end
  end

  def trigger_login
    # send the username and password to our controller
    trigger :login, @username_field.text.to_s, @password_field.text.to_s
  end

  def pause_ui
    @username_field.enabled = false
    @password_field.enabled = false
    @spinner.startAnimating
    @spinner.hidden = false
  end

  def resume_ui
    @username_field.enabled = true
    @password_field.enabled = true
    @spinner.stopAnimating
    @spinner.hidden = true
  end

  def login_button_style
    target.on :touch do
      trigger_login
    end
  end

  def textFieldShouldReturn(field)
    if field == @password_field
      trigger_login
    else
      @password_field.becomeFirstResponder
    end
  end

end
