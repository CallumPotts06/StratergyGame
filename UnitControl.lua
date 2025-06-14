
unitControl = {}

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
        if index==1 then tempTables[2][1]={"Wheel",-radsPerSecond} index=index+1 shortest=2
        else table.insert(tempTables[2],{"Wheel",-radsPerSecond}) end
    end
    index=1
    for i = startRad,theta,-radsPerSecond do
        if index==1 then tempTables[3][1]={"Wheel",-radsPerSecond} index=index+1 shortest=3
        else table.insert(tempTables[3],{"Wheel",-radsPerSecond}) end
    end
    index=1
    for i = theta2,startRad,-radsPerSecond do
        if index==1 then tempTables[4][1]={"Wheel",radsPerSecond} index=index+1 shortest=4
        else table.insert(tempTables[4],{"Wheel",radsPerSecond}) end
    end
    
    
    for i=1,#tempTables,1 do 
        if (#tempTables[i]<#tempTables[shortest])and(not(tempTables[i][1]=="INF")) then shortest=i end
    end
    newTable[4]=tempTables[shortest]
    if tempTables[shortest][1]=="INF" then return false end

    return newTable
end

function unitControl.CalculateMove(unit,mousePos,camPos,zoom,mapTiles)
    local MarchingColumnSpeeds = {
        {"GRS",1.4},
        {"FRD",0.6},
        {"FST",0.4},
        {"BRD",1.5},
        {"ROD",2.1},
        {"STR",0.4},
        {"SWP",0.3},
        {"TRP",1.6},
        {"URB",0.05},
        {"CRN",0.4},
        {"WHE",0.4},
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
       

        table.insert(movePos,{x,y})
    end else while x2<gainedX do
        i=i+1
        local newSpeedX = xSpeed
        local newSpeedY = ySpeed

        local tileX = math.ceil((gainedX)/200)
        local tileY = math.ceil((gainedY)/200)
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

        table.insert(movePos,{x,y})
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

function unitControl.Dijkstras(endPos,mapTiles,unit,mousePos,camPos,zoom)
    local terrain = {
        {"GRS",2},
        {"FRD",4},
        {"FST",4},
        {"BRD",1},
        {"ROD",1},
        {"STR",6},
        {"SWP",4},
        {"TRP",1},
        {"URB",15},
        {"CRN",5},
        {"WHE",5},
    }

    local lastTile = {math.ceil(unit.Position[1]/200),math.ceil(unit.Position[2]/200)}
    local endTile = {math.ceil(endPos[1]/200),math.ceil(endPos[2]/200)}

    local path = {}
    local graph = {}

    local str=""--!

    for y=1,#mapTiles,1 do
        table.insert(graph,{})
        str=str.."\n"--!
        for x=1,#mapTiles[1],1 do
            local newValue = {}
            local dx = endTile[1]-x
            local dy = endTile[2]-y
            local currentTerrain = 2 
            for i=1,#terrain,1 do if terrain[i][1]==string.sub(mapTiles[y][x],1,3)then currentTerrain=terrain[i][2]end end
            local heurisitic = dx+dy+currentTerrain
            local weight = currentTerrain
            table.insert(graph[y],{weight,heurisitic})
            str=str..tostring(heurisitic)..", "--!
        end
    end

    print(str)--!

    local reachedDestination = false
    

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
            if graph[adjTiles[2]][adjTiles[1]][2]<shortest[2] then
                shortest={index,graph[adjTiles[2]][adjTiles[1]][2]}
            end
        end

        lastTile = adjTiles[shortest[1]]
        table.insert(path,adjTiles[shortest[1]])
         print("Path: ("..tostring(adjTiles[shortest[1]][1])..","..tostring(adjTiles[shortest[1]][2])..")")
        if (adjTiles[shortest[1]][1]==endPos[1])and(adjTiles[shortest[1]][2]==endPos[2]) then
            reachedDestination = true
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
end


return unitControl