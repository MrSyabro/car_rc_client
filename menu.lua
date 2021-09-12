ui = require "engine.UI"

right_button = ui.new_button("right_button", 20, 10)
right_button.printed_name = ">"
objs:add_object(right_button)

left_button = ui.new_button("left_button", 20, 60)
left_button.printed_name = "<"
objs:add_object(left_button)

v_slider = ui.new_vertical_slider("power", 20, 110, 0.5)
function v_slider.callbacks.mousereleased(self)
    print(("Slider mousereleased '%s' whith state: %f"):format(self.name, self.state.current))
    self:change_state(self.state.default)
end
function v_slider.callbacks.statechanged(self)
    print(("Slider '%s' state changed: %f"):format(self.name, self.state.current))
end
objs:add_object(v_slider)

return objs
