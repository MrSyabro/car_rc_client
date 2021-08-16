local M = {}


function M.new_grid (name)
	grid = {}
	grid.name = name
	--grid.printed_name = name
	grid.pos = {}
	grid.pos.x = x
	grid.pos.y = y
	grid.size = {}
	grid.size.h = h
	grid.size.w = w
	grid.child_widgets = {}
	grid.add_child = function(self, widget)
		widget.parrent = self

	end
end

function M.create_button (name, x, y, w, h)
	button = {}
	button.name = name
	button.printed_name = name
	button.pos = {}
	button.pos.x = x
	button.pos.y = y
	button.size = {}
	button.size.h = h
	button.size.w = w
	button.colors = {}
	button.colors.background = { 1, 1, 1, 1 }
	button.colors.text = { 0, 0, 0, 1 }
	button.callbacks = {}
	button.load = function (self)
		self.font = love.graphics.getFont()
		self.text = love.graphics.newText(self.font, { self.colors.text, self.printed_name })
		objs:register_mouse_callback("pressed", button)
		objs:register_mouse_callback("released", button)
	end
	button.draw = function (self)
		love.graphics.setColor( self.colors.background )
		love.graphics.polygon( "fill", 
			self.pos.x, self.pos.y, 
			self.pos.x + self.size.w, self.pos.y, 
			self.pos.x + self.size.w, self.pos.y + self.size.h, 
			self.pos.x, self.pos.y + self.size.h )
		love.graphics.draw(self.text, self.pos.x, self.pos.y)
	end
	button.mousepressed = function (self, x, y, button, istouch, presses)
		if button == 1 then
			tmp_x = x - self.pos.x
			tmp_y = y - self.pos.y
			if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
				if self.callbacks.mousepressed then
					self.callback.mousepressed()
				end
			end
		end
	end

	button.set_callback = function(self, event, callback)
		table.insert(self.callbacks, event, callback)
	end
	button.mousereleased = function (self, x, y, button, istouch, presses)
		if button == 1 then
			tmp_x = x - self.pos.x
			tmp_y = y - self.pos.y
			if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
				if self.callbacks.mousereleased then
					self.callback.mousereleased()
				end
			end
		end
	end
end

function M.create_textentry (name, x, y, w, h)
	textentry = {}
	textentry.name = name
	textentry.printed_name = name
	textentry.pos = {}
	textentry.pos.x = x
	textentry.pos.y = y
	textentry.size = {}
	textentry.size.h = h
	textentry.size.w = w
	textentry.textinput = ""
	textentry.color = { 1, 1, 1, 0.8 }
	textentry.color.selected = { 1, 1, 1, 1 }
	textentry.load = function ( self )
		objs:register_mouse_callback("pressed", self)
	end
	textentry.draw = function ( self )
		if self.selected then 
			love.graphics.setColor( self.color.selected )
		else
			love.graphics.setColor( self.color )
		end
		love.graphics.polygon( "line", 
			self.pos.x, self.pos.y, 
			self.pos.x + self.size.w, self.pos.y, 
			self.pos.x + self.size.w, self.pos.y + self.size.h, 
			self.pos.x, self.pos.y + self.size.h )
		love.graphics.print(self.printed_name, self.pos.x - 15, self.pos.y + 4)
		love.graphics.print(self.textinput, self.pos.x + 5, self.pos.y + 4)
	end
	textentry.mousepressed = function (self, x, y, button, istouch, presses)
		if button == 1 then
			tmp_x = x - self.pos.x
			tmp_y = y - self.pos.y
			if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
				objs:select_obj(self)
			end
		end
	end

	return textentry
end


return M
