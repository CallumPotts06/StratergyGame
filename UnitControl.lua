
unitControl = {}

function unitControl.CalculateWheel(unit,mousePos,camPos,zoom)
    local startRad = unit.Orientation
    local dRad = 0
    local theta = 0
    local radsPerSecond = 0.2

    local x1 = ((unit.Position[1])-camPos[1])*zoom
    local y1 = ((unit.Position[2])-camPos[2])*zoom
    local x2 = (mousePos[1]+camPos[1])*zoom
    local y2 = (mousePos[2]+camPos[2])*zoom

    local dx = x2-x1
    local dy = y2-y1

    local hyp = math.sqrt((dx*dx)+(dy*dy))
    local adj = dx
    local opp = dy

    --ASTC RULE--
    if (dx>=0)and(dy>=0) then theta = math.asin(opp/hyp) end
    if (dx<=0)and(dy>=0) then theta = ((3/2)*(math.pi))+math.asin(opp/hyp) end
    if (dx<=0)and(dy<=0) then theta = ((2/2)*(math.pi))+math.atan(opp/adj) end
    if (dx>=0)and(dy<=0) then theta = ((1/2)*(math.pi))+math.acos(adj/hyp) end


    if theta>=startRad then radsPerSecond = 0.2 end
    if theta<=startRad then radsPerSecond = -0.2 end

    local newTable = {unit,"Wheel",1,{}}
    for iRad = startRad,theta,radsPerSecond do
        print(iRad)
        table.insert(newTable[4],iRad)
    end

    return newTable
end

return unitControl