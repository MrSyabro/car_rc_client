local tcp_control_client = require("socket").tcp()
local timer = require ("love.timer")
local app_ch = love.thread.getChannel( 'app' )
local stop = false
local app_cmd

tcp_control_client:settimeout(1)
local state, err = tcp_control_client:connect("192.168.4.1", 1508)
--local state = true
if state then
	app_ch:push({connected = true})
	timer.sleep(1)
	local data = tcp_control_client:receive("*l")
	local protocol = load("return "..data, "serializer", "t", {})
	local power = 0

	local protocols = {
		raw = {
			moov = function (control_data)
				local data = {}
				if control_data > 0 then
					data[1] = 1
					data[2] = string.char(math.ceil(control_data * 255))
				elseif control_data < 0 then
					data[1] = 2
					data[2] = string.char(math.ceil(-control_data * 255))
				elseif control_data == 0 then
					data[1] = 5
				end

				if data[2] ~= power then
					tcp_control_client:send(table.concat(data))
				end
				--print("1 = "..math.ceil(control_data * 256))
			end,
			left = function ()
				local data = {}
				data[1] = 3

				tcp_control_client:send(table.concat(data))
				--print("3")
			end,
			right = function ()
				local data = {}
				data[1] = 4

				tcp_control_client:send(table.concat(data))
				--print("4")
			end,
			stop = function ()
				local data = {}
				data[1] = 5

				tcp_control_client:send(table.concat(data))
				--print("5")
			end,
			stop_turn = function ()
				local data = {}
				data[1] = 6

				tcp_control_client:send(table.concat(data))
				--print("6")
			end,
			quit = function()
				tcp_control_client:close()
				stop = true
			end
		}
		-- TODO: serialized protocol
	}

	while not stop do
	
		app_cmd = app_ch:pop()
		
		--protocols[protocol.services.control.proto][app_cmd.cmd](app_cmd.data)
		if app_cmd ~= nil then protocols.raw[app_cmd.cmd](app_cmd.data) end

	end
else
	app_ch:push({connected=false, ["err"] = err or ""})
end
