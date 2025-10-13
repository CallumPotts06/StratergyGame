
Brigade = {}
Brigade.__index = Brigade

unitControl = require("UnitControl")

function Brigade.New(regiments,iname)--// CONSTRUCTOR //--
    local newBrigade = {}

    newBrigade.Name = iname

    newBrigade.Regiment1=nil--// Set up Regiments of the Brigade //--
    newBrigade.Regiment2=nil
    newBrigade.Regiment3=nil
    newBrigade.Regiment4=nil

    newBrigade.Formation = "MarchingColumn"

    newBrigade.Position = {0,0}
    newBrigade.Orientation = 0

    --// Assign Regiments into Position //--
    if not (regiments[1]==nil) then newBrigade.Regiment1=regiments[1]newBrigade.Regiment1.ParentBrigade=newBrigade end
    if not (regiments[2]==nil) then newBrigade.Regiment2=regiments[2]newBrigade.Regiment2.ParentBrigade=newBrigade end
    if not (regiments[3]==nil) then newBrigade.Regiment3=regiments[3]newBrigade.Regiment3.ParentBrigade=newBrigade end
    if not (regiments[4]==nil) then newBrigade.Regiment4=regiments[4]newBrigade.Regiment4.ParentBrigade=newBrigade end

    print("Regiment1="..newBrigade.Regiment1.Name)

    newBrigade.OrderOfline = {regiments[1]}
    
    setmetatable(newBrigade, Brigade)
    return newBrigade
end

function Brigade:UpdateOrderOfLine(units)
    if not (units == nil) then
        self.OrderOfLine = {}
        for i=1,#units,1 do
            if not (self.Regiment1==nil) then if self.Regiment1.Name==units[i].Name then self.Regiment1=units[i]table.insert(self.OrderOfLine,units[i])end end
            if not (self.Regiment2==nil) then if self.Regiment2.Name==units[i].Name then self.Regiment2=units[i]table.insert(self.OrderOfLine,units[i])end end
            if not (self.Regiment3==nil) then if self.Regiment3.Name==units[i].Name then self.Regiment3=units[i]table.insert(self.OrderOfLine,units[i])end end
            if not (self.Regiment4==nil) then if self.Regiment4.Name==units[i].Name then self.Regiment4=units[i]table.insert(self.OrderOfLine,units[i])end end
        end
    end
    self.Position=self.OrderOfLine[1].Position
    return self.OrderOfLine
end

function Brigade:PrintOrderOfLine(units)
    self:UpdateOrderOfLine(units)
    local msg = ""
    for i=1,#self.OrderOfLine,1 do
        msg=msg.."\n\t\t\t"..self.OrderOfLine[i].Name
    end
    return msg
end

function Brigade:ChangeFormation(formup,mapTiles,pos,newPos,moveType,units)
    if units then self.OrderOfLine = self:UpdateOrderOfLine(units) end
    
    local centreRegiment = math.floor(#self.OrderOfLine/2)
    local moves = {}

    if formup=="MarchingColumn" then
        local x=1
        local y=1
        for i=1,#self.OrderOfLine,1 do
            local defaultAngle = self.Orientation

            local dx = pos[1]-newPos[1]
            local dy = pos[2]-newPos[2]

            local hyp = math.sqrt((dx*dx)+(dy*dy))
            local adj = dx
            local opp = dy

            --ASTC RULE--
            if (dx>=0)and(dy>=0) then defaultAngle = math.atan(adj/opp) end
            if (dx<=0)and(dy>=0) then defaultAngle = ((3/2)*(math.pi))+math.asin(opp/hyp) end
            if (dx<=0)and(dy<=0) then defaultAngle = ((math.pi))+math.atan(adj/opp) end
            if (dx>=0)and(dy<=0) then defaultAngle = ((1/2)*(math.pi))+math.acos(adj/hyp) end

            local thetaX = defaultAngle+(math.pi/2)
            local thetaY = defaultAngle+(math.pi)

            local x = 90*math.cos(thetaX)
            local y = 250*math.cos(thetaX)

            if i%2==0 then x=x*0 else x=x*1 end
            if (i==3)or(i==4) then y=y*1 else y=y*0 end
            local unit = self.OrderOfLine[i]
            local move1
            local move2

            print("Unit"..tostring(i)..".Offset={"..tostring(math.floor(x))..","..tostring(math.floor(y)).."}")
            if moveType=="Wheel" then
                move1 = unitControl.CalculateMove(unit,{self.OrderOfLine[1].Position[1]+x,self.OrderOfLine[1].Position[2]+y},{0,0},1,mapTiles)
                move2 = unitControl.CalculateWheel(unit,{newPos[1]+x,newPos[2]+y},{0,0},1,mapTiles)
            else
                print("X="..tostring(newPos[1]+x))
                print("Y="..tostring(newPos[2]+y))
                move1 = unitControl.CalculateMove(unit,{newPos[1]+x,newPos[2]+y},{0,0},1,mapTiles)
            end

            print("#Move1="..tostring(#move1))

            local newMove = {}
            if not (not move1) then for i=1,#move1,1 do table.insert(newMove,move1[i]) end end--print(tostring(move1[i][1]))
            if not (not move2) then for i=1,#move2,1 do table.insert(newMove,move2[i]) end end
            if #newMove>0 then table.insert(moves,newMove) end

            print("#newMove="..tostring(#newMove))

            self.OrderOfLine[i].Formation="MarchingColumn"
        end
    end

    return moves
end

function Brigade:Teleport(newPos)
    self.Position=newPos
    for i=1,#self.OrderOfLine,1 do
        if self.Formation=="MarchingColumn" then
            if i%2==0 then x=0 else x=1 end
            if (i==3)or(i==4) then y=1 else y=0 end
            self.OrderOfLine[i].Position={newPos[1]+(90*x),newPos[2]+(185*y)}
        end
    end
end

return Brigade