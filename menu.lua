local ui = require "love_engine.UI"
local u = require "love_engine.utils"

local info_text = ui.new_text("info_text", u.tc(0.5, 0.5))
info_text.printed_name = "Connecting"
objs:add(info_text)

local control

local quit_button = ui.new_button("quit_button", u.tc(0.1, 0.1))
quit_button.printed_name = "Quit"
function quit_button.callbacks.mousepressed()
	control.channel:push({cmd = "quit"})
	love.event.quit()
end
objs:add(quit_button)


local turn_controller = ui.new_object("right_button")
turn_controller.stick_data = {}
turn_controller.last_state = 0
function turn_controller:load()
	self.stick = love.joystick.getJoysticks()[1]

	if self.stick then
		u.info("Joystick connected")
		function self:update(dt)
			local ax = self.stick:getAxis(1)
			if ax < -0.3 then
				if self.last_state ~= -1 then
					control.channel:push {cmd = "left"}
					self.last_state = -1
				end
			elseif ax > 0.3 then
				if self.last_state ~= 1 then
					control.channel:push {cmd = "right"}
					self.last_state = 1
				end
			else
				if self.last_state ~= 0 then
					control.channel:push {cmd = "stop_turn"}
					self.last_state = 0
				end
			end
		end
	else
		u.info("Joystick not found")
		objs:remove(self)
	end
end

local v_slider = ui.new_vertical_slider("power", u.tc(0.05, 0.5))
v_slider.state.default = 0.5
v_slider.state.current = 0.5
function v_slider.callbacks.mousereleased(self)
	u.info(("Slider mousereleased '%s' whith state: %f"):format(self.name, self.state.current))
	self:change_state(self.state.default)
end
function v_slider.callbacks.statechanged(self)
	u.info(("Slider '%s' state changed: %f"):format(self.name, self.state.current))
	local _data = (self.state.current - 0.5) * 2
	if _data > 0.3 or _data < -0.3 then
		control.channel:push {cmd = "moov", data = _data}
	else
		control.channel:push {cmd = "moov", data = 0}
	end
end

control = ui.new_object("control")
control.thread = love.thread.newThread( "comand.lua" )
control.channel = love.thread.getChannel( "app" )
control.connected = false
control.load = function (self)
	self.thread:start()
	u.info("Waiting for connection")
end
function control:update (dt)
	local info_data = self.channel:pop()

	if not self.connected then
		if info_data and info_data.connected then
			u.info("Client connected.")
			self.connected = true

			-- TODO: video service

			objs:remove(info_text)
			objs:add(turn_controller)
			objs:add(v_slider)
		elseif info_data and not info_data.connected then
			u.error("Client not conected. Err = "..info_data.err or "")
			info_text.printed_name = "Error: "..info_data.err or ""
		end
	end
end
objs:add (control)



--[[
local renderer = ui.new_object("stream_renderer", 0, 0, u.tc(1, 1))
renderer.thread = love.thread.newThread( "stream.lua" )
renderer.channel = love.thread.getChannel( "data" )
renderer.buf = {}
renderer.load = function( self )
	self.thread:start()
end
renderer.update = function(self, dt)
	data_f = self.channel:pop()
	sep = string.find(data_f, "\0")
	if sep then
		data_to_sep = string.sub(s, 1, sep-1)
		table.insert(self.buf, data_to_sep)

		immage_data = love.filesystem.newFileData( table.concat(self.buf), "fb" )
		self.image = love.graphics.newImage( immage_data )

		self.buf = {}
		data_after_sep = string.sub(s, sep+1)
		table.insert(self.buf, data_after_sep)
	else
		table.insert(self.buf, data_f)
	end
end
renderer.draw = function(self)
	if self.image then
		love.graphics.draw(self.image, 0, 0)
	end
end]]
