# @requires MotionKit::BaseLayout
module MotionKit
  class BaseLayout

    def motion_kit_event_handlers
      @motion_kit_event_handlers ||= {}
    end

    def on(*args, &handler)
      if @context || @assign_root
        apply_with_target(:on, *args, &handler)
      else
        event = args.first
        unless event
          raise ArgumentError.new('`event` is a required argument to Layout#on')
        end
        motion_kit_event_handlers[event] ||= []
        motion_kit_event_handlers[event] << handler.weak!

        self
      end
    end

    def trigger(*args, &handler)
      if @context
        apply(:trigger, *args, &handler)
      else
        event = args.first
        unless event
          raise ArgumentError.new('`event` is a required argument to Layout#on')
        end

        if motion_kit_event_handlers[event]
          motion_kit_event_handlers[event].each do |handler|
            handler.call(args[1..-1])
          end
        end

        self
      end
    end

  end

end
