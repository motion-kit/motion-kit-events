describe 'MotionKit::Events' do
  tests EventsController

  it 'should respond to the layout trigger' do
    controller.success.should.not == true
    controller.layout.trigger(:test)
    controller.success.should == true
  end

  it 'should respond to the test button' do
    controller.success.should.not == true
    controller.test_button.trigger(:touch)
    controller.success.should == true
  end

end
