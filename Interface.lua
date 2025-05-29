
interface = {}

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
    
    newGUI.Text = initText
    newGUI.TextColour = initTextColour

    newGUI.BorderSize = initBorder
    newGUI.BorderColour = initBorderColour

    -- STATS --
    newGUI.Position = initPos
    newGUI.Size = initSize
end

return interface