
Network = {}

Unit = require("Unit")
enet = require("enet")
LoadSoldiers = require("LoadSoldiers")
SpawnUnit = require("SpawnUnits")
local host
local peer
Network.Hosting = false

function Network.StartHost()
    Network.Hosting=true
    host = enet.host_create("0.0.0.0"..":1870")
    return "success"
end

function Network.ConnectToHost(IP)
    Network.Hosting=true
    host = enet.host_create()
    server = host:connect(IP..":1870")
    event = false
    while not event do
        event = host:service(200)
    end
    peer = event.peer
    return "success"
end

function Network.InboundEvents()
    local event = host:service()--ms
    
    if event then
        if event.type == "receive" then
            return {"received",event.data}
        elseif event.type == "connect" then
            peer = event.peer
            return {"connected",event.peer}
        elseif event.type == "disconnect" then
            peer = nil
            return {"disconnected",event.peer}
        end
    end
end

function Network.SendMessage(msg)
    event = host:service(10)
    if peer then
        peer:send(msg)
    end
end

function Network.CreateMessage(units,updates,moves,currentTeam)
    local netmsg = ""
    if currentTeam=="Prussian" then netmsg="PRUSSIAN_UNIT_UPADATES:" end
    if currentTeam=="French" then netmsg="FRENCH_UNIT_UPADATES:" end

    for i=1,#updates,1 do
        local str = ""
        if type(updates[i])=="string" then
            netmsg=netmsg..updates[i]..";"
        else

            --iName,iType,iTeam,iImgs,iPos,iHp,iFireRate,iAccuracy
            str="NewUnit:"..updates[i][2].Name..","..updates[i][2].Type..","..updates[i][2].Team..","
            srt=str..updates[i][2].Team..updates[i][2].Type..","..tostring(updates[i][2].Position[1])..","
            str=str..tostring(updates[i][2].Position[2])..","..tostring(updates[i][2].Health)..","
            str=str..tostring(updates[i][2].FireRate)..","..tostring(updates[i][2].Accuracy)..";"
            netmsg=netmsg..str
        end
    end

    if currentTeam=="Prussian" then netmsg=netmsg.."PRUSSIAN_UNIT_MOVES:" end
    if currentTeam=="French" then netmsg=netmsg.."FRENCH_UNIT_MOVES:" end

    if currentTeam=="Prussian" then netmsg=netmsg.."PRUSSIAN_UNIT_STATS:" end
    if currentTeam=="French" then netmsg=netmsg.."FRENCH_UNIT_STATS:" end

    for i=1,#units,1 do--iPos,iHp
        str=units[i].Name..":"..tostring(units[i].Position[1])..","..tostring(units[i].Position[2])..","
        str=str..tostring(units[i].Orientation)..","..tostring(units[i].Health)..","..units[i].Formation..","..units[i].OpenOrder..";"
        netmsg=netmsg..str
    end

    netmsg=netmsg.."END_MESSAGE"

    return netmsg
end

function Network.DecodeMessage(message)
    local data = {
        team = nil,
        updates = {},
        moves = {},
        units = {}
    }

    -- Identify team
    if message:find("PRUSSIAN_UNIT_UPADATES:") then
        data.team = "Prussian"
    elseif message:find("FRENCH_UNIT_UPADATES:") then
        data.team = "French"
    end

    -- Extract sections
    local updates_section = message:match("UNIT_UPADATES:(.-)UNIT_MOVES:")
    local moves_section = message:match("UNIT_MOVES:(.-)UNIT_STATS:")
    local stats_section = message:match("UNIT_STATS:(.-)END_MESSAGE")

    -- Decode updates
    for entry in updates_section:gmatch("([^;]+);") do
        if entry:sub(1, 5) == "Dead:" then
            table.insert(data.updates, entry)
        elseif entry:sub(1, 8) == "NewUnit:" then
            local fields = {}
            for field in entry:sub(9):gmatch("([^,]+)") do
                table.insert(fields, field)
            end
            table.insert(data.updates, {
                Name = fields[1],
                Type = fields[2],
                Team = fields[3],
                Img = fields[4],
                Position = { tonumber(fields[5]), tonumber(fields[6]) },
                Health = tonumber(fields[5]),
                FireRate = tonumber(fields[6]),
                Accuracy = tonumber(fields[7]),
            })
        end
    end

    -- Decode moves
    for move in moves_section:gmatch("Move%d+:Unit=([^;]+);") do
        local parts = {}
        for part in move:gmatch("([^,{}]+)") do
            table.insert(parts, part)
        end
        local path = {}
        for i = 4, #parts do
            table.insert(path, tonumber(parts[i]))
        end
        table.insert(data.moves, {
            Name = parts[1],
            Type = parts[2],
            Index = tonumber(parts[3]),
            Path = path
        })
    end

    -- Decode unit stats
    for unit in stats_section:gmatch("([^;]+);") do
    local name, x, y, theta, hp, formation, order = unit:match("([^:]+):([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")
    table.insert(data.units, {
        Name = name,
        Position = { tonumber(x), tonumber(y) },
        Orientation = tonumber(theta),
        Health = tonumber(hp),
        Formation = formation,
        OpenOrder = order
        })
    end



    return data
end

function Network.ApplyUpdate(units,updates,moves,enemyTeam,allMoves)
    local team = enemyTeam
    local newMoves = allMoves

    for i=1,#units,1 do
        for i2=1,#team,1 do
            if team[i2].Name==units[i].Name then
                team[i2].Position=units[i].Position
                team[i2].Orientation=units[i].Orientation
                team[i2].Health=units[i].Health
                team[i2].Formation=units[i].Formation
                team[i2].OpenOrder=units[i].OpenOrder
                break
            end
        end
    end

    for i=1,#updates,1 do
        if type(updates[i])=="string" then
            for i2=1,#team,1 do
                if team[i2].Name==string.sub(updates[i],6,#updates[i]) then
                    team[i2].IsDead=true
                    team[i2].Health=0
                end
            end
        else
            local imgs
            if updates[i].Team..updates[i].Type=="PrussianLineInfantry" then imgs=LoadSoldiers.PrussianLineInfantry end
            if updates[i].Team..updates[i].Type=="PrussianLightInfantry" then imgs=LoadSoldiers.PrussianLightInfantry end
            if updates[i].Team..updates[i].Type=="PrussianArtillery" then imgs=LoadSoldiers.PrussianArtillery end

            if updates[i].Team..updates[i].Type=="FrenchLineInfantry" then imgs=LoadSoldiers.FrenchLineInfantry end
            if updates[i].Team..updates[i].Type=="FrenchLightInfantry" then imgs=LoadSoldiers.FrenchLightInfantry end
            if updates[i].Team..updates[i].Type=="FrenchArtillery" then imgs=LoadSoldiers.FrenchArtillery end

    
            local newUnit = Unit.New(
                updates[i].Name,
                updates[i].Type,
                updates[i].Team,
                imgs,
                updates[i].Position,
                updates[i].Health,
                updates[i].FireRate,
                updates[i].Accuracy
            )

            table.insert(team,newUnit)
        end
    end


    return {team,nil}
end



return Network