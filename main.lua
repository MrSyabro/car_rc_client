e = require "engine"

function love.load()
	e:load_scene("menu.lua")
	e:load()
end

function love.update(dt)
	e:update(dt)
end

function love.draw()
	e:draw()
end

function love.keypressed(key, scancode, isrepeat)
	e:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	e:keyreleased(key, scancode)
end

function love.textinput(t)
	e:textinput(t)
end

function love.mousemoved( x, y, dx, dy, istouch )
	e:mousemoved( x, y, dx, dy, istouch )
end

function love.mousepressed( x, y, button, istouch, presses )
	e:mousepressed( x, y, button, istouch, presses )
end

function love.mousereleased( x, y, button, istouch, presses )
	e:mousereleased( x, y, button, istouch, presses )
end

function love.wheelmoved( x, y )
	e:wheelmoved( x, y )
end

function love.quit()
	print("Thanks for playing! Come back soon!")
	love.thread.getChannel( "app" ):push("stop")
end
