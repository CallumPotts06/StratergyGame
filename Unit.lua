
unit = {}
unit.__index = unit

function unit.New(iName,iType,iTeam,iImgs,iPos,iHp)
    local newUnit = {}

    newUnit.Name = iName
    newUnit.Type = iType
    newUnit.Team = iTeam
    newUnit.Images = iImgs

    newUnit.Position = iPos
    newUnit.Orientation = math.pi
    newUnit.Stance = "Idle"
    newUnit.Facing = "South"
    newUnit.Formation = "BattleLine"
    newUnit.OpenOrder = "_Squad"

    newUnit.MaxHealth = iHp
    newUnit.Health = iHp
    newUnit.MaxSquads = 9

    setmetatable(newUnit, unit)
    return newUnit
end

function unit:DrawUnit(zoom,camPos)
    local imgName = self.Facing.."_"..self.Stance..self.OpenOrder
    local img = false
    for i=1,#self.Images,1 do
        if self.Images[i][1]==imgName then
            img=self.Images[i][2]
            break
        end
    end
    
    local squadCount = self.MaxSquads*(self.Health/self.MaxHealth)

    local drawPos = {}

    if self.Formation == "MarchingColumn" then
        for i=1,squadCount,1 do
            love.graphics.draw(img,(((self.Position[1]*200)-camPos[1])*zoom)+(i*44*0.5*zoom),(((self.Position[2]*200)-camPos[2])*zoom),0,zoom/2,zoom/2)
        end
    elseif self.Formation == "BattleLine" then
        local FlagPos = math.floor(squadCount/2)
        for i=math.ceil(1-(squadCount/2)),math.floor(squadCount/2),1 do
            local h = i*22*zoom
            local x = (((self.Position[1]*200)-camPos[1])*zoom)+(h*math.cos(self.Orientation))
            local y = (((self.Position[2]*200)-camPos[2])*zoom)+(h*math.sin(self.Orientation))
            love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
        end
    else

    end 

end

return unit
