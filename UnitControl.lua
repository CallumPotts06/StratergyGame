
unitControl = {}

function unitControl.CalculateWheel(unit,mousePos,camPos,zoom)
    local startRad = unit.Orientation
    local dRad = 0
    local theta = 0
    local radsPerSecond = 0.2

    local unitX=unit.Position[1]
    local unitY=unit.Position[2]

    local x1 = (unitX-camPos[1])
    local y1 = (unitY-camPos[2])
    local x2 = (mousePos[1])
    local y2 = (mousePos[2])

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
        if index==1 then tempTables[1][1]=radsPerSecond index=index+1 shortest=1
        else table.insert(tempTables[1],radsPerSecond) end
    end
    index=1


    for i = theta2,startRad,radsPerSecond do
        if index==1 then tempTables[2][1]=radsPerSecond index=index+1 shortest=2
        else table.insert(tempTables[2],-radsPerSecond) end
    end
    index=1

    for i = startRad,theta,-radsPerSecond do
        if index==1 then tempTables[3][1]=-radsPerSecond index=index+1 shortest=3
        else table.insert(tempTables[3],-radsPerSecond) end
    end
    index=1

    for i = theta2,startRad,-radsPerSecond do
        if index==1 then tempTables[4][1]=-radsPerSecond index=index+1 shortest=4
        else table.insert(tempTables[4],radsPerSecond) end
    end
    
    
    
    for i=1,#tempTables,1 do 
        if (#tempTables[i]<#tempTables[shortest])and(not(tempTables[i][1]=="INF")) then shortest=i print("changed shortest") end
    end
    newTable[4]=tempTables[shortest]
    if tempTables[shortest][1]=="INF" then return false end
    print("Shortest: "..tostring(shortest))

    return newTable
end

return unitControl