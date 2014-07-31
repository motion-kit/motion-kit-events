class LoginController < UIViewController

  def loadView
    super
    @layout = LoginLayout.new()
    self.view = @layout.view

    @layout.on :login do |username, password|
      handle_login(username, password)
    end
  end

  def storage
    @storage ||= LoginStorage.new
  end

  def handle_login(username, password)
    @layout.pause_ui
    # send login info to the API (I would recommend using a separate class
    # to handle the API conversation, e.g. a LoginStorage class).
    storage.login(username, password) do |user, errors|
      @layout.resume_ui

      if user
        handle_success
      elsif ! errors.empty?
        handle_error(errors)
      end
    end
  end

  def handle_error(errors)
    UIAlertView.alert('Error', errors.first)
  end

  def handle_success
    UIAlertView.alert('Success!')
  end

end
