
--// IMPORT LIBRARIES //--
Renderer = require("RenderScript.lua")

--// SET UP CLASSES //--
Interface = require("Interface.lua")

--// GAME VARIABLES //--
uiObjects = {}
zoom = 1

--// LOVE FUNCTIONS //--
function love.load()
    uiTest1 = Interface.New("UI1","img",{0.2,0.2,1,1},"txt","txtclr",5,{1,1,1,1},{25,25},{80,80})
    table.insert(uiObjects,uiTest1)
end

function love.draw()
    Renderer:RenderUI(uiObjects,zoom)
end


oneSec = 0
halfSec = 0
function love.update(dt)
    oneSec = oneSec + dt
    halfSec = halfSec + dt

    --Timers--
    if oneSec >= 1 then
        oneSec = oneSec - 1 
    end
    if halfSec >= 0.5 then
        halfSec = halfSec - 0.5 
    end
end