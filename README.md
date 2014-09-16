MotionKit::Events
--------

In an effort to encourage even MORE separation of concerns in your Controllers
and Layouts, the `motion-kit-events` gem provides a way to listen for custom
events (usually triggered by buttons or other UI events) and respond in your
controller. This keeps your views from being cluttered with business logic and
your controllers from being cluttered with view code.

## LoginController

An example of a UIViewController using MotionKit::Events:

```ruby
class LoginController < UIViewController

  def viewDidLoad
    @layout = LoginLayout.new(root: self.view).build

    @layout.on :login { |username, password| initiate_login(username, password) }
    @layout.on :forgot_password { show_forgot_password }
    @layout.on :help { show_help }
  end

  def initiate_login(username, password)
    @layout.pause_ui
    # send login info to the API
    API::Client.login(username, password) do |user, errors|
      handle_login_response(user, errors)
    end
  end

  def handle_login_response(user, errors)
    # ...
    @layout.resume_ui
  end

  # ...

end
```

Now we can test *just the behavior* of the controller.  When it receives a
`:login` event, it should send a `login` request to its API and handle
`user` or `errors`.


## LoginLayout

```ruby
class LoginLayout < MK::Layout

  def layout
    add UITextField, :username_field do
      delegate self
    end

    add UITextField, :password_field do
      delegate self
    end

    add UIButton, :login_button do
      on :touch do # This is Sugarcube
        trigger_login
      end
    end
  end

  def trigger_login
    # send the username and password to our controller
    trigger :login, get(:username_field).text.to_s, get(:password_field).text.to_s
  end

  def textFieldShouldReturn(field)
    if field == get(:password_field)
      trigger_login
    else
      get(:password_field).becomeFirstResponder
    end
  end

end
```

### Testing

The layout can be tested independently of the controller.

```ruby
describe LoginLayout do
  before do
    @subject = LoginLayout.new(root: UIView.new).build
  end

  it "triggers :login with username/password when the login button is tapped" do
    @subject.on :login do |user, password|
      user.should == "example"
      password.should == "testing123"
    end
    @subject.get(:username_field).text = "example"
    @subject.get(:password_field).text = "testing123"
    # Simulate tap on button
    @subject.get(:login_button).target.send(@subject.get(:login_button).action)
  end
end
```

### An explanation: State vs. UI/events

The Controller focuses on the *movement* of the user and the state;
the Layout handles displaying the UI state and responding to events.

1. The user starts out in a "logging in" state. The controller doesn't care
how this is represented -- it just cares about when the user is *done*, and
then it pauses the UI.
2. When the login attempt is complete, the controller tells the UI what state
to go in next, either resuming the UI if an error occurred, or just dimissing
the controller and passing along the successful login info.

MotionKit::Events is a very lightweight gem.  But using it to decouple your UI
from your controller can provide a huge long term benefit in terms of keeping
your code maintainable!

### Sample app

The sample app (most of the code is in [app/ios/login/][login]) includes a working
version of this example.

[login]: https://github.com/motion-kit/motion-kit-events/tree/master/app/ios/login/

###### Note

The example and specs all require SugarCube to run; this is just because I
wanted to have the specs make sure that the `on` method (used in so many gems)
behaves the way you would expect it to.
