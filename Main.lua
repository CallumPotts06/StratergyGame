
--// IMPORT LIBRARIES //--
Renderer = require("RenderScript")
Network = require("Network")
Assets = require("LoadAssets")
SoldierAssets = require("LoadSoldiers")

--// GAME MENUS //--
MainMenu = require("Menus/MainMenu")
ConnectionMenu = require("Menus/CreateConnection")
MapEditor = require("Menus/MapEditorEnviroment")

--// SET UP CLASSES //--
Interface = require("Interface")
Unit = require("Unit")

--// GAME VARIABLES //--
currentMap = {}
currentMapDetails = {}

uiObjects = {}

inGame = false
inMapEdit = false
enbaledPaintBrush = false
currentEditRender = "Edit"
finishedTiles = false

camPos = {0,0}
zoom = 1
camSpeed = 1

nextMap = "map_1.lvl"

germanUnits={}
britishUnits={}
frenchUnits={}

gameResolution = {854,480}

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
function openMenu(menu,specialCondition)
    if specialCondition=="FinishTiles" then
        local newUI=menu.FinishTiles()
        for i=1,#newUI,1 do table.insert(uiObjects,newUI[i]) end
    else
        if not (menu==MapEditor) then
            local newUI = menu.OpenMenu()
            for i=1,#newUI,1 do table.insert(uiObjects,newUI[i]) end
        else
            local openedMenu = menu.OpenMenu()
            local newUI = openedMenu[1]
            currentMap = openedMenu[2]
            for i=1,#newUI,1 do table.insert(uiObjects,newUI[i]) end
        end
    end
end

--// LOVE FUNCTIONS //--
function love.load()
end

function love.draw()
    if inMapEdit and (currentEditRender == "Edit") then
        Renderer.RenderMap(currentMap,currentMapDetails,"Editor",zoom)
    else
        Renderer.RenderMap(currentMap,currentMapDetails,"Temperate",zoom)

        for i=1,#germanUnits,1 do
            germanUnits[i]:DrawUnit(zoom,camPos)
        end
    end

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

    if inMapEdit or inGame then
        if key=="up" then
            if zoom<1.3 then
                zoom=zoom*1.5
            end
        end
        if key=="down" then
            if zoom>0.3 then
                zoom=zoom/1.5
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

        local clickedUI = false

        if not (#uiObjects==0) then
            for i=1,#uiObjects,1 do
                if not (not uiObjects[i]:CheckClick(mousePos)) then
                    local check = uiObjects[i]:CheckClick(mousePos)

                    if check=="Open Map Editor" then
                        clearInterface()
                        openMenu(MapEditor)
                        inMapEdit = true
                        break

                    elseif check=="Open Network Connector" then
                        clearInterface()
                        openMenu(ConnectionMenu)
                        break

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

                    if check=="Change Brush" then
                        clickedUI = true
                        local index = 1
                        for x=1,#Assets.Map_Editor_ID,1 do
                            if Assets.Map_Editor_ID[x][1]==string.sub(uiObjects[i].Text,8,#uiObjects[i].Text) then
                                index = x+1
                                break
                            end
                        end
                        if index>#Assets.Map_Editor_ID then index=1 end 
                        MapEditor.CurrentBrush=Assets.Map_Editor_ID[index][2]
                        local newBrush = "Brush: "..Assets.Map_Editor_ID[index][1]
                        local newImg = Assets.Map_Editor[index][2]
                        uiObjects[i].Text=newBrush
                        uiObjects[i].Image=newImg
                    end

                    if check=="Change Render" then
                        if currentEditRender == "Edit" then
                            currentEditRender = "Normal"
                            local convert = MapEditor.ConvertMap("Game")
                            currentMap = convert[1]
                            currentMapDetails = convert[2]
                            clickedUI = true
                            enbaledPaintBrush = true
                            break
                        else
                            clickedUI = true
                            currentEditRender = "Edit"
                            convert = MapEditor.ConvertMap("Edit")
                            currentMap = convert[1]
                            break
                        end
                    end
                    if check=="Enable Brush" then
                        clickedUI = true
                        enbaledPaintBrush = false
                        uiObjects[i].Text = "Brush Disabled"
                        uiObjects[i].OnClick = "Disable Brush"
                        break
                    elseif check=="Disable Brush" then
                        clickedUI = true
                        enbaledPaintBrush = true
                        uiObjects[i].Text = "Brush Enabled"
                        uiObjects[i].OnClick = "Enable Brush"
                        break
                    end 

                    if check=="Finish Tiles" then   
                        clearInterface()
                        openMenu(MapEditor,"FinishTiles")
                        currentEditRender = "Normal"
                        clickedUI = true
                        enbaledPaintBrush = false
                        finishedTiles = true
                        local convert = MapEditor.ConvertMap("Game")
                        currentMap = convert[1]
                        currentMapDetails = convert[2]
                        break
                    end
                    if check=="Enable Detail" then
                        clickedUI = true
                        enbaledPaintBrush = false
                        uiObjects[i].Text = "Brush Disabled"
                        uiObjects[i].OnClick = "Disable Detail"
                        break
                    elseif check=="Disable Detail" then
                        clickedUI = true
                        enbaledPaintBrush = true
                        uiObjects[i].Text = "Brush Enabled"
                        uiObjects[i].OnClick = "Enable Detail"
                        break
                    end

                    if check=="Change Detail" then
                        clickedUI = true
                        local index = 1
                        for x=1,#Assets.Map_Editor_Detail_ID,1 do
                            if Assets.Map_Editor_Detail_ID[x][1]==string.sub(uiObjects[i].Text,8,#uiObjects[i].Text) then
                                index = x+1
                                break
                            end
                        end
                        if index>#Assets.Map_Editor_Detail_ID then index=1 end 
                        MapEditor.CurrentBrush=Assets.Map_Editor_Detail_ID[index][2]
                        local newBrush = "Brush: "..Assets.Map_Editor_Detail_ID[index][1]
                        local newImg = Assets.Map_Details_Editor[index][2]
                        uiObjects[i].Text=newBrush
                        uiObjects[i].Image=newImg
                    end

                    if check=="Finish Map" then
                        clickedUI = true
                        clearInterface()
                        inGame = false
                        inMapEdit = false
                        MapEditor.CompileMap("map_1")
                    end

                    if check=="Practice Play" then
                        clearInterface()
                        inGame = true
                        local loadedMap = MapEditor.LoadMap(nextMap)
                        currentMap = loadedMap[1]
                        currentMapDetails = loadedMap[2]

                        local german1 = Unit.New("GermanInfantry1","LineInfantry","German",SoldierAssets.GermanLineInfantry,{2,6},100)
                        local german2 = Unit.New("GermanInfantry2","LineInfantry","German",SoldierAssets.GermanLineInfantry,{3,6},100)
                        germanUnits={german1,german2}
                        break
                    end
                end
            end
        end
        if inMapEdit and (not clickedUI)then
            if enbaledPaintBrush and (not finishedTiles) then
                local mouseGridPosX = math.ceil((((mousePos[1])/zoom)+camPos[1])/200)
                local mouseGridPosY = math.ceil((((mousePos[2])/zoom)+camPos[2])/200)
                currentMap[mouseGridPosY][mouseGridPosX]=MapEditor.CurrentBrush     
            end
            if enbaledPaintBrush and finishedTiles then
                local mouseGridPosX = math.ceil((((mousePos[1])/zoom)+camPos[1])/200)
                local mouseGridPosY = math.ceil((((mousePos[2])/zoom)+camPos[2])/200)
                currentMapDetails[mouseGridPosY][mouseGridPosX]=MapEditor.CurrentBrush     
            end
        end 

    elseif not (love.mouse.isDown(1)) then
        mouseDeBounce = false
    end

    if inMapEdit or inGame then
        if love.keyboard.isDown("w") then
            if camPos[2]>0 then
                camPos[2]=camPos[2]-(5*camSpeed)
            end
        end
        if love.keyboard.isDown("a") then
            if camPos[1]>0 then
                camPos[1]=camPos[1]-(5*camSpeed)
            end
        end
        if love.keyboard.isDown("s") then
            if (camPos[2]*zoom)+(gameResolution[2])<((#currentMap)*200)*(zoom) then
                camPos[2]=camPos[2]+(5*camSpeed)
            end
        end
        if love.keyboard.isDown("d") then
            if (camPos[1]*zoom)+(gameResolution[1])<((#currentMap[1])*200)*(zoom) then
                camPos[1]=camPos[1]+(5*camSpeed)
            end
        end
        if love.keyboard.isDown("lshift") then
            camSpeed=4
        else
            camSpeed=1
        end
    end
end