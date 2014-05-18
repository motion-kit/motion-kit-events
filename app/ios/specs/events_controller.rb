class EventsController < UIViewController
  attr :success
  attr :layout
  attr :test_button

  def reset
    @success = false
  end

  def loadView
    @layout = EventsLayout.new
    self.view = @layout.view

    @test_button = @layout.get(:test)

    @layout.on :test do
      @success = true
      @test_button.setTitle('Success!', forState: UIControlStateNormal)
    end
  end

end


class EventsLayout < MK::Layout

  def layout
    add UIButton, :test
  end

  def test_style
    title 'Test'
    frame :full

    on :touch do
      trigger_test
    end
  end

  def trigger_test
    trigger :test
  end

end
