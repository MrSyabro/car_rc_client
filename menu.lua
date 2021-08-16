objs[1] = {}
objs[1].name = "ip_text_input"
objs[1].printed_name = "IP"
objs[1].pos = {}
objs[1].pos.x = 20
objs[1].pos.y = 20
objs[1].size = {}
objs[1].size.h = 20
objs[1].size.w = 80
objs[1].textinput = ""
objs[1].color = { 1, 1, 1, 0.8 }
objs[1].color.selected = { 1, 1, 1, 1 }
objs[1].load = function ( self )
	objs:register_mouse_callback("pressed", self)
end
objs[1].draw = function ( self )
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
objs[1].mousepressed = function (self, x, y, button, istouch, presses)
	if button == 1 then
		tmp_x = x - self.pos.x
		tmp_y = y - self.pos.y
		if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
			objs:select_obj(self)
		end
	end
end

objs[2] = {}
objs[2].name = "ip_submit_button"
objs[2].printed_name = "Connect"
objs[2].pos = {}
objs[2].pos.x = 20
objs[2].pos.y = 45
objs[2].size = {}
objs[2].size.h = 20
objs[2].size.w = 80
objs[2].colors = {}
objs[2].colors.background = { 1, 1, 1, 0.8 }
objs[2].colors.background.selected = { 1, 1, 1, 1 }
objs[2].colors.text = { 0, 0, 0, 1 }
objs[2].load = function (self)
	self.font = love.graphics.getFont()
	self.text = love.graphics.newText(self.font, { self.colors.text, self.printed_name })
	objs:register_mouse_callback("pressed", self)
	objs:register_mouse_callback("released", self)
end
objs[2].draw = function (self)
	if self.selected then love.graphics.setColor( self.colors.background.selected )
	else love.graphics.setColor( self.colors.background ) end
	love.graphics.polygon( "fill", 
	self.pos.x, self.pos.y, 
	self.pos.x + self.size.w, self.pos.y, 
	self.pos.x + self.size.w, self.pos.y + self.size.h, 
	self.pos.x, self.pos.y + self.size.h )
	love.graphics.draw(self.text, self.pos.x, self.pos.y)
end
objs[2].mousepressed = function (self, x, y, button, istouch, presses)
	if button == 1 then
		tmp_x = x - self.pos.x
		tmp_y = y - self.pos.y
		if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
			--self.text:set({ self.colors.text, "OK!" })
			objs:select_obj(self)
		end
	end
end
objs[2].mousereleased = function (self, x, y, button, istouch, presses)
	if button == 1 then
		tmp_x = x - self.pos.x
		tmp_y = y - self.pos.y
		if (tmp_x < self.size.w and tmp_x > 0) and (tmp_y < self.size.h and tmp_y > 0) then
			self.text:set({ self.colors.text, self.printed_name })
		end
	end
end


return objs
