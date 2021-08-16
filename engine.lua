utf8 = require "utf8"

local M = {}

M.textinput = ""

function M:init(love)
	function love.load()
		self:load()
	end
	
	function love.update(dt)
		self:update(dt)
	end
	
	function love.draw()
		self:draw()
	end
	
	function love.keypressed(key, scancode, isrepeat)
		self:keypressed(key, scancode, isrepeat)
	end
	
	function love.keyreleased(key, scancode)
		self:keyreleased(key, scancode)
	end
	
	function love.textinput(t)
		self:textinput(t)
	end
	
	function love.mousemoved( x, y, dx, dy, istouch )
		self:mousemoved( x, y, dx, dy, istouch )
	end
	
	function love.mousepressed( x, y, button, istouch, presses )
		self:mousepressed( x, y, button, istouch, presses )
	end
	
	function love.mousereleased( x, y, button, istouch, presses )
		self:mousereleased( x, y, button, istouch, presses )
	end
	
	function love.wheelmoved( x, y )
		self:wheelmoved( x, y )
	end
	
	function love.quit()
		print("Thanks for playing! Come back soon!")
		--love.thread.getChannel( "app" ):push("stop")
	end
end

local function generate_scene()
	local S = {}
	S.keys = {}
	S.keys.pressed = {}
	S.keys.released = {}
	S.mouse = {}
	S.mouse.pressed = {}
	S.mouse.released = {}
	S.mouse.move = {}
	S.mouse.wheel = {}
	S.touch = {}
	S.touch.pressed = {}
	S.touch.released = {}
	S.touch.moove = {}
	
	function S:register_kb_callback (event, obj)
		assert(self.keys[event])
		table.insert(self.keys[event], obj)
	end
	
	function S:register_mouse_callback (event, obj)
		assert(self.mouse[event])
		table.insert(self.mouse[event], obj)
	end

	function S:register_touch_callback (event, obj)
		assert(self.touch[event])
		table.insert(self.touch[event], obj)
	end
	
	function S:select_obj (obj)
		if self.selected ~= obj then
			if self.selected then
				self.selected.selected = false
			end
			self.selected = obj
			self.selected.selected = true
			print("Select object:" .. obj.name)
		end
	end

	function S:add_object(obj)
		table.insert(self, obj)
		obj:load()
	end
	
	return S
end

function M:load_scene(file_name)
	local env = _G
	env.objs = generate_scene()
	self.current_scene = assert(loadfile(file_name, "bt", env))()
	self.current_scene:select_obj(self.current_scene[1])
end

function M:load()	
	for k, object in ipairs(self.current_scene) do
		if object.load then
			object:load()
		end
	end
end

function M:update(dt)
	for k, object in ipairs(self.current_scene) do
		if object.update then
			object:update(dt)
		end
	end
end

function M:draw()
	for k, object in ipairs(self.current_scene) do
		if object.draw then
			object:draw()
		end
	end
end

function M:keypressed(key, scancode, isrepeat)
	if key == "backspace" and self.current_scene.selected.textinput then
		-- get the byte offset to the last UTF-8 character in the string.
		local byteoffset = utf8.offset(self.current_scene.selected.textinput, -1)

		if byteoffset then
			-- remove the last UTF-8 character.
			-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
			self.current_scene.selected.textinput = string.sub(self.current_scene.selected.textinput, 1, byteoffset - 1)
		end
	end
	
	for k, obj in ipairs(self.current_scene.keys.pressed) do
		obj:keypressed(scancode, isrepeat)
	end
end

function M:keyreleased(key, scancode)
	for k, obj in ipairs(self.current_scene.keys.released) do
		obj:keyreleased(scancode)
	end
end

function M:mousemoved( x, y, dx, dy, istouch )
	for k, obj in ipairs(self.current_scene.mouse.move) do
		obj:mousemoved(x ,y, dx, dy, istouch)
	end
end

function M:mousepressed( x, y, button, istouch, presses )
	for k, obj in ipairs(self.current_scene.mouse.pressed) do
		obj:mousepressed(x, y, button, istouch, presses)
	end
end

function M:mousereleased( x, y, button, istouch, presses )
	for k, obj in ipairs(self.current_scene.mouse.released) do
		obj:mousereleased(x, y, button, istouch, presses)
	end
end

function M:wheelmoved( x, y )
	for k, obj in ipairs(mouse.wheel) do
		obj:wheelmoved(x, y)
	end
end

function M:touchmoved( x, y, dx, dy, istouch )
	for k, obj in ipairs(self.current_scene.touch.move) do
		obj:touchmoved(x ,y, dx, dy, istouch)
	end
end

function M:touchpressed( x, y, button, istouch, presses )
	for k, obj in ipairs(self.current_scene.touch.pressed) do
		obj:touchpressed(x, y, button, istouch, presses)
	end
end

function M:touchreleased( x, y, button, istouch, presses )
	for k, obj in ipairs(self.current_scene.touch.released) do
		obj:touchreleased(x, y, button, istouch, presses)
	end
end

function M:textinput(t)
	if self.current_scene.selected.textinput then
		self.current_scene.selected.textinput = self.current_scene.selected.textinput .. t
	end
end


return M
