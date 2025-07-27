
--// IMPORT LIBRARIES //--
Renderer = require("RenderScript")
Network = require("Network")
Assets = require("LoadAssets")
SoldierAssets = require("LoadSoldiers")
unitControl = require("UnitControl")
SpawnUnits = require("SpawnUnits")

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
visualEffects = {}
uiObjects = {}

enviroment = "European"

inGame = false
inMapEdit = false
enbaledPaintBrush = false
currentEditRender = "Edit"
finishedTiles = false

local netMsg = ""

Cards = {
    "LineInfantry",
    "LightInfantry",
    "Artillery",
    "Artillery",
    "Artillery",
    "Artillery"
}


camPos = {0,0}
zoom = 1
camSpeed = 1

nextMap = "TwinTowns.lvl"

prussianUnits={}
britishUnits={}
frenchUnits={}
enemyUnits = {}

selectedUnit = false
wheelSelected = false
moveSelected = false
movingUnits = {}

currentTeamUnitUpdates = {}
currentTeam = "French"
enemyTeam = "Prussian"
unitsPlaced = 0
plr1ReadyForBattle = false

gameResolution = {1200,700}
fullscreenBool = true
mousePos = {0,0}

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
function clearControls()
    wheelSelected = false
    moveSelected = false
    local i=1
    while i<#uiObjects do
        if uiObjects[i].Name=="controlinfo" then
            table.remove(uiObjects,i)
        end
        if (uiObjects[i].Name=="MarchingColumnBtn") then
            table.remove(uiObjects,i)
        end
        if (uiObjects[i].Name=="BattleLineBtn") then
            table.remove(uiObjects,i)
        end
        if (uiObjects[i].Name=="SkirmishLineBtn") then
            table.remove(uiObjects,i)
        end

        i=i+1
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

        for i=1,#prussianUnits,1 do
            prussianUnits[i]:DrawUnit(zoom,camPos)
        end
        for i=1,#frenchUnits,1 do
            frenchUnits[i]:DrawUnit(zoom,camPos)
        end
    end

    local temp = renderer.RenderEffects(visualEffects,zoom,camPos)
    visualEffects = temp

    if not (inMapEdit and (currentEditRender == "Edit")) then
        renderer.RenderDetails(currentMapDetails,"Temperate",zoom)
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
            if zoom<2.5 then
                zoom=zoom*1.5
            end
        end
        if key=="down" then
            if zoom>0.3 then
                zoom=zoom/1.5
            end
        end
    end

    if inGame then
        if not (not selectedUnit) then
            if key=="e" then --WHEEL--
                clearControls()
                local info = interface.New("controlinfo",{0,0,0,0},"Wheel Unit",{0,0,0,1},1,{0,0,0,0},{15,15},{300,300},"")
                table.insert(uiObjects,info)
                wheelSelected = true
            end
            if key=="q" then --MARCH--
                clearControls()
                local info = interface.New("controlinfo",{0,0,0,0},"Move Unit",{0,0,0,1},1,{0,0,0,0},{15,15},{300,300},"")
                table.insert(uiObjects,info)
                moveSelected = true
            end
            if key=="f" then --FORMATION CHANGE--
                clearControls()
                local info = unitControl.ChangeFormationOptions()
                for i=1,#info,1 do table.insert(uiObjects,info[i]) end
            end
            if key=="x" then --DESELECT--
                clearControls()
                selectedUnit.Selected = false
                selectedUnit = false
            end
        end
    end
end


connectionEstablished = false

mouseDeBounce = false

local marchStep = 1

fourSec = 0
twoSec = 0
oneSec = 0
halfSec = 0
quarterSec = 0
eighthSec = 0
netTick = 0
ambienceTick = 320
local initUpdate = true
fourSecondTimer = false

local test = true

function love.update(dt)
    if fourSecondTimer then fourSec = fourSec + dt end
    twoSec = twoSec + dt
    oneSec = oneSec + dt
    halfSec = halfSec + dt
    quarterSec = quarterSec + dt
    eighthSec = eighthSec + dt
    netTick=netTick+dt
    if plr1ReadyForBattle then ambienceTick=ambienceTick+dt end



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

                --from practise play--
                love.window.setMode(gameResolution[1],gameResolution[2])
                success = love.window.setFullscreen(fullscreenBool)
                clearInterface()
                inGame = true
                local loadedMap = MapEditor.LoadMap(nextMap)
                currentMap = loadedMap[1]
                currentMapDetails = loadedMap[2]
            elseif events[1] == "disconnected" then
                print("A Peer Has Disconnected")
                connectionEstablished = false
            elseif events[1] == "received" then
                local receivedMsg = events[2]
                local decodedMsg = Network.DecodeMessage(receivedMsg)
                local units = decodedMsg.units
                local updates = decodedMsg.updates
                local moves = decodedMsg.moves

                if enemyTeam=="Prussian" then tempTeam = prussianUnits end
                if enemyTeam=="French" then tempTeam = frenchUnits end

                local update = Network.ApplyUpdate(units,updates,moves,tempTeam,movingUnits)
                if not (updates[2]==nil) then movingUnits = updates[2] end
                if not (updates[1]==nil) then
                    if enemyTeam=="Prussian" then prussianUnits = update[1] end
                    if enemyTeam=="French" then frenchUnits = update[1] end
                end
            end
        end
    end

    --Timers--
    if (fourSecondTimer) and (fourSec >= 4) then
        fourSecondTimer = false
        fourSec = 0
    end

    --Clocks--
    if ambienceTick >= 325 then
        ambienceTick=ambienceTick-325
        if enviroment=="European" then
            assets.OtherSounds[1][2]:play()
        else
            assets.OtherSounds[2][2]:play()
        end
    end

    if netTick >= 1 then
        netTick = netTick - 1
        if Network.Hosting then
            local currentUnits = {}
            if currentTeam=="Prussian" then currentUnits=prussianUnits end
            if currentTeam=="French" then currentUnits=frenchUnits end

            local netmsg = Network.CreateMessage(currentUnits,currentTeamUnitUpdates,movingUnits,currentTeam)
            Network.SendMessage(netmsg)
            currentTeamUnitUpdates={}
        end
    end

    if oneSec >= 1 then
        oneSec = oneSec - 1 
        if Network.Hosting then
        end

        local index = 0
        while index<#prussianUnits do
            index=index+1
            if prussianUnits[index].IsDead then 
                if currentTeam=="Prussian" then
                    table.insert(currentTeamUnitUpdates,"Dead:"..prussianUnits[index].Name)
                end
                print("Removed: "..tostring(prussianUnits[index].Name))
                table.remove(prussianUnits,index)
            end
        end
        index = 0
        while index<#frenchUnits do
            index=index+1
            if frenchUnits[index].IsDead then 
                if currentTeam=="French" then
                    table.insert(currentTeamUnitUpdates,"Dead:"..frenchUnits[index].Name)
                end
                print("Removed: "..tostring(frenchUnits[index].Name))
                table.remove(frenchUnits,index)
            end
        end


        for i=1,#prussianUnits,1 do
            if (prussianUnits[i].Stance=="Idle")or(prussianUnits[i].Stance=="Aiming") then
                if not prussianUnits[i].CurrentTarget then
                    local newWheel = prussianUnits[i]:CheckForTargets(frenchUnits,currentTeam)
                    if not (not newWheel) then table.insert(movingUnits,newWheel) end
                else
                    prussianUnits[i]:CheckForTargets(frenchUnits,currentTeam)
                end
            end
        end
        for i=1,#frenchUnits,1 do
            if (frenchUnits[i].Stance=="Idle")or(frenchUnits[i].Stance=="Aiming") then
                if not frenchUnits[i].CurrentTarget then
                    local newWheel = frenchUnits[i]:CheckForTargets(prussianUnits,currentTeam)
                    if not (not newWheel) then table.insert(movingUnits,newWheel) end
                else
                    frenchUnits[i]:CheckForTargets(prussianUnits,currentTeam)
                end
            end
        end
    end
    if halfSec >= 0.5 then
        for i=1,#Assets.MarchSounds,1 do
            Assets.MarchSounds[i][3] = false
        end

        halfSec = halfSec - 0.5 
        if marchStep==1 then marchStep=2 else marchStep=1 end

        for i=1,#movingUnits,1 do
            local index = movingUnits[i][3]
            if movingUnits[i][4][index][1]=="Move" then--MOVE UNITS--
                movingUnits[i][1]:PlayMarchingSounds(camPos,gameResolution,currentMap)
                movingUnits[i][1].Stance = "Marching"..tostring(marchStep)
                movingUnits[i][1].Position=movingUnits[i][4][index][2]
                movingUnits[i][3]=movingUnits[i][3]+1
                if movingUnits[i][3]>#movingUnits[i][4] then 
                    if not (not movingUnits[i][1].CurrentTarget) then movingUnits[i][1].Stance="Aiming"
                    else movingUnits[i][1].Stance="Idle" end
                    table.remove(movingUnits,i) 
                    break 
                end
            end
        end
    end

    if  quarterSec >= 0.25 then
        quarterSec = quarterSec - 0.25
        
        for i=1,#movingUnits,1 do
            local index = movingUnits[i][3]
            if movingUnits[i][4][index][1]=="Wheel" then--WHEEL UNITS--
                movingUnits[i][1].Stance = "Marching"..tostring(marchStep)
                movingUnits[i][1]:ChangeOrientation(movingUnits[i][4][index][2])
                movingUnits[i][3]=movingUnits[i][3]+1
                if movingUnits[i][3]>#movingUnits[i][4] then 
                    if not (not movingUnits[i][1].CurrentTarget) then movingUnits[i][1].Stance="Aiming"
                    else movingUnits[i][1].Stance="Idle" end
                    table.remove(movingUnits,i) 
                    break 
                end
            end
        end
    end


    if eighthSec >= 0.125 then
        eighthSec = eighthSec - 0.125


        for i=1,#prussianUnits,1 do
            if not (not prussianUnits[i].CurrentTarget) then
                if type(prussianUnits[i].FireRate)=="number" then
                    if math.random(1,prussianUnits[i].FireRate)==1 then
                        local fx = prussianUnits[i]:Fire(camPos,gameResolution,currentTeam,zoom,currentMap)
                        if not (not fx[1]) then
                            table.insert(visualEffects,fx[1])
                            table.insert(visualEffects,fx[3])
                            if not (fx[2]=="") then table.insert(visualEffects,fx[2]) end
                            if not (type(fx[4])=="boolean") then
                                for i=1,#movingUnits,1 do
                                    if not type(prussianUnits[i].CurrentTarget=="boolean") then
                                        if movingUnits[i][1].Name==prussianUnits[i].CurrentTarget.Name then
                                            print("Remove Existing Moves")
                                            table.remove(movingUnits,i)
                                            break
                                        end
                                    end
                                end
                                print("Add retreat to moves")
                                table.insert(movingUnits,fx[4])
                            end
                        end
                    end
                end
            end
        end

        for i=1,#frenchUnits,1 do
            if not (not frenchUnits[i].CurrentTarget) then
                if type(frenchUnits[i].FireRate)=="number" then
                    if math.random(1,frenchUnits[i].FireRate)==1 then
                        local fx = frenchUnits[i]:Fire(camPos,gameResolution,currentTeam,zoom,currentMap)
                        if not (not fx[1]) then
                            table.insert(visualEffects,fx[1])
                            table.insert(visualEffects,fx[3])
                            if not (fx[2]=="") then table.insert(visualEffects,fx[2]) end
                            if not (type(fx[4])=="boolean") then
                                for i=1,#movingUnits,1 do
                                    print("Looping thru moveunits")
                                    if not type(frenchUnits[i].CurrentTarget=="boolean") then
                                        if movingUnits[i][1].Name==frenchUnits[i].CurrentTarget.Name then
                                            print("Remove Existing Moves")
                                            table.remove(movingUnits,i)
                                            break
                                        end
                                    end
                                end
                                print("Add retreat to moves")
                                table.insert(movingUnits,fx[4])
                            end
                        end
                    end
                end
            end
        end
    end

    --Inputs--
    if (love.mouse.isDown(1)) and (not mouseDeBounce) then
        mouseDeBounce = true
        local x,y = love.mouse.getPosition()
        mousePos = {x,y}

        local clickedUI = false

        if not (#uiObjects==0) then
            for i=1,#uiObjects,1 do
                if not (not uiObjects[i]:CheckClick(mousePos)) then
                    local check = uiObjects[i]:CheckClick(mousePos)

                    if check=="Open Map Editor" then
                        success = love.window.setFullscreen(fullscreenBool)
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
                        Network.ConnectToHost(lastTextInput)

                        --from practise play--
                        success = love.window.setFullscreen(fullscreenBool)
                        clearInterface()
                        inGame = true
                        local loadedMap = MapEditor.LoadMap(nextMap)
                        currentMap = loadedMap[1]
                        currentMapDetails = loadedMap[2]

                        currentTeam="Prussian"
                        enemyTeam="French"
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
                        MapEditor.CompileMap("ForestBattle1")
                    end

                    if check=="Practice Play" then
                        success = love.window.setFullscreen(fullscreenBool)
                        clearInterface()
                        inGame = true
                        local loadedMap = MapEditor.LoadMap(nextMap)
                        currentMap = loadedMap[1]
                        currentMapDetails = loadedMap[2]

                        currentTeam = "Prussian"
                        enemyTeam = "French"

                        for i=1,#Cards,1 do
                            newUnit = SpawnUnits.CreateUnit("French"..Cards[i],"French",{1000+(400*i),3500})
                            table.insert(frenchUnits,newUnit)
                        end 

                        break
                    end

                    if check=="Form_March" then
                        selectedUnit.Formation="MarchingColumn"
                        selectedUnit.OpenOrder = "_Squad"
                    elseif check=="Form_Battle" then
                        selectedUnit.Formation="BattleLine"
                        selectedUnit.OpenOrder = "_Squad"
                    elseif check=="Form_Skirmish" then
                        selectedUnit.Formation="SkirmishLine"
                        selectedUnit.OpenOrder = ""
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

        if inGame and (not clickedUI) then
            local newTable = {}
            if currentTeam=="Prussian" then newTable = prussianUnits end
            if currentTeam=="French" then newTable = frenchUnits end

            if (not wheelSelected)or(not moveSelected) then
                for i=1,#newTable,1 do--SELECT UNIT--
                    local selected = newTable[i]:CheckClick(mousePos,camPos,zoom)
                    if selected[1] then
                        for i2=1,#newTable,1 do
                            newTable[i2].Selected = false
                        end
                        selectedUnit = selected[3]
                        selected[3].Selected = selected[2]
                        break
                    end
                end
            end

            if not (not selectedUnit) then--UNIT CONTROLS--
                if wheelSelected then--WHEEL UNIT--
                    local newWheel = unitControl.CalculateWheel(selectedUnit,mousePos,camPos,zoom)
                    if not (not newWheel) then
                        for i=1,#movingUnits,1 do
                            if movingUnits[i][1].Name==selectedUnit.Name then
                                table.remove(movingUnits,i)
                                break
                            end
                        end
                        table.insert(movingUnits,newWheel)
                    end
                end

                if moveSelected then--MOVE UNIT--
                    if selectedUnit.Formation=="MarchingColumn" then
                        local mgx = math.ceil((((mousePos[1])/zoom)+camPos[1])/200)
                        local mgy = math.ceil((((mousePos[2])/zoom)+camPos[2])/200)
                        local newMarch = unitControl.CalculateMove(selectedUnit,mousePos,camPos,zoom,currentMap)
                        if not (not newMarch) then
                            for i=1,#movingUnits,1 do
                                if movingUnits[i][1].Name==selectedUnit.Name then
                                    table.remove(movingUnits,i)
                                    break
                                end
                            end
                            selectedUnit.Retreating = false
                            table.insert(movingUnits,newMarch)
                        end
                    else
                        local newMarch = unitControl.CalculateMove(selectedUnit,mousePos,camPos,zoom,currentMap)
                        if not (not newMarch) then
                            for i=1,#movingUnits,1 do
                                if movingUnits[i][1].Name==selectedUnit.Name then
                                    table.remove(movingUnits,i)
                                    break
                                end
                            end
                            selectedUnit.Retreating = false
                            table.insert(movingUnits,newMarch)
                        end
                    end
                end
            end
        end 

        if inGame and (unitsPlaced<#Cards) then
            local mgx = math.ceil((((mousePos[1])/zoom)+camPos[1])/200)
            local mgy = math.ceil((((mousePos[2])/zoom)+camPos[2])/200)
            local mx = math.ceil((((mousePos[1])/zoom)+camPos[1]))
            local my = math.ceil((((mousePos[2])/zoom)+camPos[2]))

            if (currentTeam=="Prussian")and(currentMapDetails[mgy][mgx]=="SPNA") then
                unitsPlaced=unitsPlaced+1
                newUnit = SpawnUnits.CreateUnit(currentTeam..Cards[unitsPlaced],currentTeam,{mx,my})
                table.insert(prussianUnits,newUnit)
                table.insert(currentTeamUnitUpdates,{"Spawned:",newUnit})
            elseif (currentTeam=="French")and(currentMapDetails[mgy][mgx]=="SPNB") then             
                unitsPlaced=unitsPlaced+1
                newUnit = SpawnUnits.CreateUnit(currentTeam..Cards[unitsPlaced],currentTeam,{mx,my})
                table.insert(frenchUnits,newUnit)
                table.insert(currentTeamUnitUpdates,{"Spawned:",newUnit})
            end
            if unitsPlaced==#Cards then
                plr1ReadyForBattle = true
                for y=1,#currentMapDetails,1 do
                    for x=1,#currentMapDetails[1],1 do
                        if currentMapDetails[y][x]=="SPNA" then
                            currentMapDetails[y][x]=""
                        elseif currentMapDetails[y][x]=="SPNB" then
                            currentMapDetails[y][x]=""
                        end
                    end
                end
            end
            
        end


    elseif not (love.mouse.isDown(1)) then
        mouseDeBounce = false
    end

    if inMapEdit or inGame then
        if love.keyboard.isDown("w") then
            if camPos[2]>0 then
                camPos[2]=camPos[2]-(9*camSpeed)
            end
        end
        if love.keyboard.isDown("a") then
            if camPos[1]>0 then
                camPos[1]=camPos[1]-(9*camSpeed)
            end
        end
        if love.keyboard.isDown("s") then
            if (camPos[2]*zoom)+(gameResolution[2])<((#currentMap)*200)*(zoom) then
                camPos[2]=camPos[2]+(9*camSpeed)
            end
        end
        if love.keyboard.isDown("d") then
            if (camPos[1]*zoom)+(gameResolution[1])<((#currentMap[1])*200)*(zoom) then
                camPos[1]=camPos[1]+(9*camSpeed)
            end
        end
        if love.keyboard.isDown("lshift") then
            camSpeed=5
        else
            camSpeed=1
        end
    end
end