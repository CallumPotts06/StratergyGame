
interface = {}
interface.__index = interface

--[[
TYPE - CLASS
Interface object allows The Main.lua to quickly create simple GUI objects
An interface object could be a text box or an image, and is specified on
instantiation of the object.
]]--

function interface.New(initName,initColour,initText,initTextColour,initBorder,initBorderColour,initPos,initSize,initOnClick,initImg,initImgScale)
    local newGUI = {}

    -- ADMIN --
    newGUI.Name = initName

    -- STYLE --
    newGUI.Image = initImg
    newGUI.ImageScale = initImgScale
    newGUI.Colour = initColour
    
    newGUI.Font = love.graphics.newFont("Fonts/georgiab.ttf",(math.floor(initSize[1]/(string.len(initText)+6))*1.8)+1)
    newGUI.Text = initText
    newGUI.TextColour = initTextColour
    newGUI.TextChange = false

    newGUI.BorderSize = initBorder
    newGUI.BorderColour = initBorderColour

    -- STATS --
    newGUI.Position = initPos
    newGUI.Size = initSize
    newGUI.OnClick = initOnClick

    setmetatable(newGUI, interface)
    return newGUI
end

function interface:CheckClick(mousePos)
    if (mousePos[1]>=self.Position[1]) and (mousePos[1]<=(self.Position[1]+self.Size[1])) then
        if (mousePos[2]>=self.Position[2]) and (mousePos[2]<=(self.Position[2]+self.Size[2])) then
            return self.OnClick
        end
    end
    return false
end

return interface