
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

    local gainedRad = 0
    local endRad = theta

    for i = startRad,theta,radsPerSecond do
        --endRad=theta
        if index==1 then tempTables[1][1]={"Wheel",radsPerSecond} index=index+1 shortest=1 gainedRad=0.2
        else table.insert(tempTables[1],{"Wheel",radsPerSecond}) gainedRad=gainedRad+0.2 end
    end
    index=1
    for i = theta2,startRad,radsPerSecond do
        --endRad=theta2
        if index==1 then tempTables[2][1]={"Wheel",-radsPerSecond} index=index+1 shortest=2 gainedRad=-0.2
        else table.insert(tempTables[2],{"Wheel",-radsPerSecond}) gainedRad=gainedRad-0.2 end
    end
    index=1
    for i = startRad,theta,-radsPerSecond do
        --endRad=theta
        if index==1 then tempTables[3][1]={"Wheel",-radsPerSecond} index=index+1 shortest=3 gainedRad=-0.2
        else table.insert(tempTables[3],{"Wheel",-radsPerSecond}) gainedRad=gainedRad-0.2 end
    end
    index=1
    for i = theta2,startRad,-radsPerSecond do
        --endRad=theta2
        if index==1 then tempTables[4][1]={"Wheel",radsPerSecond} index=index+1 shortest=4 gainedRad=0.2
        else table.insert(tempTables[4],{"Wheel",radsPerSecond}) gainedRad=gainedRad+0.2 end
    end
    
    local dRad = endRad-gainedRad
    
    
    for i=1,#tempTables,1 do 
        if (#tempTables[i]<#tempTables[shortest])and(not(tempTables[i][1]=="INF")) then shortest=i end
    end
    newTable[4]=tempTables[shortest]
    if tempTables[shortest][1]=="INF" then return false end

    table.insert(newTable[4],{"Wheel",dRad})

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
    for x=unitX,x2,xSpeed do
        table.insert(movePos,{x,0})
    end
    --[[local index = 0
    local lastY=0
    if (unitY<y2)and(ySpeed>0) then
        for y=unitY,y2,ySpeed do
            index=index+1
            if not(y==0) then lastY=y end
            if index>#movePos then break end
            movePos[index][2]=lastY
        end
    else
        for y=unitY,y2,-ySpeed do
            index=index+1
            if not(y==0) then lastY=y end
            if index>#movePos then break end
            movePos[index][2]=lastY
        end
    end]]

    for i=1,#movePos,1 do
        local y=unitY+(ySpeed*(i-1))
        movePos[i][2]=y
    end

    --[[for x=unitX,(mousePos[1])+(camPos[1]),xSpeed do
        table.insert(movePos,{x,0})
    end
    local index = 0
    for y=unitY,(mousePos[2])+(camPos[2]),ySpeed do
        index=index+1
        if index>#movePos then break end
        movePos[index][2]=y
    end]]

    for i=1,#movePos,1 do
        print(tostring(movePos[i][1])..","..tostring(movePos[i][2]))
        table.insert(newTable[4],{"Move",movePos[i]})
    end

    return newTable
end

return unitControl