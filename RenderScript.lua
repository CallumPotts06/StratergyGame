
renderer = {}

Assets = require("LoadAssets")

--[[
TYPE : LIBRARY
RenderScript will render everything in the game. As to simplify and neaten up main.lua
]]--


--// RENDERS ALL CURRENT INTERFACE OBJECTS //--
function renderer.RenderUI(objects,zoom)
    for i=1,#objects,1 do
        local object = objects[i]
        local x = object.Position[1]
        local y = object.Position[2]
        local x_size = object.Size[1]
        local y_size = object.Size[2]
        local border = object.BorderSize
        local z = 1

        -- Draw Border
        love.graphics.setColor(object.BorderColour[1],object.BorderColour[2],object.BorderColour[3],object.BorderColour[4])
        love.graphics.rectangle("fill",(x-border)*z,(y-border)*z,x_size+(2*border),y_size+(2*border))

        -- Draw Background
        love.graphics.setColor(object.Colour[1],object.Colour[2],object.Colour[3],object.Colour[4])
        love.graphics.rectangle("fill",x*z,y*z,x_size,y_size)
        
        --IMG
        if not (object.Image==nil) then
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(object.Image,object.Position[1],object.Position[2],0,object.ImageScale,object.ImageScale)
        end

        --TXT
        if object.TextChange then 
            object.TextChange = false
            object.Font = love.graphics.newFont("Fonts/georgiab.ttf",(math.floor(x_size/(string.len(object.Text)+6))*1.8)+1)
        end
        love.graphics.setFont(object.Font)
        love.graphics.setColor(object.TextColour[1],object.TextColour[2],object.TextColour[3],object.TextColour[4])
        love.graphics.print(object.Text, object.Position[1]+6, object.Position[2]+6)

        love.graphics.setColor(1,1,1,1)
    end
end

function DrawTileIMG(terrain,tile,x,y,zoom)
    for i=1,#terrain,1 do
        if terrain[i][1]==tile then 
            currentImg=terrain[i][2] 
            love.graphics.draw(currentImg,(((x-1)*200)-camPos[1])*zoom,(((y-1)*200)-camPos[2])*zoom,0,zoom,zoom)
            currentImg=false
            break
        end
    end
end
function DrawDetailIMG(list,tile,x,y,zoom)
    for i=1,#list,1 do
        if list[i][1]==tile then 
            currentImg=list[i][2]
            love.graphics.draw(currentImg,(((x-1)*200)-camPos[1])*zoom,(((y-1)*200)-camPos[2])*zoom,0,zoom/2,zoom/2)
            currentImg=false
            break
        end
    end
end

function renderer.RenderMap(map,mode,zoom)
    love.graphics.setBackgroundColor(0,0,0,0)
    if mode=="Editor" then
        for y=1,#map,1 do
            for x=1,#map[1],1 do
                local tile = map[y][x]
                local currentImg = false
                for i=1,#Assets.Map_Editor,1 do
                    if Assets.Map_Editor[i][1]==tile then 
                        currentImg=Assets.Map_Editor[i][2] 
                        love.graphics.draw(currentImg,(((x-1)*200)-camPos[1])*zoom,(((y-1)*200)-camPos[2])*zoom,0,zoom*2,zoom*2)
                        currentImg=false
                        break
                    end
                end
            end
        end
    elseif  mode=="Temperate" then
         for y=1,#map,1 do
            for x=1,#map[1],1 do
                local tile = map[y][x]
                local code=string.sub(tile,1,3)
                if (code=="GRS")or(code=="URB")or(code=="CRN")or(code=="WHE") then
                    DrawTileIMG(Assets.MapTemperateOther,tile,x,y,zoom)
                elseif code=="FST" then
                    DrawTileIMG(Assets.MapTemperateForest,tile,x,y,zoom)
                elseif code=="SWP" then
                    DrawTileIMG(Assets.MapTemperateSwamp,tile,x,y,zoom)
                elseif code=="TRP" then
                    DrawTileIMG(Assets.MapTemperateTurnpike,tile,x,y,zoom)
                elseif code=="ROD" then
                    DrawTileIMG(Assets.MapTemperateRoad,tile,x,y,zoom)
                elseif code=="STR" then
                    DrawTileIMG(Assets.MapTemperateStream,tile,x,y,zoom)
                elseif (code=="FRD")or(code=="BRD") then
                    DrawTileIMG(Assets.MapTemperateBridges,tile,x,y,zoom)
                end
            end
        end
    end 
end

function renderer.RenderDetails(mapDetails,mode,zoom)
    love.graphics.setBackgroundColor(0,0,0,0)
    if  mode=="Temperate" then
        for y=1,#mapDetails,1 do
            for x=1,#mapDetails[1],1 do
                local tile = mapDetails[y][x]
                local currentImg = false
                if (string.sub(tile,1,6)=="Forest") then
                    DrawDetailIMG(Assets.MapTemperateForestDetails,mapDetails[y][x],x,y,zoom)
                elseif (string.sub(tile,1,5)=="Swamp") then
                    DrawDetailIMG(Assets.MapTemperateSwampDetails,mapDetails[y][x],x,y,zoom)
                elseif (string.sub(tile,1,4)=="Corn")or(string.sub(tile,1,5)=="Wheat") then
                    DrawDetailIMG(Assets.MapTemperateOtherDetails,mapDetails[y][x],x,y,zoom)
                elseif (string.sub(tile,1,2)=="TY") or (string.sub(tile,1,2)=="SP") then
                    DrawDetailIMG(Assets.MapTemperateHouseDetails,mapDetails[y][x],x,y,zoom)
                end
            end
        end
    end
end

return renderer