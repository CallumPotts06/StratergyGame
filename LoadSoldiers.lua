
soldiers = {}

--SQUAD SIZES: 2x+8, y+8

function soldiers.CreateSquad(img,dress_width,dress_height,flagImg,flagBool)
    local dimensionsx,dimensionsy = img:getPixelDimensions()    
    local soldier_width = dimensionsx
    local soldier_height = dimensionsy
    local canvas_width = (soldier_width*2)+8
    local canvas_height = soldier_height+8

    if flagBool then
        dimensionsx,dimensionsy = flagImg:getPixelDimensions()    
        canvas_width = (dimensionsx*2)+8
        canvas_height = dimensionsy+8
        tempCanavas = love.graphics.newCanvas(canvas_width, canvas_height)
        love.graphics.setCanvas(tempCanavas)
        love.graphics.draw(img,8,49)
        love.graphics.draw(img,dress_width+8,49)
        love.graphics.draw(flagImg,0,8)
        love.graphics.draw(img,dress_width,8+49)
        love.graphics.setCanvas()
    else
        tempCanavas = love.graphics.newCanvas(canvas_width, canvas_height)
        love.graphics.setCanvas(tempCanavas)
        love.graphics.draw(img,8,0)
        love.graphics.draw(img,dress_width+8,0)
        love.graphics.draw(img,0,8)
        love.graphics.draw(img,dress_width,8)
        love.graphics.setCanvas()
    end

    newSquad = love.graphics.newImage(tempCanavas:newImageData())

    return newSquad
end


function soldiers.LoadSoldierGroup(fileDir)
    local newGroup = {
        {"Card",love.graphics.newImage(fileDir.."/Card.png")},
        {"Flag",love.graphics.newImage(fileDir.."/Flag.png")},

        {"North_Aiming",love.graphics.newImage(fileDir.."/North/Aiming.png")},
        {"North_Idle",love.graphics.newImage(fileDir.."/North/Idle.png")},
        {"North_Marching1",love.graphics.newImage(fileDir.."/North/Marching1.png")},
        {"North_Marching2",love.graphics.newImage(fileDir.."/North/Marching2.png")},
        {"North_Crouching",love.graphics.newImage(fileDir.."/North/Crouching.png")},
        {"North_CrouchingAiming",love.graphics.newImage(fileDir.."/North/CrouchingAiming.png")},
        {"North_FlagBearer",love.graphics.newImage(fileDir.."/North/FlagBearer.png")},

        {"South_Aiming",love.graphics.newImage(fileDir.."/South/Aiming.png")},
        {"South_Idle",love.graphics.newImage(fileDir.."/South/Idle.png")},
        {"South_Marching1",love.graphics.newImage(fileDir.."/South/Marching1.png")},
        {"South_Marching2",love.graphics.newImage(fileDir.."/South/Marching2.png")},
        {"South_Crouching",love.graphics.newImage(fileDir.."/South/Crouching.png")},
        {"South_CrouchingAiming",love.graphics.newImage(fileDir.."/South/CrouchingAiming.png")},
        {"South_FlagBearer",love.graphics.newImage(fileDir.."/South/FlagBearer.png")},

        {"East_Aiming",love.graphics.newImage(fileDir.."/East/Aiming.png")},
        {"East_Idle",love.graphics.newImage(fileDir.."/East/Idle.png")},
        {"East_Marching1",love.graphics.newImage(fileDir.."/East/Marching1.png")},
        {"East_Marching2",love.graphics.newImage(fileDir.."/East/Marching2.png")},
        {"East_Crouching",love.graphics.newImage(fileDir.."/East/Crouching.png")},
        {"East_CrouchingAiming",love.graphics.newImage(fileDir.."/East/CrouchingAiming.png")},
        {"East_FlagBearer",love.graphics.newImage(fileDir.."/East/FlagBearer.png")},

        {"West_Aiming",love.graphics.newImage(fileDir.."/West/Aiming.png")},
        {"West_Idle",love.graphics.newImage(fileDir.."/West/Idle.png")},
        {"West_Marching1",love.graphics.newImage(fileDir.."/West/Marching1.png")},
        {"West_Marching2",love.graphics.newImage(fileDir.."/West/Marching2.png")},
        {"West_Crouching",love.graphics.newImage(fileDir.."/West/Crouching.png")},
        {"West_CrouchingAiming",love.graphics.newImage(fileDir.."/West/CrouchingAiming.png")},
        {"West_FlagBearer",love.graphics.newImage(fileDir.."/West/FlagBearer.png")},
    }
    
    local anims={"Aiming","Idle","Marching1","Marching2"}
    local facings={"North","South","East","West"}

    local squads = {}

    local dimensionsx,dimensionsy = newGroup[3][2]:getPixelDimensions()    
    local dress_width = dimensionsx
    local dress_height = dimensionsy

    for i1 = 1,#anims,1 do
        for i2 = 1,#facings,1 do
            for i3=1,#newGroup,1 do
                if newGroup[i3][1]==facings[i2].."_"..anims[i1] then
                    squad = soldiers.CreateSquad(newGroup[i3][2],dress_width,dress_height,false,false)
                    table.insert(squads,{facings[i2].."_"..anims[i1].."_Squad",squad})
                    break
                end
            end
        end
    end

    

    for i1=1,#facings,1 do
        local idleIMG = false
        local flagIMG = false
        for i2=1,#newGroup,1 do
            if newGroup[i2][1]==facings[i1].."_Idle" then
                idleIMG = newGroup[i2][2]
            elseif newGroup[i2][1]==facings[i1].."_FlagBearer" then
                flagIMG = newGroup[i2][2]
            end
        end
        if idleIMG then
            squad = soldiers.CreateSquad(idleIMG,dress_width,dress_height,flagIMG,true)
            table.insert(squads,{facings[i1].."_FlagBearer_Squad",squad})
        end
    end


    

    for i=1,#squads,1 do table.insert(newGroup,squads[i]) end

    return newGroup
end

soldiers.GermanLineInfantry = soldiers.LoadSoldierGroup("Images/GermanTroops/LineInfantry")
soldiers.FrenchLineInfantry = soldiers.LoadSoldierGroup("Images/FrenchTroops/LineInfantry")


return soldiers