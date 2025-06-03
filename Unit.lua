
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
    newUnit.MaxSquads = 10

    newUnit.Stance = "Idle"
    newUnit.Facing = "South"
    newUnit.OpenOrderBool = "Squad"


    setmetatable(newUnit, unit)
    return newUnit
end

function unit:DrawUnit(zoom)
    local imgName = self.Facing.."_"..self.Stance.."_"..self.OpenOrderBool
    local img = false
    for i=1,#self.Images,1 do
        if self.Images[i][1]==imgName then
            img=self.Images[i][2]
            break
        end
    end
    
    local squadCount = self.MaxSquads*(self.Health/self.MaxHealth)

    for i=1,squadCount,1 do
        print("IMG TRUE")
        love.graphics.draw(img,(self.Position[1]*200*zoom)+(i*27*zoom),(self.Position[2]*200*zoom),0,zoom,zoom)
    end

end

return unit
