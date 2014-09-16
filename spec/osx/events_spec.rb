describe 'MotionKit::Events' do

  before do
    @controller = EventsController.alloc.init
    @controller.showWindow(self)
    @controller.window.orderFrontRegardless
  end

  it 'should respond to the layout trigger' do
    @controller.success.should.not == true
    @controller.layout.trigger(:test)
    @controller.success.should == true
  end

  it 'should respond to the test button' do
    @controller.success.should.not == true
    target = @controller.test_button.target
    action = @controller.test_button.action
    target.send(action)
    @controller.success.should == true
  end

  context 'when the event is removed' do

    it 'should not respond to the test button' do
      @controller.remove_events
      @controller.success.should.not == true
      target = @controller.test_button.target
      action = @controller.test_button.action
      target.send(action)
      @controller.success.should.not == true
    end

  end

end
