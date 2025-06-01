
MapEditor = {}

uiClass = require("../Interface")
Assets = require("../LoadAssets")

MapEditor.CurrentMap = {}
MapEditor.CurrentBrush = "ROD"

function MapEditor.OpenMenu()
    width = 15
    height = 15
    row = {}
    for i=1,width,1 do table.insert(row,"GRS") end
    for i=1,height,1 do table.insert(MapEditor.CurrentMap,row) end
    brushUI = uiClass.New("BrushImage",{0,0,0,1},"Brush: Road",{1,1,1,1},6,{1,1,1,1},{25,25},{100,100},"Change Brush",Assets.Map_Editor[5][2])
    enableBrushUI = uiClass.New("BrushEnable",{0,0,0,1},"Enable Brush",{1,1,1,1},6,{1,1,1,1},{150,25},{100,100},"Enable Brush")
    newUI={brushUI,enableBrushUI}
    return {newUI,MapEditor.CurrentMap}
end

return MapEditor