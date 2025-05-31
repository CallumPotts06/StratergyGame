
interface = {}
interface.__index = interface

--[[
TYPE - CLASS
Interface object allows The Main.lua to quickly create simple GUI objects
An interface object could be a text box or an image, and is specified on
instantiation of the object.
]]--

function interface.New(initName,initColour,initText,initTextColour,initBorder,initBorderColour,initPos,initSize)
    local newGUI = {}

    -- ADMIN --
    newGUI.Name = initName

    -- STYLE --
    newGUI.Image = initImg
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

    setmetatable(newGUI, interface)
    return newGUI
end

return interface