
spawnUnits = {}

unit = require("Unit")
imgs = require("LoadSoldiers")

local prussianUnits = 0
local frenchUnits =0

local stats = {
    --Type,Team,Imgs,Hp,FireRate,Accuracy--
    {"PrussianLineInfantry",{"LineInfantry","Prussian",imgs.PrussianLineInfantry,100,6,12}},
    {"PrussianLightInfantry",{"LightInfantry","Prussian",imgs.PrussianLightInfantry,100,6,9}},
    {"PrussianArtillery",{"Artillery","Prussian",imgs.PrussianArtillery,75,15,4}},

    {"FrenchLineInfantry",{"LineInfantry","French",imgs.FrenchLineInfantry,100,12,6}},
    {"FrenchLightInfantry",{"LightInfantry","French",imgs.FrenchLightInfantry,100,12,4}},
    {"FrenchArtillery",{"Artillery","French",imgs.FrenchArtillery,75,15,4}},
}

function spawnUnits.CreateUnit(unitType,team,pos)
    for i=1,#stats,1 do
        if if stats[i][1]==unitType then--iName,iType,iTeam,iImgs,iPos,iHp,iFireRate,iAccuracy
            if team=="Prussian" then
                prussianUnits=prussianUnits+1
                local newUnit = unit.New(
                    unitType..tostring(prussianUnits),stats[i][1],stats[i][2],stats[i][3],
                    stats[i][4],pos,stats[i][5],stats[i][6]
                )
            elseif team=="French" then
                frenchUnits=frenchUnits+1
                local newUnit = unit.New(
                    unitType..tostring(frenchUnits),stats[i][1],stats[i][2],stats[i][3],
                    stats[i][4],pos,stats[i][5],stats[i][6]
                )
            end
        end
    end


    return newUnit
end

return spawnUnits