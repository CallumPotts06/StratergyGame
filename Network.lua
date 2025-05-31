
Network = {}

enet = require("enet")
local host
local peer

function Network.StartHost(IP)
    print("IP: "..IP)
    --host = enet.host_create(IP..":6789")
    host = enet.host_create("localhost:6789")
    return "success"
end

function Network.ConnectToHost(IP)
    host = enet.host_create()
    server = host:connect(IP..":6789")
    return "success"
end

function Network.InboundEvents()
    local event = host:service(1000)--ms
    
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

function Network.SendMessage(msg)
    event = host:service(1000)
    peer = event.peer
    peer:send(msg)
end

return Network