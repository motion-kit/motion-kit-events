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

    # Removes *all* event handlers for the specified event
    def off(*args)
      if @context || @assign_root
        apply_with_target(:off, *args)
      else
        event = args.first
        unless event
          raise ArgumentError.new('`event` is a required argument to Layout#off')
        end
        motion_kit_event_handlers[event] = nil
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
          params = args[1..-1]
          params = params[0] if params.size == 1
          motion_kit_event_handlers[event].each do |handler|
            if handler.arity == 0
              handler.call
            else
              handler.call(*params)
            end
          end
        end

        self
      end
    end

  end

end
