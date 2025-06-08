
unitControl = {}

function unitControl.CalculateWheel(unit,mousePos,camPos,zoom)
    local startRad = unit.Orientation
    local dRad = 0
    local theta = 0
    local radsPerSecond = 0.2

    local unitX=unit.Position[1]
    local unitY=unit.Position[2]

    local x1 = (unitX*zoom)
    local y1 = (unitY*zoom)
    local x2 = ((mousePos[1])+(camPos[1]*zoom))
    local y2 = ((mousePos[2])+(camPos[2]*zoom))

    local dx = (x2-x1)
    local dy = -(y2-y1)

    local hyp = math.sqrt((dx*dx)+(dy*dy))
    local adj = dx
    local opp = dy

    --ASTC RULE--
    if (dx>=0)and(dy>=0) then theta = math.asin(opp/hyp) end
    if (dx<=0)and(dy>=0) then theta = ((3/2)*(math.pi))+math.asin(opp/hyp) end
    if (dx<=0)and(dy<=0) then theta = ((2/2)*(math.pi))+math.atan(opp/adj) end
    if (dx>=0)and(dy<=0) then theta = ((1/2)*(math.pi))+math.acos(adj/hyp) end

    radsPerSecond = 0.2

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

function unitControl.CalculateMove(unit,mousePos,camPos,zoom)
    local newTable = unitControl.CalculateWheel(unit,mousePos,camPos,zoom)

    local unitX=unit.Position[1]
    local unitY=unit.Position[2]

    local x1 = (unitX*zoom)
    local y1 = (unitY*zoom)
    local x2 = ((mousePos[1])+(camPos[1]*zoom))
    local y2 = ((mousePos[2])+(camPos[2]*zoom))

    local dx = (x2-x1)
    local dy = -(y2-y1)

    local hyp = math.sqrt((dx*dx)+(dy*dy))
    local adj = dx
    local opp = dy

    --ASTC RULE--
    if (dx>=0)and(dy>=0) then theta = math.asin(opp/hyp) end
    if (dx<=0)and(dy>=0) then theta = ((3/2)*(math.pi))+math.asin(opp/hyp) end
    if (dx<=0)and(dy<=0) then theta = ((2/2)*(math.pi))+math.atan(opp/adj) end
    if (dx>=0)and(dy<=0) then theta = ((1/2)*(math.pi))+math.acos(adj/hyp) end

    local movementSpeed = 15
    local xSpeed = math.cos(theta)*movementSpeed--CAH--
    local ySpeed = math.sin(theta)*movementSpeed--SOH--

    print("X-SPEED="..tostring(xSpeed))
    print("Y-SPEED="..tostring(ySpeed))

    local movePos = {}
    if unitX<(mousePos[1])+(camPos[1]) then
        for x=unitX,(mousePos[1])+(camPos[1]),xSpeed do
            table.insert(movePos,{x,0})
        end
    else
        for x=unitX,(mousePos[1])+(camPos[1]),-xSpeed do
            table.insert(movePos,{x,0})
        end
    end
    --[[local index = 0
    if unitY<(mousePos[2])+(camPos[2]) then
        for y=unitY,(mousePos[2])+(camPos[2]),ySpeed do
            index=index+1
            if index>=#movePos then break end
            movePos[index][2]=y
        end
    else
        for y=unitY,(mousePos[2])+(camPos[2]),-ySpeed do
            index=index+1
            if index>=#movePos then break end
            movePos[index][2]=y
        end
    end]]
    --[[for x=unitX,(mousePos[1])+(camPos[1]),xSpeed do
        table.insert(movePos,{x,0})
    end]]
    local index = 0
    for y=unitY,(mousePos[2])+(camPos[2]),ySpeed do
        index=index+1
        if index>=#movePos then break end
        movePos[index][2]=y
    end

    for i=1,#movePos,1 do
        print(tostring(movePos[i][1])..","..tostring(movePos[i][2]))
        table.insert(newTable[4],{"Move",movePos[i]})
    end

    return newTable
end

return unitControl