local objs = {}


-- Immage stream thread object
objs[1] = {}
objs[1].name = "stream_thread"
objs[1].thread = love.thread.newThread( "stream.lua" )
objs[1].channel = love.thread.getChannel( "data" )
objs[1].buf = {}
objs[1].load = function( self )
	self.thread:start()
end
objs[1].update = function(self, dt)
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
objs[1].draw = function(self)
	if self.image then
		love.graphics.draw(self.image, 0, 0)
	end
end

-- Control object and thread
objs[2] = {}
objs[2].name = "control_object"
objs[2].thread = love.thread.newThread( "comand.lua" )
objs[2].channel = love.thread.getChannel( "app" )
objs[2].load = function (self)
	self.thread:start()
	
	keys.pressed[love.keyboard.getScancodeFromKey( "w" )] = function() self.thread:push("forward") end
	keys.pressed[love.keyboard.getScancodeFromKey( "a" )] = function() self.thread:push("left") end
	keys.pressed[love.keyboard.getScancodeFromKey( "s" )] = function() self.thread:push("back") end
	keys.pressed[love.keyboard.getScancodeFromKey( "d" )] = function() self.thread:push("right") end
	keys.pressed[love.keyboard.getScancodeFromKey( "q" )] = function() love.event.quit() end
end


return objs
