
unit = {}
unit.__index = unit

unitControl = require("../UnitControl")
assets = require("../LoadAssets")

function unit.New(iName,iType,iTeam,iImgs,iPos,iHp,iFireRate,iAccuracy)
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
    newUnit.MaxSquads = 16
    newUnit.AimRange = 2000
    newUnit.FireRate = iFireRate
    newUnit.Accuracy = iAccuracy

    newUnit.Moving = false
    newUnit.Selected = false
    newUnit.CurrentTarget = false

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


    if self.Selected then
        love.graphics.setColor(0.2, 0.2, 1)
        local x = ((self.Position[1])-camPos[1])*zoom
        local y = ((self.Position[2]-45)-camPos[2])*zoom
        love.graphics.circle("fill", x, y, 5*zoom, 6)
        love.graphics.setColor(1,1,1)
    end
end


function unit:ChangeOrientation(drad)
    if (drad+self.Orientation<=(math.pi*2))and((drad+self.Orientation>=0)) then
        self.Orientation=self.Orientation+drad
    else
        local lostRad = (self.Orientation-(math.pi*2))+math.abs(drad)
        if (drad+self.Orientation>=(math.pi*2)) then
            self.Orientation=0+math.abs(drad)
        else
            self.Orientation=(math.pi*2)-(math.abs(drad))
        end
    end
end

function unit:CheckClick(mousePos,camPos,zoom)
    local xmin = (((self.Position[1])-camPos[1])-(65))*zoom
    local ymin = (((self.Position[2])-camPos[2])-(65))*zoom
    local xmax = (((self.Position[1])-camPos[1])+(65))*zoom
    local ymax = (((self.Position[2])-camPos[2])+(65))*zoom

    local clicked = false
    if (mousePos[1]>=xmin) and (mousePos[1]<=xmax) then
        if (mousePos[2]>=ymin) and (mousePos[2]<=ymax) then
            clicked = true
            if self.Selected then
                self.Selected = false
            else
                self.Selected = true
            end
        end
    end
    return {clicked,self.Selected,self}
end

function unit:CheckForTargets(enemyUnits)
    local closestDistance=999999
    local closestEnemy=999999
    for i=1,#enemyUnits,1 do
        local x1=self.Position[1]
        local y1=self.Position[2]
        local x2=enemyUnits[i].Position[1]
        local y2=enemyUnits[i].Position[2]
        local dx = math.abs(x2-x1)
        local dy = math.abs(y2-y1)
        local mag = math.sqrt((dx*dx)+(dy*dy))
        if (mag<closestDistance)and(mag<self.AimRange) then closestEnemy = i closestDistance=mag end
    end
    if not (closestEnemy==999999) then
        self.CurrentTarget = enemyUnits[closestEnemy]
        return unitControl.CalculateWheel(self,"Aiming")
    else
        self.CurrentTarget = false
        return false
    end
end

function unit:Fire()
    local smoke
    local sound

    if not (not self.CurrentTarget) then
        
        sound = "MusketShot"..tostring(math.random(1,6))

        local bound1 = -5
        local bound2 = 5

        local rad = self.Orientation
        local squadCount = self.MaxSquads*(self.Health/self.MaxHealth)

        if((rad>=0)and(rad<=0.785))or(rad>=5.498)then bound1=math.ceil(1-(squadCount/2)) bound2=math.floor(squadCount/2) end
        if(rad>=0.785)and(rad<=2.356)then bound1=math.ceil(1-(squadCount/2)) bound2=math.floor(squadCount/2) end
        if(rad>=2.356)and(rad<=3.927)then bound1=math.floor(squadCount/2) bound2=math.ceil(1-(squadCount/2)) end
        if(rad>=3.927)or(rad<=5.498)then bound1=math.floor(squadCount/2) bound2=math.ceil(1-(squadCount/2)) end
        local h = math.random(bound1,bound2)*25*zoom
        local x = ((self.Position[1]))+(h*math.cos(self.Orientation))
        local y = ((self.Position[2]))+(h*math.sin(self.Orientation))

        smoke = {"Smoke",{x,y},1}

        for i=1,#assets.Sounds,1 do
            if assets.Sounds[i][1]==sound then
                love.audio.play(assets.Sounds[i][2])
                break
            end
        end

        local hit = math.random(1,math.floor(self.Accuracy/2))
        if hit==1 then self.CurrentTarget.Health=self.CurrentTarget.Health-1 end
    end

    return smoke
end

 

return unit
