class EventsController < NSWindowController
  attr :success
  attr :layout
  attr :test_button

  def reset
    @success = false
  end

  def init
    super.tap do
      @layout = EventsLayout.new
      self.window = @layout.window

      @test_button = @layout.get(:test_button)

      @layout.on :test do
        @success = true
      end
    end
  end

end


class EventsLayout < MK::WindowLayout

  def layout
    add NSButton, :test_button
  end

  def test_button_style
    setTarget self
    setAction :test_pressed
  end

  def test_pressed
    trigger_test
  end

  def trigger_test
    trigger :test
  end

end
