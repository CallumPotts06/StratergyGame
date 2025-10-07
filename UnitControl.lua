
unitControl = {}

assets = require("LoadAssets")
newUI = require("Interface")

function unitControl.CalculateWheel(unit,mousePos,camPos,zoom)

    local startRad = unit.Orientation
    local dRad = 0
    local theta = 0
    local radsPerSecond = 0.2

    local unitX=unit.Position[1]
    local unitY=unit.Position[2]

    local x1=0
    local x2=0
    local y1=0
    local y2=0

    if mousePos=="Aiming" then
        x1 = (unitX)
        y1 = (unitY)
        x2 = (unit.CurrentTarget.Position[1])
        y2 = (unit.CurrentTarget.Position[2])
    else
        x1 = (unitX)
        y1 = (unitY)
        x2 = ((mousePos[1]/zoom)+(camPos[1]))
        y2 = ((mousePos[2]/zoom)+(camPos[2]))
    end

    local dx = (x2-x1)
    local dy = -(y2-y1)

    local hyp = math.sqrt((dx*dx)+(dy*dy))
    local adj = dx
    local opp = dy

    --ASTC RULE--
    if (dx>=0)and(dy>=0) then theta = math.atan(adj/opp) end
    if (dx<=0)and(dy>=0) then theta = ((3/2)*(math.pi))+math.asin(opp/hyp) end
    if (dx<=0)and(dy<=0) then theta = ((math.pi))+math.atan(adj/opp) end
    if (dx>=0)and(dy<=0) then theta = ((1/2)*(math.pi))+math.acos(adj/hyp) end

    radsPerSecond = 0.1

    local tempTables={{"INF"},{"INF"},{"INF"},{"INF"}}
    local newTable = {unit,"Wheel",1,{}}

    local theta2 = theta-(2*math.pi)
    local index=1
    local shortest = 1

    for i = startRad,theta,radsPerSecond do
        if index==1 then tempTables[1][1]={"Wheel",radsPerSecond} index=index+1 shortest=1
        else table.insert(tempTables[1],{"Wheel",radsPerSecond}) end
    end
    index=1
    for i = theta2,startRad,radsPerSecond do
        if index==1 then tempTables[2][1]={"Wheel",radsPerSecond} index=index+1 shortest=2
        else table.insert(tempTables[2],{"Wheel",radsPerSecond}) end
    end
    index=1
    for i = startRad,theta,-radsPerSecond do
        if index==1 then tempTables[3][1]={"Wheel",-radsPerSecond} index=index+1 shortest=3
        else table.insert(tempTables[3],{"Wheel",-radsPerSecond}) end
    end
    index=1
    for i = theta2,startRad,-radsPerSecond do
        if index==1 then tempTables[4][1]={"Wheel",-radsPerSecond} index=index+1 shortest=4
        else table.insert(tempTables[4],{"Wheel",-radsPerSecond}) end
    end
    
    
    for i=1,#tempTables,1 do 
        if (#tempTables[i]<#tempTables[shortest])and(not(tempTables[i][1]=="INF")) then shortest=i end
    end
    newTable[4]=tempTables[shortest]
    if tempTables[shortest][1]=="INF" then return false end

    return newTable
end

function unitControl.CalculateMove(unit,mousePos,camPos,zoom,mapTiles)
    local unitSpeeds = {
        {"LineInfantry",1},
        {"LightInfantry",1.2},
        {"Artillery",0.6},
    }

    local MarchingColumnSpeeds = {
        {"GRS",1.5},
        {"FRD",0.6},
        {"FST",0.4},
        {"BRD",1.7},
        {"ROD",2.2},
        {"STR",0.35},
        {"SWP",0.3},
        {"TRP",1.75},
        {"URB",0.05},
        {"CRN",0.35},
        {"WHE",0.35},
    }

    local BattleLineSpeeds = {
        {"GRS",1},
        {"FRD",0.5},
        {"FST",0.5},
        {"BRD",1.3},
        {"ROD",1.3},
        {"STR",0.1},
        {"SWP",0.2},
        {"TRP",1.175},
        {"URB",0.1},
        {"CRN",0.4},
        {"WHE",0.4},
    }

    local SkirmishLineSpeeds = {
        {"GRS",0.9},
        {"FRD",0.8},
        {"FST",0.9},
        {"BRD",0.9},
        {"ROD",0.9},
        {"STR",0.6},
        {"SWP",0.6},
        {"TRP",0.9},
        {"URB",0.1},
        {"CRN",0.8},
        {"WHE",0.8},
    }

    local newTable = unitControl.CalculateWheel(unit,mousePos,camPos,zoom)

    local unitX=unit.Position[1]
    local unitY=unit.Position[2]

    local x1 = (unitX)
    local y1 = (unitY)
    local x2 = ((mousePos[1]/zoom)+(camPos[1]))
    local y2 = ((mousePos[2]/zoom)+(camPos[2]))
    

    local dx = (x2-x1)
    local dy = -(y2-y1)

    local hyp = math.sqrt((dx*dx)+(dy*dy))
    local adj = dx
    local opp = dy

    --ASTC RULE--
    if (dx>=0)and(dy>=0) then theta = math.asin(opp/hyp) end
    if (dx<=0)and(dy>=0) then theta = math.asin(opp/hyp) end
    if (dx<=0)and(dy<=0) then theta = math.atan(opp/adj) end
    if (dx>=0)and(dy<=0) then theta = math.acos(adj/hyp) end

    theta = math.atan(opp/adj)
    local movementSpeed = 15
    for i=1,#unitSpeeds,1 do if unitSpeeds[i][1]==unit.Type then movementSpeed=movementSpeed*unitSpeeds[i][2] end end
    local xSpeed = math.cos(theta)*movementSpeed--CAH : ADJ = COS(TH) x HYP--
    local ySpeed = math.sin(theta)*movementSpeed--SOH : OPP = SIN(TH) x HYP--

    if unitX<x2 then xSpeed=math.abs(xSpeed) else xSpeed=-math.abs(xSpeed) end
    if unitY<y2 then ySpeed=math.abs(ySpeed) else ySpeed=-math.abs(ySpeed) end

    local movePos = {}

    local i=0
    local gainedX = unitX
    local gainedY = unitY
    if unitX<x2 then while gainedX<x2 do
        i=i+1
        local newSpeedX = xSpeed
        local newSpeedY = ySpeed

        local tileX = math.ceil((gainedX)/200)
        local tileY = math.ceil((gainedY)/200)
        if tileX<1 then tileX=1 end
        if tileX>#mapTiles[1] then tileX=#mapTiles[1] end
        if tileY<1 then tileY=1 end
        if tileY>#mapTiles then tileY=#mapTiles end
        local currentTile = mapTiles[tileY][tileX]

        local speedList = {}
        if unit.Formation=="BattleLine" then speedList=BattleLineSpeeds end
        if unit.Formation=="MarchingColumn" then speedList=MarchingColumnSpeeds end
        if unit.Formation=="SkirmishLine" then speedList=SkirmishLineSpeeds end
        for i=1,#speedList,1 do
            if speedList[i][1]==string.sub(currentTile,1,3) then
                newSpeedX=xSpeed*speedList[i][2]
                newSpeedY=ySpeed*speedList[i][2]
            end
        end

        gainedX=gainedX+(newSpeedX)
        gainedY=gainedY+(newSpeedY)
        local x = gainedX
        local y = gainedY
       

        table.insert(movePos,{x,y,currentTile})
    end else while x2<gainedX do
        i=i+1
        local newSpeedX = xSpeed
        local newSpeedY = ySpeed

        local tileX = math.ceil((gainedX)/200)
        local tileY = math.ceil((gainedY)/200)
        local currentTile = false
        if (tileY>0)and(tileY<#mapTiles)and(tileX>0)and(tileX<#mapTiles[1]) then
            currentTile = mapTiles[tileY][tileX]
        end

        if not (not currentTile) then
            local speedList = {}
            if unit.Formation=="BattleLine" then speedList=BattleLineSpeeds end
            if unit.Formation=="MarchingColumn" then speedList=MarchingColumnSpeeds end
            if unit.Formation=="SkirmishLine" then speedList=SkirmishLineSpeeds end
            for i=1,#speedList,1 do
                if speedList[i][1]==string.sub(currentTile,1,3) then
                    newSpeedX=xSpeed*speedList[i][2]
                    newSpeedY=ySpeed*speedList[i][2]
                end
            end

            gainedX=gainedX+(newSpeedX)
            gainedY=gainedY+(newSpeedY)
            local x = gainedX
            local y = gainedY

            table.insert(movePos,{x,y,currentTile})
        end
    end end

    for i=1,#movePos,1 do
        table.insert(newTable[4],{"Move",movePos[i]})
    end

    return newTable
end

function unitControl.ChangeFormationOptions()
    btn1=newUI.New("MarchingColumnBtn",{0.2,0.2,1,1},"Marching Column",{1,1,1,1},5,{1,1,1,1},{15,15},{100,100},"Form_March")
    btn2=newUI.New("BattleLineBtn",{0.2,0.2,1,1},"Battle Line",{1,1,1,1},5,{1,1,1,1},{130,15},{100,100},"Form_Battle")
    btn3=newUI.New("SkirmishLineBtn",{0.2,0.2,1,1},"Skirmish Line",{1,1,1,1},5,{1,1,1,1},{245,15},{100,100},"Form_Skirmish")

    return {btn1,btn2,btn3}
end

--[[function unitControl.Dijkstras(endPos,mapTiles,unit,mousePos,camPos,zoom)
    local terrain = {
        {"GRS",3},
        {"FRD",4},
        {"FST",4},
        {"BRD",3},
        {"ROD",3},
        {"STR",6},
        {"SWP",4},
        {"TRP",3},
        {"URB",15},
        {"CRN",5},
        {"WHE",5},
    }

    local lastTile = {math.ceil(unit.Position[1]/200),math.ceil(unit.Position[2]/200)}
    local endTile = {math.ceil(endPos[1]/200),math.ceil(endPos[2]/200)}

    local path = {}
    local graph = {}

    for y=1,#mapTiles,1 do
        table.insert(graph,{})
        for x=1,#mapTiles[1],1 do
            local newValue = {}
            local dx = math.abs((endTile[1]-x))
            local dy = math.abs((endTile[2]-y))
            local currentTerrain = 2 
            for i=1,#terrain,1 do if terrain[i][1]==string.sub(mapTiles[y][x],1,3)then currentTerrain=terrain[i][2]end end
            local heurisitic = dx+dy+currentTerrain
            local weight = currentTerrain
            table.insert(graph[y],{weight,heurisitic})
        end
    end

    local reachedDestination = false
    
    local visited = {{-1,-1}}

    local function isVisited(tile, visited)
        for i2=1,#visited do
            if tile[1] == visited[i2][1] and tile[2] == visited[i2][2] then
                return true
            end
        end
        return false
    end

    while not reachedDestination do

        local adjTiles = {}
        table.insert(adjTiles,{lastTile[1],lastTile[2]-1})--N--
        table.insert(adjTiles,{lastTile[1]+1,lastTile[2]-1})--NE--
        table.insert(adjTiles,{lastTile[1]+1,lastTile[2]})--E--
        table.insert(adjTiles,{lastTile[1]+1,lastTile[2]+1})--SE--
        table.insert(adjTiles,{lastTile[1],lastTile[2]+1})--S--
        table.insert(adjTiles,{lastTile[1]-1,lastTile[2]+1})--SW--
        table.insert(adjTiles,{lastTile[1]-1,lastTile[2]})--W--
        table.insert(adjTiles,{lastTile[1]-1,lastTile[2]-1})--NW--

        local shortest = {1,99999999999999999}
        local index=1
        for i=1,#adjTiles,1 do
            index=i
            if (adjTiles[i][2]<#mapTiles)and(adjTiles[i][2]>0) then
                if (adjTiles[i][1]<#mapTiles[1])and(adjTiles[i][1]>0) then
                    if graph[adjTiles[i][2]]--[adjTiles[i][1]][2]<shortest[2] then
                        --[[for i2=1,#visited,1 do
                            if not isVisited(adjTiles[i], visited) then
                                shortest = {index, graph[adjTiles[i][2]]--[adjTiles[i][1]][2]}
                            --[[end
                        end
                    end
                end
            end
        end

        lastTile = adjTiles[shortest[1]]
        --[[table.insert(path,adjTiles[shortest[1]]--)
        --[[table.insert(visited,{adjTiles[shortest[1]]--[1],adjTiles[shortest[1]][2]})
        --[[print("Path: ("..tostring(adjTiles[shortest[1]]--[1])..","..tostring(adjTiles[shortest[1]][2])..")")
        --if (adjTiles[shortest[1]][1]==endPos[1])and(adjTiles[shortest[1]][2]==endPos[2]) then
            --[[reachedDestination = true
        end
    end

    local fullTable = {}

    for i=1,#path,1 do
        if i==1 then
            local temptable = unitControl.CalculateMove(unit,mousePos,camPos,zoom,mapTiles)
            table.insert(fullTable,tempTable)
        else
            local temptable = unitControl.CalculateMove(unit,mousePos,camPos,zoom,mapTiles)
            for i=1,#temptable,1 do
                table.insert(fullTable[4],temptable[4])
            end
        end
    end 


    return fullTable
end]]

function unitControl.Dijkstras(endPos1,endPos2,mapTiles,unit,mousePos,camPos,zoom)
    local terrainCosts = {
        ["GRS"] = 3, ["FRD"] = 4, ["FST"] = 4, ["BRD"] = 3, ["ROD"] = 3, 
        ["STR"] = 6, ["SWP"] = 4, ["TRP"] = 3, ["URB"] = 15, ["CRN"] = 5, ["WHE"] = 5
    }

    local function heuristic(x1, y1, x2, y2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2) -- Euclidean distance
    end

    local function getTerrainCost(tileType)
        return terrainCosts[tileType] or 2
    end

    local function getTile(pos)
        return {math.floor(pos[1] / 200), math.floor(pos[2] / 200)}
    end

    local startTile = getTile(unit.Position)
    local endTile = {endPos1,endPos2}

    local openList = {}
    local closedList = {}
    local cameFrom = {}

    table.insert(openList, {x = startTile[1], y = startTile[2], g = 0, h = heuristic(startTile[1], startTile[2], endTile[1], endTile[2]), f = 0})

    while #openList > 0 do
        table.sort(openList, function(a, b) 
            if a.f == b.f then 
                return a.h < b.h -- Tie-breaker
            end
            return a.f < b.f 
        end)

        local current = table.remove(openList, 1)
        table.insert(closedList, {x = current.x, y = current.y})

        if current.x == endTile[1] and current.y == endTile[2] then
            local path = {}
            while cameFrom[current.x .. "," .. current.y] do
                table.insert(path, 1, {current.x, current.y})
                current = cameFrom[current.x .. "," .. current.y]
            end
            
            local fullTable = {}
            for i=1,#path,1 do
                if i==1 then
                    local temptable = unitControl.CalculateMove(unit,{path[i][1]*200,path[i][2]*200},{0,0},zoom,mapTiles)
                    table.insert(fullTable,tempTable)
                else
                    local temptable = unitControl.CalculateMove(unit,{path[i][1]*200,path[i][2]*200},{0,0},zoom,mapTiles)
                    if not(temptable==nil)then for i=1,#temptable,1 do
                        table.insert(fullTable[4],temptable[4])
                    end end
                end
            end 

            return fullTable
        end

        local directions = {{0,-1}, {1,-1}, {1,0}, {1,1}, {0,1}, {-1,1}, {-1,0}, {-1,-1}}

        for _, dir in ipairs(directions) do
            local nx, ny = current.x + dir[1], current.y + dir[2]
            local maxX, maxY = #mapTiles[1], #mapTiles
            if nx >= 1 and nx <= maxX and ny >= 1 and ny <= maxY then
                local terrainType = string.sub(mapTiles[ny][nx], 1, 3)
                local moveCost = getTerrainCost(terrainType)
                local newG = current.g + moveCost
                local newH = heuristic(nx, ny, endTile[1], endTile[2])
                local newF = (newG * 0.5) + newH

                local alreadyVisited = false
                for _, tile in ipairs(closedList) do
                    if tile.x == nx and tile.y == ny then
                        alreadyVisited = true
                        break
                    end
                end

                if not alreadyVisited then
                    local foundInOpen = false
                    for _, node in ipairs(openList) do
                        if node.x == nx and node.y == ny then
                            foundInOpen = true
                            if newG < node.g then
                                node.g = newG
                                node.f = newF
                                if not cameFrom[nx .. "," .. ny] or newG < cameFrom[nx .. "," .. ny].g then
                                    cameFrom[nx .. "," .. ny] = current
                                end
                            end
                            break
                        end
                    end

                    if not foundInOpen then
                        table.insert(openList, {x = nx, y = ny, g = newG, h = newH, f = newF})
                        if not cameFrom[nx .. "," .. ny] or newG < cameFrom[nx .. "," .. ny].g then
                            cameFrom[nx .. "," .. ny] = current
                        end
                    end
                end
            end
        end
    end

    return {} -- Return empty path if no solution found
end


function unitControl.CalculateCharge(unit,mousePos,camPos,zoom,mapTiles)
    local unitSpeeds = {
        {"LineInfantry",1.25},
        {"LightInfantry",1.1},
        {"Artillery",0.01},
    }
    local BattleLineSpeeds = {
        {"GRS",1.4},
        {"FRD",0.4},
        {"FST",0.4},
        {"BRD",1.2},
        {"ROD",1.5},
        {"STR",0.3},
        {"SWP",0.3},
        {"TRP",1.3},
        {"URB",0.2},
        {"CRN",0.6},
        {"WHE",0.6},
    }
    local newTable = unitControl.CalculateWheel(unit,mousePos,camPos,zoom)

    local unitX=unit.Position[1]
    local unitY=unit.Position[2]

    local x1 = (unitX)
    local y1 = (unitY)
    local x2 = ((mousePos[1]/zoom)+(camPos[1]))
    local y2 = ((mousePos[2]/zoom)+(camPos[2]))
    

    local dx = (x2-x1)
    local dy = -(y2-y1)

    local hyp = math.sqrt((dx*dx)+(dy*dy))
    local adj = dx
    local opp = dy

    --ASTC RULE--
    if (dx>=0)and(dy>=0) then theta = math.asin(opp/hyp) end
    if (dx<=0)and(dy>=0) then theta = math.asin(opp/hyp) end
    if (dx<=0)and(dy<=0) then theta = math.atan(opp/adj) end
    if (dx>=0)and(dy<=0) then theta = math.acos(adj/hyp) end

    theta = math.atan(opp/adj)
    local movementSpeed = 15
    for i=1,#unitSpeeds,1 do if unitSpeeds[i][1]==unit.Type then movementSpeed=movementSpeed*unitSpeeds[i][2] end end
    local xSpeed = math.cos(theta)*movementSpeed--CAH : ADJ = COS(TH) x HYP--
    local ySpeed = math.sin(theta)*movementSpeed--SOH : OPP = SIN(TH) x HYP--

    if unitX<x2 then xSpeed=math.abs(xSpeed) else xSpeed=-math.abs(xSpeed) end
    if unitY<y2 then ySpeed=math.abs(ySpeed) else ySpeed=-math.abs(ySpeed) end

    local movePos = {}

    local i=0
    local gainedX = unitX
    local gainedY = unitY
    if unitX<x2 then while gainedX<x2 do
        i=i+1
        local newSpeedX = xSpeed
        local newSpeedY = ySpeed

        local tileX = math.ceil((gainedX)/200)
        local tileY = math.ceil((gainedY)/200)
        if tileX<1 then tileX=1 end
        if tileX>#mapTiles[1] then tileX=#mapTiles[1] end
        if tileY<1 then tileY=1 end
        if tileY>#mapTiles then tileY=#mapTiles end
        local currentTile = mapTiles[tileY][tileX]

        local speedList = {}
        if unit.Formation=="BattleLine" then speedList=BattleLineSpeeds end
        if unit.Formation=="MarchingColumn" then speedList=MarchingColumnSpeeds end
        if unit.Formation=="SkirmishLine" then speedList=SkirmishLineSpeeds end
        for i=1,#speedList,1 do
            if speedList[i][1]==string.sub(currentTile,1,3) then
                newSpeedX=xSpeed*speedList[i][2]
                newSpeedY=ySpeed*speedList[i][2]
            end
        end

        gainedX=gainedX+(newSpeedX)
        gainedY=gainedY+(newSpeedY)
        local x = gainedX
        local y = gainedY
       

        table.insert(movePos,{x,y,currentTile})
    end else while x2<gainedX do
        i=i+1
        local newSpeedX = xSpeed
        local newSpeedY = ySpeed

        local tileX = math.ceil((gainedX)/200)
        local tileY = math.ceil((gainedY)/200)
        local currentTile = false
        if (tileY>0)and(tileY<#mapTiles)and(tileX>0)and(tileX<#mapTiles[1]) then
            currentTile = mapTiles[tileY][tileX]
        end

        if not (not currentTile) then
            local speedList = {}
            if unit.Formation=="BattleLine" then speedList=BattleLineSpeeds end
            if unit.Formation=="MarchingColumn" then speedList=MarchingColumnSpeeds end
            if unit.Formation=="SkirmishLine" then speedList=SkirmishLineSpeeds end
            for i=1,#speedList,1 do
                if speedList[i][1]==string.sub(currentTile,1,3) then
                    newSpeedX=xSpeed*speedList[i][2]
                    newSpeedY=ySpeed*speedList[i][2]
                end
            end

            gainedX=gainedX+(newSpeedX)
            gainedY=gainedY+(newSpeedY)
            local x = gainedX
            local y = gainedY

            table.insert(movePos,{x,y,currentTile})
        end
    end end

    for i=1,#movePos-15,1 do--i=1,#movePos,1
        table.insert(newTable[4],{"Charge",movePos[i]})
    end

    return newTable
end

function unitControl.CalculateChargeResult(unit,enemyUnit,camPos,zoom,mapTiles)
    if unit.Health > enemyUnit.Health then
        if enemyUnit.Health < enemyUnit.MaxHealth/2 then
            enemyUnit:Retreat(camPos,zoom,mapTiles)
            return true
        else
            unit:Retreat(camPos,zoom,mapTiles)
            return false
        end

    else
        unit:Retreat(camPos,zoom,mapTiles)
        return false
    end
end

return unitControl