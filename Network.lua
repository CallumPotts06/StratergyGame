
Network = {}

enet = require("enet")
local host
local peer
Network.Hosting = false

function Network.StartHost()
    Network.Hosting=true
    host = enet.host_create("0.0.0.0"..":1870")
    return "success"
end

function Network.ConnectToHost(IP)
    Network.Hosting=true
    host = enet.host_create()
    server = host:connect(IP..":1870")
    event = false
    while not event do
        event = host:service(200)
    end
    peer = event.peer
    return "success"
end

function Network.InboundEvents()
    local event = host:service()--ms
    
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
    event = host:service(10)
    if peer then
        peer:send(msg)
    end
end

return Network