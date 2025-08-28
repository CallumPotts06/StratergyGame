
unit = {}
unit.__index = unit

unitControl = require("../UnitControl")
assets = require("../LoadAssets")

function unit.New(iName,iType,iTeam,iImgs,iPos,iHp,iFireRate,iAccuracy,iRange)
    local newUnit = {}

    newUnit.Name = iName
    newUnit.Type = iType
    newUnit.Team = iTeam
    newUnit.Images = iImgs

    newUnit.Position = iPos
    newUnit.Orientation = math.pi
    newUnit.Stance = "Idle"
    newUnit.Facing = "South"
    newUnit.OpenOrder = "_Squad"

    newUnit.MaxHealth = iHp
    newUnit.Health = iHp
    newUnit.MaxSquads = 16
    newUnit.AimRange = iRange
    newUnit.Damage = 1
    newUnit.FireRate = iFireRate
    newUnit.Accuracy = iAccuracy

    newUnit.Moving = false
    newUnit.Selected = false
    newUnit.CurrentTarget = false
    newUnit.IsDead = false
    newUnit.Retreating = false

    if (iType=="LineInfantry")or(iType=="LightInfantry") then
        newUnit.Damage = 0.9
        newUnit.Formation = "BattleLine"
    elseif iType=="Artillery" then
        newUnit.Damage = 1.6
        newUnit.Formation = "BattleLine"
    end

    setmetatable(newUnit, unit)
    return newUnit
end

function unit:DrawUnit(zoom,camPos)
    if unit.IsDead then return end

    if (self.Type=="LineInfantry") or (self.Type=="LightInfantry")  then
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
    elseif self.Type=="Artillery" then

        local imgName = self.Facing.."_RegularGun"
        local flagName = self.Facing.."_FlagGun"
        local img = false
        local flagImg = false
        local overlayFlag = self.Images[2][2]
        for i=1,#self.Images,1 do
            if self.Images[i][1]==imgName then
                img=self.Images[i][2]
            elseif self.Images[i][1]==flagName then
                flagImg=self.Images[i][2]
            end
        end
        local squadCount = self.MaxSquads*(self.Health/self.MaxHealth)/2.5

        if self.Formation == "BattleLine" then
            local FlagPos = math.floor(squadCount/2)
            local rad = self.Orientation
            local flagPos= {0,0}
            if((rad>=0)and(rad<=0.785))or(rad>=5.498)then--NORTH--
                self.Facing = "North"
                for i=math.ceil(1-(squadCount/2)),math.floor(squadCount/2),1 do
                    local h = i*115*zoom
                    local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                    local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                    if i==0 then
                        flagPos={x,y}
                        love.graphics.draw(flagImg,x,y,0,zoom/2,zoom/2)
                    else
                        love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                    end
                end
            elseif(rad>=0.785)and(rad<=2.356)then--EAST--
                self.Facing = "East"
                for i=math.ceil(1-(squadCount/2)),math.floor(squadCount/2),1 do
                    local h = i*115*zoom
                    local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                    local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                    if i==0 then
                        flagPos={x,y}
                        love.graphics.draw(flagImg,x,y,0,zoom/2,zoom/2)
                    else
                        love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                    end
                end
            elseif(rad>=2.356)and(rad<=3.927)then--SOUTH--
                self.Facing = "South"
                for i=math.floor(squadCount/2),math.ceil(1-(squadCount/2)),-1 do
                    local h = i*115*zoom
                    local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                    local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                    if i==0 then
                        flagPos={x,y}
                        love.graphics.draw(flagImg,x,y,0,zoom/2,zoom/2)
                    else
                        love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                    end
                end
            elseif(rad>=3.927)or(rad<=5.498)then--WEST--
                self.Facing = "West"
                for i=math.floor(squadCount/2),math.ceil(1-(squadCount/2)),-1 do
                    local h = i*115*zoom
                    local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.cos(self.Orientation))
                    local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.sin(self.Orientation))
                    if i==0 then
                        flagPos={x,y}
                        love.graphics.draw(flagImg,x,y,0,zoom/2,zoom/2)
                    else
                        love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                    end
                end
            end

            love.graphics.draw(overlayFlag,flagPos[1],flagPos[2],0,zoom/2,zoom/2)
        elseif self.Formation == "MarchingColumn" then
            local FlagPos = math.floor(squadCount/2)
            local rad = self.Orientation
            local flagPos= {0,0}
            if((rad>=0)and(rad<=0.785))or(rad>=5.498)then--NORTH--
                self.Facing = "North"
                for i=math.ceil(1-(squadCount/2)),math.floor(squadCount/2),1 do
                    local h = i*115*zoom
                    local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.sin(self.Orientation))
                    local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.cos(self.Orientation))
                    if i==0 then
                        flagPos={x,y}
                        love.graphics.draw(flagImg,x,y,0,zoom/2,zoom/2)
                    else
                        love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                    end
                end
            elseif(rad>=0.785)and(rad<=2.356)then--EAST--
                self.Facing = "East"
                for i=math.ceil(1-(squadCount/2)),math.floor(squadCount/2),1 do
                    local h = i*115*zoom
                    local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.sin(self.Orientation))
                    local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.cos(self.Orientation))
                    if i==0 then
                        flagPos={x,y}
                        love.graphics.draw(flagImg,x,y,0,zoom/2,zoom/2)
                    else
                        love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                    end
                end
            elseif(rad>=2.356)and(rad<=3.927)then--SOUTH--
                self.Facing = "South"
                for i=math.floor(squadCount/2),math.ceil(1-(squadCount/2)),-1 do
                    local h = i*115*zoom
                    local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.sin(self.Orientation))
                    local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.cos(self.Orientation))
                    if i==0 then
                        flagPos={x,y}
                        love.graphics.draw(flagImg,x,y,0,zoom/2,zoom/2)
                    else
                        love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                    end
                end
            elseif(rad>=3.927)or(rad<=5.498)then--WEST--
                self.Facing = "West"
                for i=math.floor(squadCount/2),math.ceil(1-(squadCount/2)),-1 do
                    local h = i*115*zoom
                    local x = (((self.Position[1])-camPos[1])*zoom)+(h*math.sin(self.Orientation))
                    local y = (((self.Position[2])-camPos[2])*zoom)+(h*math.cos(self.Orientation))
                    if i==0 then
                        flagPos={x,y}
                        love.graphics.draw(flagImg,x,y,0,zoom/2,zoom/2)
                    else
                        love.graphics.draw(img,x,y,0,zoom/2,zoom/2)
                    end
                end
            end

            love.graphics.draw(overlayFlag,flagPos[1],flagPos[2],0,zoom/2,zoom/2)
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

function unit:CheckForTargets(enemyUnits,plrTeam)
    local closestDistance=999999999
    local closestEnemy=999999999
    for i=1,#enemyUnits,1 do
        local x1=self.Position[1]
        local y1=self.Position[2]
        local x2=enemyUnits[i].Position[1]
        local y2=enemyUnits[i].Position[2]
        local dx = math.abs(x2-x1)
        local dy = math.abs(y2-y1)
        local mag = math.sqrt((dx*dx)+(dy*dy))
        if not (self.AimRange==nil) then
            if (mag<closestDistance)and(mag<self.AimRange) then closestEnemy = i closestDistance=mag end
        end 
    end
    if not (closestEnemy==999999999) then
        self.CurrentTarget = enemyUnits[closestEnemy]
        return unitControl.CalculateWheel(self,"Aiming")
    else
        self.CurrentTarget = false
        return false
    end
end

function unit:Retreat(camPos,zoom,mapTiles)
    if not self.Retreating then
        self.Retreating = true
        self.CurrentTarget = false
        self.Moving = true

        self.Orientation=self.Orientation+math.pi--about face--
        if self.Orientation>=(2*math.pi) then self.Orientation=self.Orientation-(2*math.pi) end

        local theta = (2*math.pi)-self.Orientation
        local endX = math.abs(((750*math.sin(theta))-camPos[1])*zoom)
        local endY = math.abs(((750*math.cos(theta))-camPos[2])*zoom)

        local move = unitControl.CalculateMove(self,{endX,endY},camPos,zoom,mapTiles)
        return move
    end
end


function unit:Fire(camPos,gameResolution,plrTeam,zoom,mapTiles)
    if self.Formation=="BattleLine" then
        local smoke
        local sound
        local dead
        local hitFX
        local retreat = false

        if not (not self.CurrentTarget) then
            print(self.Team)

            local multiplier = 25
            local squadCount = self.MaxSquads*(self.Health/self.MaxHealth)

            if (self.Type=="LineInfantry")or(self.Type=="LightInfantry") then
                sound = "MusketShot"..tostring(math.random(1,18))
                multiplier=25
                squadCount = self.MaxSquads*(self.Health/self.MaxHealth)
            elseif self.Type=="Artillery" then
                sound = "CannonShot"..tostring(math.random(1,6))
                multiplier=100
                squadCount = self.MaxSquads*(self.Health/self.MaxHealth)/3
            end

            local bound1 = -5
            local bound2 = 5
            local rad = self.Orientation  
            if((rad>=0)and(rad<=0.785))or(rad>=5.498)then bound1=math.ceil(1-(squadCount/2)) bound2=math.floor(squadCount/2) end
            if(rad>=0.785)and(rad<=2.356)then bound1=math.ceil(1-(squadCount/2)) bound2=math.floor(squadCount/2) end
            if(rad>=2.356)and(rad<=3.927)then bound1=math.floor(squadCount/2) bound2=math.ceil(1-(squadCount/2)) end
            if(rad>=3.927)or(rad<=5.498)then bound1=math.floor(squadCount/2) bound2=math.ceil(1-(squadCount/2)) end
            local h = math.random(bound1,bound2)*multiplier*zoom
            local x = ((self.Position[1]))+(h*math.cos(self.Orientation))
            local y = ((self.Position[2]))+(h*math.sin(self.Orientation))
            smoke = {"Smoke",{x,y},1}

            local enemy = self.CurrentTarget
            local bound1 = -8
            local bound2 = 8
            local rad = enemy.Orientation
            local squadCount = enemy.MaxSquads*(enemy.Health/enemy.MaxHealth)
            if((rad>=0)and(rad<=0.785))or(rad>=5.498)then bound1=math.ceil(1-(squadCount/2)) bound2=math.floor(squadCount/2) end
            if(rad>=0.785)and(rad<=2.356)then bound1=math.ceil(1-(squadCount/2)) bound2=math.floor(squadCount/2) end
            if(rad>=2.356)and(rad<=3.927)then bound1=math.floor(squadCount/2) bound2=math.ceil(1-(squadCount/2)) end
            if(rad>=3.927)or(rad<=5.498)then bound1=math.floor(squadCount/2) bound2=math.ceil(1-(squadCount/2)) end
            local h = math.random(bound1,bound2)*23*zoom
            local x = ((enemy.Position[1]))+(h*math.cos(enemy.Orientation))
            local y = ((enemy.Position[2]))+(h*math.sin(enemy.Orientation))
            if (self.Type=="LineInfantry")or(self.Type=="LightInfantry") then
                hitFX = {"BulletHit"..tostring(math.random(1,3)),{x+math.random(-15,15),y+math.random(-15,15)},1}
            elseif self.Type=="Artillery" then
                hitFX = {"CannonHit"..tostring(math.random(1,3)),{x+math.random(-15,15),y+math.random(-15,15)},1}
            end

            if (enemy.Type=="LineInfantry")or(enemy.Type=="LightInfantry") then
                dead = {"Dead"..enemy.Team..enemy.Type,{x+math.random(-8,8),y+math.random(-8,8)},1}
            end

            for i=1,#assets.FireSounds,1 do
                if assets.FireSounds[i][1]==sound then
                    local dx = (((camPos[1]-(gameResolution[1]/2))-x)/1500)+1
                    local dy = (((camPos[2]-(gameResolution[2]/2))-y)/1500)+1
                    local mag = math.sqrt((dx*dx)+(dy*dy))
                    assets.FireSounds[i][2]:setPosition(-dx, 0, -dy)
                    love.audio.setPosition(0,0,0)
                    love.audio.setVolume(1)
                    love.audio.play(assets.FireSounds[i][2])
                    break
                end
            end

            local dx = enemy.Position[1]-self.Position[1]
            local dy = enemy.Position[1]-self.Position[1]
            local shotRange = math.sqrt((dx*dx)+(dy*dy))
            local hit = math.random(1,math.floor((self.Accuracy*(shotRange/1000))/2))
            print(self.Team)
            if plrTeam==self.CurrentTarget.Team then
                if hit==1 then self.CurrentTarget.Health=self.CurrentTarget.Health-self.Damage else dead="" end
                if self.CurrentTarget.Health<=15 then self.CurrentTarget.IsDead = true
                elseif self.CurrentTarget.Health<=(self.CurrentTarget.MaxHealth/1.4) then
                    if math.random(1,8)==1 then
                        print("Retreat")
                        retreat = self.CurrentTarget:Retreat(camPos,zoom,mapTiles)
                    end
                end
            end
        end

        return {smoke,dead,hitFX,retreat}
    else
        return {false,false,false,false}
    end
end

function unit:PlayMarchingSounds(camPos,gameResolution,mapTiles)
    local tileX = math.ceil((self.Position[1])/200)
    local tileY = math.ceil((self.Position[2])/200)
    local currentTile = mapTiles[tileY][tileX]

    local soundsTable = {
        {"GRS","Grass"},
        {"FRD","Stream"},
        {"FST","Forest"},
        {"BRD","Road"},
        {"ROD","Road"},
        {"STR","Stream"},
        {"SWP","Forest"},
        {"TRP","Road"},
        {"URB","Road"},
        {"CRN","Grass"},
        {"WHE","Grass"},
    }
    local sound=false
    for i=1,#soundsTable,1 do
        if soundsTable[i][1]==string.sub(currentTile,1,3) then
            if soundsTable[i][2]=="Grass" then
                sound = assets.MarchSounds[1][2]
                local index = 1
                while index<6 do
                    if not assets.MarchSounds[(4*index)+1][3] then
                        assets.MarchSounds[(4*index)+1][3] = true
                        sound = assets.MarchSounds[(4*index)+1][2]
                        break
                    end
                    index=index+1
                end
            elseif soundsTable[i][2]=="Forest" then
                sound = assets.MarchSounds[2][2]
                local index = 1
                while index<6 do
                    if not assets.MarchSounds[(4*index)+2][3] then
                        assets.MarchSounds[(4*index)+2][3] = true
                        sound = assets.MarchSounds[(4*index)+2][2]
                        break
                    end
                    index=index+1
                end
            elseif soundsTable[i][2]=="Road" then
                sound = assets.MarchSounds[3][2]
                local index = 1
                while index<6 do
                    if not assets.MarchSounds[(4*index)+3][3] then
                        assets.MarchSounds[(4*index)+3][3] = true
                        sound = assets.MarchSounds[(4*index)+3][2]
                        break
                    end
                    index=index+1
                end
            elseif soundsTable[i][2]=="Stream" then
                sound = assets.MarchSounds[4][2]
                local index = 1
                while index<6 do
                    if not assets.MarchSounds[(4*index)+4][3] then
                        assets.MarchSounds[(4*index)+4][3] = true
                        sound = assets.MarchSounds[(4*index)+4][2]
                        break
                    end
                    index=index+1
                end
            end 
        end
    end

    if not (not sound) then
        local dx = (((camPos[1]-(gameResolution[1]/2))-self.Position[1])/1500)+1
        local dy = (((camPos[2]-(gameResolution[2]/2))-self.Position[2])/1500)+1

        sound:setPosition(-dx, 0, -dy)
        love.audio.setPosition(0,0,0)
        sound:setVolume(0.2)
        love.audio.play(sound)
    end
end

return unit
