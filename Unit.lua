
unit = {}
unit.__index = unit

function unit.New(iName,iType,iTeam,iImgs,iPos,iHp)
    local newUnit = {}

    newUnit.Name = iName
    newUnit.Type = iType
    newUnit.Team = iTeam
    newUnit.Images = iImgs

    newUnit.Position = iPos
    newUnit.Orientation = 0
    newUnit.Stance = "Aiming"
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
        local rad = self.Orientation
        print(rad)
        if((rad>=0)and(rad<=0.785))or(rad>=5.498)then--NORTH--
            self.Facing = "North"
            for i=math.ceil(1-(squadCount/2)),math.floor(squadCount/2),1 do
                local h = i*22*zoom
                local x = (((self.Position[1]*200)-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                local y = (((self.Position[2]*200)-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
            end
        elseif(rad>=0.785)and(rad<=2.356)then--EAST--
            self.Facing = "East"
            for i=math.ceil(1-(squadCount/2)),math.floor(squadCount/2),1 do
                local h = i*22*zoom
                local x = (((self.Position[1]*200)-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                local y = (((self.Position[2]*200)-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
            end
        elseif(rad>=2.356)and(rad<=3.927)then--SOUTH--
            self.Facing = "South"
            for i=math.floor(squadCount/2),math.ceil(1-(squadCount/2)),-1 do
                local h = i*22*zoom
                local x = (((self.Position[1]*200)-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                local y = (((self.Position[2]*200)-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
            end
        elseif(rad>=3.927)or(rad<=5.498)then--WEST--
            self.Facing = "West"
            for i=math.floor(squadCount/2),math.ceil(1-(squadCount/2)),-1 do
                local h = i*22*zoom
                local x = (((self.Position[1]*200)-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                local y = (((self.Position[2]*200)-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
            end
        end
        print(self.Facing)
    else
 
    end 

end


function unit:ChangeOrientation(rad)
    if (rad+self.Orientation<=6.283)and((rad+self.Orientation>=0)) then
        self.Orientation=self.Orientation+rad
    else
        local lostRad = (self.Orientation-6.283)+math.abs(rad)
        print("LOST RAD: "..tostring(lostRad))
        if (rad+self.Orientation>=6.283) then
            self.Orientation=0+lostRad
        else
            self.Orientation=6.283-lostRad
        end
    end
end

return unit
