
renderer = {}

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
        local z = zoom

        -- Draw Border
        love.graphics.setColor(object.BorderColour[1],object.BorderColour[2],object.BorderColour[3],object.BorderColour[4])
        love.graphics.rectangle("fill",(x-border)*z,(y-border)*z,x_size+(2*border),y_size+(2*border))

        -- Draw Background
        love.graphics.setColor(object.Colour[1],object.Colour[2],object.Colour[3],object.Colour[4])
        love.graphics.rectangle("fill",x*z,y*z,x_size,y_size)
        --IMG

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

return renderer