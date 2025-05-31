
--// IMPORT LIBRARIES //--
Renderer = require("RenderScript")
ConnectionMenu = require("Menus/CreateConnection")

--// SET UP CLASSES //--
Interface = require("Interface")

--// GAME VARIABLES //--
uiObjects = {}
zoom = 1

--// OTHER VARIABLES //--
textInputEnabled = false
currentTextInputBox = false
currentTextInput = ""
finishedTextInput = false
lastTextInput = ""

--// LOVE FUNCTIONS //--
function love.load()
end

function love.draw()
    Renderer.RenderUI(uiObjects,zoom)
end

function love.keypressed(key)
    if textInputEnabled then
        if not((key=="backspace")or(key=="return")or(key=="space")or(key=="capslock")or(key=="lshift")) then
            currentTextInput = currentTextInput..key
        elseif (key == "backspace") then
            currentTextInput=""
        elseif (key == "return") then
            finishedTextInput = true
            lastTextInput = currentTextInput
            currentTextInput = ""
            textInputEnabled = false
        elseif (key == "space") then
            currentTextInput=currentTextInput.." "
        end
        for i=1,#uiObjects,1 do
            if uiObjects[i].Name==currentTextInputBox then
                uiObjects[i].Text = currentTextInput
                uiObjects[i].TextChange = true
                break
            end
        end
    end
end


mouseDeBounce = false
fourSec = 0
twoSec = 0
oneSec = 0
halfSec = 0
local initUpdate = true

fourSecondTimer = true

local test = true

function love.update(dt)
    if initUpdate then 
        initUpdate = false
    end

    if fourSecondTimer then fourSec = fourSec + dt end
    twoSec = twoSec + dt
    oneSec = oneSec + dt
    halfSec = halfSec + dt

    --Timers--
    if (fourSecondTimer) and (fourSec >= 4) then
        print("Four Second Timer Elapsed!")
        fourSecondTimer = false
        fourSec = 0
        
        local newUI = ConnectionMenu.OpenMenu()
        for i=1,#newUI,1 do table.insert(uiObjects,newUI[i]) end
    end
    if oneSec >= 1 then
        oneSec = oneSec - 1 
    end
    if halfSec >= 0.5 then
        halfSec = halfSec - 0.5 
    end

    --Inputs--
    if (love.mouse.isDown(1)) and (not mouseDeBounce) then
        mouseDeBounce = true
        local x,y = love.mouse.getPosition()
        local mousePos = {x,y}

        for i=1,#uiObjects,1 do
            if not (not uiObjects[i]:CheckClick(mousePos)) then
                --Network UI--
                if uiObjects[i]:CheckClick(mousePos)=="Start Host" then
                    print("Starting Host")
                    break
                elseif uiObjects[i]:CheckClick(mousePos)=="Connect To Peer" then
                    print("Connecting To A Peer")
                    break
                end
            end
        end
    elseif not (love.mouse.isDown(1)) then
        mouseDeBounce = false
    end
end