MotionKit::Events
--------

In an effort to encourage even MORE separation of concerns in your Controllers
and Layouts, the `motion-kit-events` gem provides a very way to emit generic
events from your layout that you can respond to in your controller.

## LoginController

An example of a UIViewController using MotionKit::Events:

```ruby
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
    # ...
    @layout.resume_ui
  end

end
```

Before we go on to show the `LoginLayout`, consider for a second how *easy* it
would be to write specs for a controller like this.  We don't need to test the
UI (that will be done in isolation, using the `LoginLayout`) and our controller
doesn't directly send any *requests*, so we can assign it (in our specs) a
`TestLoginLayout` class as the storage, which can imitate the behaviors we are
interested in.  We should also use a fake layout class in there, too.

TL;DR: we can test just the behavior of the controller.  When it receives a
`:login` event, it should send a `login` request to its storage, and handle
`user` or `errors`.


## LoginLayout

We send the `:login` event along with the username and password when the user
presses the login button or presses "Return" from the password field.  This is
all code that would normally be in the UIViewController.  The tight coupling of
the UIViewController and the UI is very common in iOS apps, but there is much to
be gained be decoupling these roles.  The Controller can focus on the *movement*
of the user.

The user starts out in a "logging in" state.  Until they submit credentials, the
controller need not be interested in what the UI is doing to accomodate this
procedure.  It just cares about when the user is *done*, and it pauses the UI.

When the login attempt is complete, the controller tells the UI what state to go
in next, either resuming the UI if an error occurred, or just dimissing the
controller and passing along the successful login info.

If you look at the code provided by MotionKit::Events you'll be happy to see
that it is a *tiny* little gem.  But using it to decouple your UI from your
controller can provide a huge long term benefit in terms of keeping your code
maintainable!

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
      on :touch do
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

The sample app (most of the code is in [app/ios/login/][login]) includes a working
version of this example.

[login]: https://github.com/rubymotion/motion-kit-events/tree/master/app/ios/login/

###### Note

The example and specs all require SugarCube to run; this is just because I
wanted to have the specs make sure that the `on` method (used in so many gems)
behaves the way you would expect it to.
