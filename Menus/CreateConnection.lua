
connectionMenu = {}

uiClass = require("../Interface")


function connectionMenu.OpenMenu()
    local newUI = {}
    love.window.setMode(600, 450)
    love.graphics.setBackgroundColor(0,0,0.15,1)
    local connectBtn = uiClass.New("ConnectBtn",{0.95,0.95,0.95,1},"Connect To A Peer",{0,0,0,1},6,{0.05,0.05,1,1},{50,50},{400,175},"Connect To Peer")
    newUI = {connectBtn}
    return newUI
end

return connectionMenu