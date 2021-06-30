socket = require("socket")
local data_ch = love.thread.getChannel( 'data' )
local app_ch = love.thread.getChannel( 'app' )
local stop = false
local app_cmd
local comand = {0, 0}

local tcp_control_server = socket.bind("*", 3334)

local tcp_control_client = tcp_control_server:accept()

while not stop do

	app_cmd = app_ch:pop()
	
	if app_cmd == "stop" then
		stop = true
		break
	elseif app_cmd then
		if app_cmd == "forward" then
			comand[1] = 1;
		elseif app_cmd == "back" then
			comand[1] = 2;
		elseif app_cmd == "left" then
			comand[2] = 1;
		elseif app_cmd == "right" then
			comand[2] = 2;
		elseif app_cmd == "stop_turn" then
			comand[2] = 0;
		elseif app_cmd == "stop_moov" then
			comand[1] = 0;
		end
		
		tcp_control_client:send(table.concat(comand))
	end

end
