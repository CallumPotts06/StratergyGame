
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

    newBrigade.OrderOfLine = {}

    newBrigade.Position = {0,0}
    newBrigade.Orientation = 0

    if not (regiments[1]==nil) then newBrigade.Regiment1 = regiments[1] end--// Assign Regiments into Position //--
    if not (regiments[2]==nil) then newBrigade.Regiment2 = regiments[2] end
    if not (regiments[3]==nil) then newBrigade.Regiment3 = regiments[3] end
    if not (regiments[4]==nil) then newBrigade.Regiment4 = regiments[4] end
    
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
    return self.OrderOfLine
end

function Brigade:PrintOrderOfLine()
    self:UpdateOrderOfLine()
    local msg = ""
    for i=1,#self.OrderOfLine,1 do
        msg=msg.."\n\t\t\t"..self.OrderOfLine[i].Name
    end
    return msg
end

function Brigade:ChangeFormation(formup,mapTiles)
    self:UpdateOrderOfLine()
    
    local centreRegiment = math.floor(#self.OrderOfLine/2)
    local moves = {}

    if formup=="MarchingColumn" then
        local x=1
        local y=1
        for i=1,#self.OrderOfLine,1 do
            if i%2==0 then x=0 else x=1 end
            if (i==3)or(i==4) then y=1 else y=0 end
            local unit = self.OrderOfLine[i]
            local move = unitControl.CalculateMove(unit,{self.Position[1]+(90*x),self.Position[2]+(185*y)},{0,0},1,mapTiles)
            if not (not move) then
                table.insert(moves,move)
            end
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