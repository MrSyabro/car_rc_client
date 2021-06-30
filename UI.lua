local M = {}


function M.create_button (name, x, y, w, h)
	button = {}
	button.name = "ip_submit_button"
	button.printed_name = "Connect"
	button.pos = {}
	button.pos.x = 20
	button.pos.y = 45
	button.size = {}
	button.size.h = 20
	button.size.w = 80
	button.colors = {}
	button.colors.background = { 1, 1, 1, 1 }
	button.colors.text = { 0, 0, 0, 1 }
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
				self.text:set({ self.colors.text, "OK!" })
			end
		end
	end
	--[[button.mousereleased = function (self, x, y, button, istouch, presses)
		if button == 1 then
			tmp_x = x - self.pos.x
			tmp_y = y - self.pos.y
			if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
				self.text:set({ self.colors.text, self.printed_name })
			end
		end
	end]]--
end

function M.create_textentry (name, x, y, w, h)
	
end


return M
