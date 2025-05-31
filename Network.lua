
Network = {}

enet = require("enet")
local host
local peer

function Network.StartHost(IP)
    print("IP: "..IP)
    host = enet.host_create(IP..":1870")
    return "sucess"
end

function Network.ConnectToHost(IP)
    host = enet.host_create()
    server = host:connect(IP..":1870")
    return "sucess"
end

function Network.InboundEvents()
    local event = host:service()--ms
    
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
    event.peer:send(msg)
end

return Network