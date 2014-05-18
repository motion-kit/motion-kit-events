class AppDelegate
  def applicationDidFinishLaunching(notification)
    return true if RUBYMOTION_ENV == 'test'

    NSApp.mainMenu = MainMenu.new.menu

    @controller = LoginController.alloc.init
    @controller.showWindow(self)
    @controller.window.orderFrontRegardless
  end

end
