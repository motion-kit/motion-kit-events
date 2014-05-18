class LoginController < UIViewController

  def loadView
    @layout = LoginLayout.new
    self.view = @layout.view

    @layout.on :login do |username, password|
      @layout.pause_ui
      # send login info to the API (I would recommend using a separate class
      # to handle the API conversation, e.g. a LoginStorage class).
      storage.login(username, password) do |user, errors|
        handle_login(user, errors)
      end
    end
  end

  def storage
    @storage ||= LoginStorage.new
  end

  def handle_login(user, errors)
    @layout.resume_ui

    if user
      UIAlertView.alert('Success!')
    elsif ! errors.empty?
      UIAlertView.alert('Error', errors.first)
    end
  end

end
