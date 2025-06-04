
unit = {}
unit.__index = unit

function unit.New(iName,iType,iTeam,iImgs,iPos,iHp)
    local newUnit = {}

    newUnit.Name = iName
    newUnit.Type = iType
    newUnit.Team = iTeam
    newUnit.Images = iImgs

    newUnit.Position = iPos

    newUnit.MaxHealth = iHp
    newUnit.Health = iHp
    newUnit.MaxSquads = 8

    newUnit.Stance = "Idle"
    newUnit.Facing = "South"

    newUnit.OpenOrderBool = "_Squad"


    setmetatable(newUnit, unit)
    return newUnit
end

function unit:DrawUnit(zoom,camPos)
    local imgName = self.Facing.."_"..self.Stance..self.OpenOrderBool
    local img = false
    for i=1,#self.Images,1 do
        if self.Images[i][1]==imgName then
            img=self.Images[i][2]
            break
        end
    end
    
    local squadCount = self.MaxSquads*(self.Health/self.MaxHealth)

    for i=1,squadCount,1 do
        love.graphics.draw(img,(((self.Position[1]*200)-camPos[1])*zoom)+(i*44*0.5*zoom),(((self.Position[2]*200)-camPos[2])*zoom),0,zoom/2,zoom/2)
    end

end

return unit
