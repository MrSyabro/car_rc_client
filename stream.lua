socket = require("socket")
local data_ch = love.thread.getChannel( 'data' )
local app_ch = love.thread.getChannel( 'app' )
local stop = false
local app_cmd, len, data

local udp_immage_client = socket.udp()

while not stop do

	app_cmd = app_ch:pop()
	
	if app_cmd == "stop" then
		stop = true
		break
	end

	data = udp_immage_client:receive()
	data_ch:push( data )

end
