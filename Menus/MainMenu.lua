
mainMenu = {}

uiClass = require("../Interface")

function mainMenu.OpenMenu()
    local newUI = {}
    love.window.setMode(gameResolution[1],gameResolution[2])
    love.graphics.setBackgroundColor(0.15,0.15,0.15,1)
    local MapEditor = uiClass.New("MapBtn",{0.95,0.95,0.95,1},"Map Editor",{0,0,0,1},6,{1,1,1,1},{25,25},{400,175},"Open Map Editor")
    local PlayOnline = uiClass.New("PlayOnlineBtn",{0.95,0.95,0.95,1},"Play Online",{0,0,0,1},6,{1,1,1,1},{25,225},{400,175},"Open Network Connector")
    newUI = {MapEditor,PlayOnline}
    return newUI
end

return mainMenu