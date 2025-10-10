
Army = {}
Army.__index = Army

imgs = require("LoadSoldiers")
unit = require("Unit")
brigade = require("Brigade")
spawnUnits = require("SpawnUnits")
assets = require("LoadAssets")

function Army.New(Regiments,team)
    local newArmy = {}

    local Infantry = {}
    local Artillery = {}
    local Cavalry = {}

    local Brigades = {}
    local Divisions = {}

    local infBrigades = 0
    local artBrigades = 0
    local cavBrigades = 0

    local units = {}

    for i=1,#Regiments,1 do
        newReg = spawnUnits.CreateUnit(team..Regiments[i],team,{50,50})
        table.insert(units,newReg)
        if (Regiments[i]=="LineInfantry") or (Regiments[i]=="LightInfantry") then
            table.insert(Infantry,newReg)
        end
        if (Regiments[i]=="Artillery") then
            table.insert(Artillery,newReg)
        end
        if (Regiments[i]=="Hussars") or (Regiments[i]=="Lancers") or (Regiments[i]=="Dragoons")then
            table.insert(Cavalry,newReg)
        end
        
    end

    local currentBrigade = {}
    for i=1,#Infantry,1 do
        if #currentBrigade<4 then
            table.insert(currentBrigade,Infantry[i])
        else
            infBrigades=infBrigades+1
            local newBrigade = brigade.New(currentBrigade,"Infantry Brigade "..tostring(infBrigades))
            table.insert(Brigades,newBrigade)
            currentBrigade = {}
            table.insert(currentBrigade,Infantry[i])
        end 
    end
    if #currentBrigade>0 then
        local newBrigade = brigade.New(currentBrigade,"Infantry Brigade "..tostring(infBrigades))
        table.insert(Brigades,newBrigade)
    end

    local currentBrigade = {}
    for i=1,#Artillery,1 do
        if #currentBrigade<4 then
            table.insert(currentBrigade,Artillery[i])
        else
            artBrigades=artBrigades+1
            local newBrigade = brigade.New(currentBrigade,"Artillery Brigade "..tostring(artBrigades))
            table.insert(Brigades,newBrigade)
            currentBrigade = {}
            table.insert(currentBrigade,Artillery[i])
        end 
    end
    if #currentBrigade>0 then
        local newBrigade = brigade.New(currentBrigade,"Artillery Brigade "..tostring(artBrigades))
        table.insert(Brigades,newBrigade)
    end

    local currentBrigade = {}
    for i=1,#Cavalry,1 do
        if #currentBrigade<4 then
            table.insert(currentBrigade,Cavalry[i])
        else
            cavBrigades=cavBrigades+1
            local newBrigade = brigade.New(currentBrigade,"Cavalry Brigade "..tostring(cavBrigades))
            table.insert(Brigades,newBrigade)
            currentBrigade = {}
            table.insert(currentBrigade,Cavalry[i])
        end 
    end
    if #currentBrigade>0 then
        local newBrigade = brigade.New(currentBrigade,"Cavalry Brigade "..tostring(cavBrigades))
        table.insert(Brigades,newBrigade)
    end

    local currentDiv = {}
    for i=1,#Brigades,1 do
        if #currentDiv<3 then
            table.insert(currentDiv,Brigades[i])
        else
            table.insert(Divisions,currentDiv)
            currentDiv = {}
            table.insert(currentDiv,Brigades[i])
        end
    end
    table.insert(Divisions,currentDiv)

    newArmy.Divisions = Divisions
    newArmy.Brigades = Brigades
    newArmy.Units = units

    setmetatable(newArmy, Army)
    return newArmy
end

function Army:PrintOrderOfBattle()
    msg = ""
    for i=1,#self.Divisions,1 do
        msg=msg.."\n\tDivision "..tostring(i)
        for x=1,#self.Divisions[i],1 do
            msg=msg.."\n\t\t"..self.Divisions[i][x].Name
            msg=msg..self.Divisions[i][x]:PrintOrderOfLine()
        end
    end
    print(msg)
end

function Army:GetAllUnits(units)
    newunits = {}
    if units == nil then
        for i=1,#self.Divisions,1 do
            for x=1,#self.Divisions[i],1 do
                table.insert(newunits,self.Divisions[i][x]:UpdateOrderOfLine())
            end
        end
    else
        for i=1,#self.Divisions,1 do
            for x=1,#self.Divisions[i],1 do
                table.insert(newunits,self.Divisions[i][x]:UpdateOrderOfLine(units))
            end
        end
    end

    return newunits
end

return Army