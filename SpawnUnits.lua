
spawnUnits = {}

unit = require("Unit")
imgs = require("LoadSoldiers")

local prussianUnits = 0
local frenchUnits =0

spawnUnits.stats = {
    --Type,Team,Imgs,Hp,FireRate,Accuracy--
    {"PrussianLineInfantry",{"LineInfantry","Prussian",imgs.PrussianLineInfantry,100,6,12}},
    {"PrussianLightInfantry",{"LightInfantry","Prussian",imgs.PrussianLightInfantry,100,6,9}},
    {"PrussianArtillery",{"Artillery","Prussian",imgs.PrussianArtillery,75,15,4}},

    {"FrenchLineInfantry",{"LineInfantry","French",imgs.FrenchLineInfantry,100,12,6}},
    {"FrenchLightInfantry",{"LightInfantry","French",imgs.FrenchLightInfantry,100,12,4}},
    {"FrenchArtillery",{"Artillery","French",imgs.FrenchArtillery,75,15,4}},
}

function spawnUnits.CreateUnit(unitType,team,pos)
    local newUnit
    for i=1,#spawnUnits.stats,1 do
        if spawnUnits.stats[i][1]==unitType then--iName,iType,iTeam,iImgs,iPos,iHp,iFireRate,iAccuracy
            if team=="Prussian" then
                prussianUnits=prussianUnits+1
                newUnit=unit.New(unitType..tostring(prussianUnits),spawnUnits.stats[i][2][1],spawnUnits.stats[i][2][2],spawnUnits.stats[i][2][3],pos,spawnUnits.stats[i][2][4],spawnUnits.stats[i][2][5],spawnUnits.stats[i][2][6])
            elseif team=="French" then
                frenchUnits=frenchUnits+1
                newUnit = unit.New(unitType..tostring(frenchUnits),spawnUnits.stats[i][2][1],spawnUnits.stats[i][2][2],spawnUnits.stats[i][2][3],pos,spawnUnits.stats[i][2][4],spawnUnits.stats[i][2][5],spawnUnits.stats[i][2][6])
            end
        end
    end


    return newUnit
end

return spawnUnits