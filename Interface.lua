
interface = {}
interface.__index = interface

--[[
TYPE - CLASS
Interface object allows The Main.lua to quickly create simple GUI objects
An interface object could be a text box or an image, and is specified on
instantiation of the object.
]]--

function interface.New(initName,initImg,initColour,initText,initTextColour,initBorder,initBorderColour,initPos,initSize)
    local newGUI = {}

    -- ADMIN --
    newGUI.Name = initName

    -- STYLE --
    newGUI.Image = initImg
    newGUI.Colour = initColour
    
    font = love.graphics.newFont("Fonts/georgiab.ttf", size, hinting, dpiscale )
    newGUI.Text = love.graphics.newText( font, textstring )
    newGUI.TextColour = initTextColour

    newGUI.BorderSize = initBorder
    newGUI.BorderColour = initBorderColour

    -- STATS --
    newGUI.Position = initPos
    newGUI.Size = initSize

    setmetatable(newGUI, interface)
    return newGUI
end

return interface