class LoginController < NSWindowController

  def init
    super.tap do
      @layout = LoginLayout.new
      self.window = @layout.window

      @layout.on :login do |username, password|
        @layout.status 'Sending…'
        storage.login(username, password) do |user, errors|
          handle_login(user, errors)
        end
      end
    end
  end

  def storage
    @storage ||= LoginStorage.new
  end

  def handle_login(user, errors)
    @layout.resume_ui

    if user
      @layout.status 'Success!'
    elsif ! errors.empty?
      @layout.status "Error: #{errors.first}"
    end
  end

end
