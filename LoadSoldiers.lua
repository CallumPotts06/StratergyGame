
soldiers = {}

--SQUAD SIZES: 2x+8, y+8

function soldiers.CreateSquad(img)
    local dimensionsx,dimensionsy = img:getPixelDimensions()    
    local soldier_width = dimensionsx
    local soldiers_height = dimensionsy
    local canvas_width = (soldier_width*2)+8
    local canvas_height = soldiers_height+8

    newSquad = love.graphics.newCanvas(width, height)
    love.graphics.setCanvas(newSquad)
        love.graphics.draw(img,8,0)
        love.graphics.draw(img,soldier_width+8,0)
        love.graphics.draw(img,8,8)
        love.graphics.draw(img,soldier_width+8,8)
    love.graphics.setCanvas()

    return newSquad
end


function soldiers.LoadSoldierGroup(fileDir)
    local newGroup = {
        {"Card",love.graphics.newImage(fileDir.."/Card.png")},

        {"North_Aiming",love.graphics.newImage(fileDir.."/North/Aiming.png")},
        {"North_Idle",love.graphics.newImage(fileDir.."/North/Idle.png")},
        {"North_Marching1",love.graphics.newImage(fileDir.."/North/Marching1.png")},
        {"North_Marching2",love.graphics.newImage(fileDir.."/North/Marching2.png")},
        {"North_Crouching",love.graphics.newImage(fileDir.."/North/Crouching.png")},
        {"North_CrouchingAiming",love.graphics.newImage(fileDir.."/North/CrouchingAiming.png")},

        {"South_Aiming",love.graphics.newImage(fileDir.."/South/Aiming.png")},
        {"South_Idle",love.graphics.newImage(fileDir.."/South/Idle.png")},
        {"South_Marching1",love.graphics.newImage(fileDir.."/South/Marching1.png")},
        {"South_Marching2",love.graphics.newImage(fileDir.."/South/Marching2.png")},
        {"South_Crouching",love.graphics.newImage(fileDir.."/South/Crouching.png")},
        {"South_CrouchingAiming",love.graphics.newImage(fileDir.."/South/CrouchingAiming.png")},

        {"East_Aiming",love.graphics.newImage(fileDir.."/East/Aiming.png")},
        {"East_Idle",love.graphics.newImage(fileDir.."/East/Idle.png")},
        {"East_Marching1",love.graphics.newImage(fileDir.."/East/Marching1.png")},
        {"East_Marching2",love.graphics.newImage(fileDir.."/East/Marching2.png")},
        {"East_Crouching",love.graphics.newImage(fileDir.."/East/Crouching.png")},
        {"East_CrouchingAiming",love.graphics.newImage(fileDir.."/East/CrouchingAiming.png")},

        {"West_Aiming",love.graphics.newImage(fileDir.."/West/Aiming.png")},
        {"West_Idle",love.graphics.newImage(fileDir.."/West/Idle.png")},
        {"West_Marching1",love.graphics.newImage(fileDir.."/West/Marching1.png")},
        {"West_Marching2",love.graphics.newImage(fileDir.."/West/Marching2.png")},
        {"West_Crouching",love.graphics.newImage(fileDir.."/West/Crouching.png")},
        {"West_CrouchingAiming",love.graphics.newImage(fileDir.."/West/CrouchingAiming.png")},
    }
    
    local anims={"Aiming","Idle","Marching1","Marching2"}
    local facings={"North","South","East","West"}

    local squads = {}

    for i1 = 1,#anims,1 do
        for i2 = 1,#facings,1 do
            for i3=1,#newGroup,1 do
                if newGroup[i3][1]==facings[i2].."_"..anims[i1] then
                    squad = soldiers.CreateSquad(newGroup[i3][2])
                    table.insert(squads,{facings[i2].."_"..anims[i1].."_Squad",squad})
                    break
                end
            end
        end
    end
    
    for i=1,#squads,1 do table.insert(newGroup,squads[i]) end

    return newGroup
end

soldiers.GermanLineInfantry = soldiers.LoadSoldierGroup("Images/GermanTroops/LineInfantry")

return soldiers