
spawnUnits = {}

unit = require("Unit")
imgs = require("LoadSoldiers")

local prussianUnits = 0
local frenchUnits =0

spawnUnits.stats = {
    --Type,Team,Imgs,Hp,FireRate,Accuracy,Range--
    {"PrussianLineInfantry",{"LineInfantry","Prussian",imgs.PrussianLineInfantry,150,6,7,1600}},
    {"PrussianLightInfantry",{"LightInfantry","Prussian",imgs.PrussianLightInfantry,125,6,3,2500}},
    {"PrussianArtillery",{"Artillery","Prussian",imgs.PrussianArtillery,50,16,5,4200}},

    {"FrenchLineInfantry",{"LineInfantry","French",imgs.FrenchLineInfantry,150,14,6,2000}},
    {"FrenchLightInfantry",{"LightInfantry","French",imgs.FrenchLightInfantry,125,14,3,2750}},
    {"FrenchArtillery",{"Artillery","French",imgs.FrenchArtillery,50,16,5,4200}},
}

function spawnUnits.CreateUnit(unitType,team,pos)
    local newUnit
    for i=1,#spawnUnits.stats,1 do
        if spawnUnits.stats[i][1]==unitType then--iName,iType,iTeam,iImgs,iPos,iHp,iFireRate,iAccuracy,iRange
            if team=="Prussian" then
                local newStats = spawnUnits.stats[i][2]
                prussianUnits=prussianUnits+1
                newUnit=unit.New(unitType..tostring(prussianUnits),newStats[1],newStats[2],newStats[3],pos,newStats[4],newStats[5],newStats[6],newStats[7])
            elseif team=="French" then
                local newStats = spawnUnits.stats[i][2]
                frenchUnits=frenchUnits+1
                newUnit = unit.New(unitType..tostring(frenchUnits),newStats[1],newStats[2],newStats[3],pos,newStats[4],newStats[5],newStats[6],newStats[7])
            end
        end
    end


    return newUnit
end

return spawnUnits