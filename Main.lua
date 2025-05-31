
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
        if not ((key == "backspace") or (key == "return") or (key == "space")) then
            currentTextInput = currentTextInput..key
        elseif (key == "backspace") then
            currentTextInput=string.sub(currentTextInput,string.len(currentTextInput-1))
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

oneSec = 0
halfSec = 0
local initUpdate = true

function love.update(dt)
    if initUpdate then 
        initUpdate = false
        inputBox = Interface.New("InputBox1",{0.9,0.9,0.9,1},"",{0,0,0,1},5,{1,1,1,1},{100,100},{600,150})
        textInputEnabled = true
        currentTextInputBox = inputBox.Name
        table.insert(uiObjects,inputBox)
    end

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