
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
    newUnit.Stance = "Idle"
    newUnit.Facing = "South"
    newUnit.Formation = "MarchingColumn"
    newUnit.OpenOrder = ""

    newUnit.MaxHealth = iHp
    newUnit.Health = iHp
    newUnit.MaxSquads = 14

    setmetatable(newUnit, unit)
    return newUnit
end

function unit:DrawUnit(zoom,camPos)
    if (self.Formation=="MarchingColumn")and(self.OpenOrder=="_Squad")then self.OpenOrder="_MarchingSquad" end

    local imgName = self.Facing.."_"..self.Stance..self.OpenOrder
    local img = false
    local flagImg = false
    local overlayFlag = self.Images[2][2]
    for i=1,#self.Images,1 do
        if self.Images[i][1]==imgName then
            img=self.Images[i][2]
            break
        end
    end

    local imgName = self.Facing.."_FlagBearer"..self.OpenOrder
    for i=1,#self.Images,1 do
        if self.Images[i][1]==imgName then
            flagImg=self.Images[i][2]
            break
        end
    end
    
    local squadCount = self.MaxSquads*(self.Health/self.MaxHealth)

    local drawPos = {}

    if self.Formation == "MarchingColumn" then
        local FlagPos = math.floor(squadCount/4)
        local rad = (-self.Orientation)
        local flagPos= {0,0}

        print(self.Orientation)--!


        if((self.Orientation>=0)and(self.Orientation<=0.785))or(self.Orientation>=5.498)then--NORTH--
            self.Facing = "North"
            for i=math.ceil(1-(squadCount/4)),math.floor(squadCount/4),1 do

                local h = i*22*zoom
                local x = ((((self.Position[1])-camPos[1])*zoom)+(h*math.sin(rad)))
                local y = ((((self.Position[2])-camPos[2])*zoom)+(h*math.cos(rad)))

                if i==math.ceil(1-(squadCount/4)) then
                    flagPos={x,y-(41*(zoom/2))}
                    love.graphics.draw(flagImg,x,y-(49*(zoom/2)),0,zoom/2,zoom/2)
                else
                    love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                end
            end


        elseif(self.Orientation>=0.785)and(self.Orientation<=2.356)then--EAST--
            self.Facing = "East"

            for i=math.ceil(1-(squadCount/4)),math.floor(squadCount/4),1 do

                local h = i*22*zoom
                local x = ((((self.Position[1])-camPos[1])*zoom)+(h*math.sin(rad)))
                local y = ((((self.Position[2])-camPos[2])*zoom)+(h*math.cos(rad)))

                if i==math.ceil(1-(squadCount/4)) then
                    flagPos={x,y-(41*(zoom/2))}
                    love.graphics.draw(flagImg,x,y-(49*(zoom/2)),0,zoom/2,zoom/2)
                else
                    love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                end
            end

        elseif(self.Orientation>=2.356)and(self.Orientation<=3.927)then--SOUTH--
            self.Facing = "South"

           for i=math.floor((squadCount/4)),math.ceil(1-(squadCount/4)),-1 do

                local h = i*22*zoom
                local x = ((((self.Position[1])-camPos[1])*zoom)+(h*math.sin(rad)))
                local y = ((((self.Position[2])-camPos[2])*zoom)+(h*math.cos(rad)))

                if i==math.ceil(1-(squadCount/4)) then
                    flagPos={x,y-(41*(zoom/2))}
                    love.graphics.draw(flagImg,x,y-(49*(zoom/2)),0,zoom/2,zoom/2)
                else
                    love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                end
            end

        elseif(self.Orientation>=3.927)or(self.Orientation<=5.498)then--WEST--
            self.Facing = "West"

            for i=math.floor((squadCount/4)),math.ceil(1-(squadCount/4)),-1 do

                local h = i*22*zoom
                local x = ((((self.Position[1])-camPos[1])*zoom)+(h*math.sin(rad)))
                local y = ((((self.Position[2])-camPos[2])*zoom)+(h*math.cos(rad)))

                if i==math.ceil(1-(squadCount/4)) then
                    flagPos={x,y-(41*(zoom/2))}
                    love.graphics.draw(flagImg,x,y-(49*(zoom/2)),0,zoom/2,zoom/2)
                else
                    love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                end
            end

        end
        love.graphics.draw(overlayFlag,flagPos[1],flagPos[2],0,zoom/2,zoom/2)




    elseif self.Formation == "BattleLine" then
        local FlagPos = math.floor(squadCount/2)
        local rad = self.Orientation
        local flagPos= {0,0}
        if((rad>=0)and(rad<=0.785))or(rad>=5.498)then--NORTH--
            self.Facing = "North"
            for i=math.ceil(1-(squadCount/2)),math.floor(squadCount/2),1 do
                local h = i*22*zoom
                local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                if i==0 then
                    flagPos={x,y-(41*(zoom/2))}
                    love.graphics.draw(flagImg,x,y-(49*(zoom/2)),0,zoom/2,zoom/2)
                else
                    love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                end
            end
        elseif(rad>=0.785)and(rad<=2.356)then--EAST--
            self.Facing = "East"
            for i=math.ceil(1-(squadCount/2)),math.floor(squadCount/2),1 do
                local h = i*22*zoom
                local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                if i==0 then
                    flagPos={x,y-(41*(zoom/2))}
                    love.graphics.draw(flagImg,x,y-(49*(zoom/2)),0,zoom/2,zoom/2)
                else
                    love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                end
            end
        elseif(rad>=2.356)and(rad<=3.927)then--SOUTH--
            self.Facing = "South"
            for i=math.floor(squadCount/2),math.ceil(1-(squadCount/2)),-1 do
                local h = i*22*zoom
                local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                if i==0 then
                    flagPos={x,y-(41*(zoom/2))}
                    love.graphics.draw(flagImg,x,y-(49*(zoom/2)),0,zoom/2,zoom/2)
                else
                    love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                end
            end
        elseif(rad>=3.927)or(rad<=5.498)then--WEST--
            self.Facing = "West"
            for i=math.floor(squadCount/2),math.ceil(1-(squadCount/2)),-1 do
                local h = i*22*zoom
                local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                if i==0 then
                    flagPos={x,y-(41*(zoom/2))}
                    love.graphics.draw(flagImg,x,y-(49*(zoom/2)),0,zoom/2,zoom/2)
                else
                    love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                end
            end
        end
        love.graphics.draw(overlayFlag,flagPos[1],flagPos[2],0,zoom/2,zoom/2)




    elseif self.Formation=="SkirmishLine" then
        local rad = self.Orientation
        if((rad>=0)and(rad<=0.785))or(rad>=5.498)then--NORTH--
            self.Facing = "North"
        elseif(rad>=0.785)and(rad<=2.356)then--EAST--
            self.Facing = "East"
        elseif(rad>=2.356)and(rad<=3.927)then--SOUTH--
            self.Facing = "South"
        elseif(rad>=3.927)or(rad<=5.498)then--WEST--
            self.Facing = "West"
        end
        for i=math.ceil(1-(squadCount/2.25)),math.floor(squadCount/2.25),1 do
            local h = i*28*zoom
            local h2 = (i-3)*28*zoom
            local x1 = (((self.Position[1])-camPos[1])*zoom)+(h*math.cos(self.Orientation))
            local y1 = (((self.Position[2])-camPos[2])*zoom)+(h*math.sin(self.Orientation))

            local offsetX = math.cos(self.Orientation+(math.pi/4))*100*zoom
            local offsetY = math.sin(self.Orientation+(math.pi/4))*100*zoom

            local x2 = (((self.Position[1])-camPos[1])*zoom)+(h2*math.cos(self.Orientation))+offsetX
            local y2 = (((self.Position[2])-camPos[2])*zoom)+(h2*math.sin(self.Orientation))+offsetY

            if i==0 then
                love.graphics.draw(flagImg,x1,y1-(49*(zoom/2)),0,zoom/2,zoom/2)
                love.graphics.draw(img,x2,y2,0,zoom/2,zoom/2)
            else
                love.graphics.draw(img,x1,y1,0,zoom/2,zoom/2)
                love.graphics.draw(img,x2,y2,0,zoom/2,zoom/2)
            end
        end

    end
end


function unit:ChangeOrientation(drad)
    if (drad+self.Orientation<=6.283)and((drad+self.Orientation>=0)) then
        self.Orientation=self.Orientation+drad
    else
        local lostRad = (self.Orientation-6.283)+math.abs(drad)
        print("LOST RAD: "..tostring(lostRad))
        if (drad+self.Orientation>=6.283) then
            self.Orientation=0+lostRad
        else
            self.Orientation=6.283-lostRad
        end
    end
end

return unit
