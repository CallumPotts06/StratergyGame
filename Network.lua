
Network = {}

enet = require("enet")
local host
local peer
Network.Hosting = false

function Network.StartHost(IP)
    Network.Hosting=true
    print("IP: "..IP)
    host = enet.host_create("0.0.0.0"..":6789")
    --host = enet.host_create("localhost:6789")
    return "success"
end

function Network.ConnectToHost(IP)
    Network.Hosting=true
    host = enet.host_create()
    server = host:connect(IP..":6789")
    Network.SendMessage("Initial Check In")
    return "success"
end

function Network.InboundEvents()
    local event = host:service(1000)--ms
    
    if event then
        if event.type == "receive" then
            return {"received",event.data}
        elseif event.type == "connect" then
            peer = event.peer
            return {"connected",event.peer}
        elseif event.type == "disconnect" then
            peer = nil
            return {"disconnected",event.peer}
        end
    end
end

function Network.SendMessage(msg)
    event = host:service(1000)
    if event then
        peer = event.peer
        peer:send(msg)
    end
end

return Network