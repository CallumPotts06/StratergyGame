
--// IMPORT LIBRARIES //--
Renderer = require("RenderScript")
Network = require("Network")
Assets = require("LoadAssets")

--// GAME MENUS //--
MainMenu = require("Menus/MainMenu")
ConnectionMenu = require("Menus/CreateConnection")

--// SET UP CLASSES //--
Interface = require("Interface")

--// GAME VARIABLES //--
currentMap = {}

uiObjects = {}
zoom = 1

--// OTHER VARIABLES //--
textInputEnabled = false
currentTextInputBox = false
currentTextInput = ""
finishedTextInput = false
lastTextInput = ""

--// FUNCTIONS //--
function openInput(inputBox)
    currentTextInputBox=inputBox.Name
    finishedTextInput = false
    currentTextInput = ""
    textInputEnabled = true
end
function closeInput()
    finishedTextInput = true
    lastTextInput = currentTextInput
    currentTextInput = ""
    textInputEnabled = false
end
function clearInterface()
    uiObjects={}
    closeInput()
end
function openMenu(menu)
    local newUI = menu.OpenMenu()
    for i=1,#newUI,1 do table.insert(uiObjects,newUI[i]) end
end

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


connectionEstablished = false

mouseDeBounce = false

fourSec = 0
twoSec = 0
oneSec = 0
halfSec = 0
local initUpdate = true
fourSecondTimer = false

local test = true

function love.update(dt)
    if fourSecondTimer then fourSec = fourSec + dt end
    twoSec = twoSec + dt
    oneSec = oneSec + dt
    halfSec = halfSec + dt

    if (initUpdate) and (oneSec>=1) then 
        initUpdate = false
        openMenu(MainMenu)
    end

    if Network.Hosting then
        local events = Network.InboundEvents()
        if events then
            if events[1] == "connected" then
                print("A Peer Has Connected!")
                connectionEstablished = true
                uiObjects={}
                closeInput()
            elseif events[1] == "disconnected" then
                print("A Peer Has Disconnected")
                connectionEstablished = false
            elseif events[1] == "received" then
                print("Recieved: "..events[2])
            end
        end
    end

    --Timers--
    if (fourSecondTimer) and (fourSec >= 4) then
        print("Four Second Timer Elapsed!")
        fourSecondTimer = false
        fourSec = 0
    end

    --Clocks--
    if oneSec >= 1 then
        oneSec = oneSec - 1 
        if Network.Hosting then
            Network.SendMessage("Peer Check In")
        end
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
                local check = uiObjects[i]:CheckClick(mousePos)

                if check=="Open Map Editor" then

                elseif check=="Open Network Connector" then
                    clearInterface()
                    openMenu(CreateConnection)

                elseif check=="Connect To Peer" then
                    Network.StartHost()
                    print("Connecting To A Peer")
                    local ipPrompt = interface.New("tempMsg",{1,1,1,0},"Enter Your Friend's Ip Then Click The Box",{1,1,1,1},0,{1,1,1,0},{25,25},{400,175},"")
                    local ipInput = interface.New("tempInp",{0.95,0.95,0.95,1},"",{0,0,0,1},6,{0.05,0.05,1,1},{25,150},{400,175},"IP Input Connect")
                    uiObjects={ipPrompt,ipInput}
                    openInput(ipInput)
                    break
                elseif check=="IP Input Connect" then
                    uiObjects={}
                    closeInput()
                    --Network.ConnectToHost(lastTextInput)
                    break
                end
            end
        end
    elseif not (love.mouse.isDown(1)) then
        mouseDeBounce = false
    end
end