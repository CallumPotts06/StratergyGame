
MapEditor = {}

uiClass = require("../Interface")
Assets = require("../LoadAssets")

MapEditor.CurrentMap = {}
MapEditor.CurrentBrush = "ROD"

function MapEditor.OpenMenu()
    width = 30
    height = 30
    MapEditor.CurrentMap = {}

    for y=1,height do
        local row = {}
        for x=1,width do
            table.insert(row, "GRS")
        end
        table.insert(MapEditor.CurrentMap, row)
    end
    brushUI = uiClass.New("BrushImage",{0,0,0,1},"Brush: Road",{1,1,1,1},6,{1,1,1,1},{25,25},{100,100},"Change Brush",Assets.Map_Editor[5][2])
    enableBrushUI = uiClass.New("BrushEnable",{0,0,0,1},"Enable Brush",{1,1,1,1},6,{1,1,1,1},{150,25},{100,100},"Enable Brush")
    changeRenderUI = uiClass.New("ChangeRender",{0,0,0,1},"Change Render",{1,1,1,1},6,{1,1,1,1},{275,25},{100,100},"Change Render")
    newUI={brushUI,enableBrushUI,changeRenderUI}
    return {newUI,MapEditor.CurrentMap}
end

function MapEditor.CheckAdjacentTiles(map,tilePos,tiletype)
    local n=true
    local s=true
    local e=true
    local w=true
    local ne=true
    local se=true
    local nw=true
    local sw=true

    local newType = "_ALL"
    
    --if ((tilePos[2]-1)>0) and ((tilePos[2]+1)<#map) and ((tilePos[1]-1)>0) and ((tilePos[1]+1)<#map[1]) then
        --if not (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)==tiletype) then n = false end
        --if not (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)==tiletype) then s = false end
        --if not (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)==tiletype) then w = false end
        --if not (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)==tiletype) then e = false end
        --if not (string.sub(map[tilePos[2]-1][tilePos[1]-1],1,3)==tiletype) then nw = false end
        --if not (string.sub(map[tilePos[2]+1][tilePos[1]+1],1,3)==tiletype) then se = false end
        --if not (string.sub(map[tilePos[2]-1][tilePos[1]+1],1,3)==tiletype) then ne = false end
        --if not (string.sub(map[tilePos[2]+1][tilePos[1]-1],1,3)==tiletype) then sw = false end
    --end

    if ((tilePos[2]-1)>0) and ((tilePos[2]+1)<#map) then
        if not (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)==tiletype) then n = false end
        if not (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)==tiletype) then s = false end
        if ((tilePos[1]-1)>0) and ((tilePos[1]+1)<#map[1]) then
            if not (string.sub(map[tilePos[2]-1][tilePos[1]-1],1,3)==tiletype) then nw = false end
            if not (string.sub(map[tilePos[2]+1][tilePos[1]+1],1,3)==tiletype) then se = false end
            if not (string.sub(map[tilePos[2]-1][tilePos[1]+1],1,3)==tiletype) then ne = false end
            if not (string.sub(map[tilePos[2]+1][tilePos[1]-1],1,3)==tiletype) then sw = false end
        end
    end
    if ((tilePos[1]-1)>0) and ((tilePos[1]+1)<#map[1]) then
        if not (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)==tiletype) then w = false end
        if not (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)==tiletype) then e = false end
    end


    if (not n) and (s) and (e) and (w) then newType="_N__" end
    if (n) and (not s) and (e) and (w) then newType="_S__" end
    if (n) and (s) and (not e) and (w) then newType="_E__" end
    if (n) and (s) and (e) and (not w) then newType="_W__" end
    
    if (not n) and (s) and (not e) and (w) then newType="_NE_" end
    if (n) and (not s) and (not e) and (w) then newType="_SE_" end
    if (not n) and (s) and (e) and (not w) then newType="_NW_" end
    if (n) and (not s) and (e) and (not w) then newType="_SW_" end

    if (n) and (s) and (e) and (w) and (not ne) then newType="_ANE" end
    if (n) and (s) and (e) and (w) and (not nw) then newType="_ANW" end
    if (n) and (s) and (e) and (w) and (not se) then newType="_ASE" end
    if (n) and (s) and (e) and (w) and (not sw) then newType="_ASW" end
    return newType
end

function MapEditor.ConvertMap(convertTo)
    local newMap=MapEditor.CurrentMap
    if convertTo=="Game" then
        for y=1,#newMap,1 do
            for x=1,#newMap[1],1 do
                if string.sub(newMap[y][x],1,3)=="GRS" then --GRASS--
                    newMap[y][x]="GRS_ALL"
                elseif string.sub(newMap[y][x],1,3)=="FST" then--FOREST--
                    suffix = MapEditor.CheckAdjacentTiles(MapEditor.CurrentMap,{x,y},newMap[y][x])
                    newMap[y][x]=newMap[y][x]..suffix
                end
            end
        end
    else
        for y=1,#newMap,1 do
            for x=1,#newMap[1],1 do
                local str = string.sub(newMap[y][x],1,3)
                newMap[y][x]=str
            end
        end
    end
    return newMap
end

return MapEditor