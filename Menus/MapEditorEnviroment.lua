
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

function MapEditor.CheckAdjacentTiles_Terrain(map,tilePos,tiletype)
    local n=true
    local s=true
    local e=true
    local w=true
    local ne=true
    local se=true
    local nw=true
    local sw=true

    local newType = "_ALL"

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

function MapEditor.CheckAdjacentTiles_Road(map,tilePos,tiletype)
    local n=false
    local s=false
    local e=false
    local w=false

    local newType = "_ALL"

    if (tilePos[2]-1)<=0 then 
        n=true 
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="ROD") then s = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="TRP") then s = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="BRD") then s = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="FRD") then s = true end
    end
    if (tilePos[2]+1)>=#map then 
        s=true 
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="ROD") then n = true end
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="TRP") then n = true end
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="BRD") then n = true end
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="FRD") then n = true end
    end
    if (tilePos[1]-1)<=0 then 
        w=true 
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="ROD") then e = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="TRP") then e = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="BRD") then e = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="FRD") then e = true end
    end
    if (tilePos[1]+1)>=#map[1] then 
        e=true 
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="ROD") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="TRP") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="BRD") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="FRD") then w = true end
    end

    if ((tilePos[2]-1)>0) and ((tilePos[2]+1)<#map) then
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="ROD") then n = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="ROD") then s = true end
    end
    if ((tilePos[1]-1)>0) and ((tilePos[1]+1)<#map[1]) then
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="ROD") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="ROD") then e = true end
    end

    if ((tilePos[2]-1)>0) and ((tilePos[2]+1)<#map) then
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="TRP") then n = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="TRP") then s = true end
    end
    if ((tilePos[1]-1)>0) and ((tilePos[1]+1)<#map[1]) then
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="TRP") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="TRP") then e = true end
    end

    if ((tilePos[2]-1)>0) and ((tilePos[2]+1)<#map) then
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="BRD") then n = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="BRD") then s = true end
    end
    if ((tilePos[1]-1)>0) and ((tilePos[1]+1)<#map[1]) then
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="BRD") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="BRD") then e = true end
    end

    if ((tilePos[2]-1)>0) and ((tilePos[2]+1)<#map) then
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="FRD") then n = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="FRD") then s = true end
    end
    if ((tilePos[1]-1)>0) and ((tilePos[1]+1)<#map[1]) then
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="FRD") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="FRD") then e = true end
    end


    if (n) and (s) and (not e) and (not w) then newType="_S__" end
    if (not n) and (not s) and (e) and (w) then newType="_E__" end
    
    if (n) and (not s) and (e) and (not w) then newType="_NE_" end
    if (not n) and (s) and (e) and (not w) then newType="_SE_" end
    if (not n) and (s) and (not e) and (w) then newType="_SW_" end
    if (n) and (not s) and (not e) and (w) then newType="_NW_" end

    if (not n) and (s) and (e) and (w) then newType="_AN_" end
    if (n) and (not s) and (e) and (w) then newType="_AS_" end
    if (n) and (s) and (not e) and (w) then newType="_AE_" end
    if (n) and (s) and (e) and (not w) then newType="_AW_" end

    if (n) and (s) and (e) and (w) then newType="_ALL" end
    return newType
end

function MapEditor.CheckAdjacentTiles_Stream(map,tilePos,tiletype)
    local n=false
    local s=false
    local e=false
    local w=false

    local newType = "_S__"

    if (tilePos[2]-1)<=0 then 
        n=true 
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="STR") then s = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="BRD") then s = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="FRD") then s = true end
    end
    if (tilePos[2]+1)>=#map then 
        s=true 
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="STR") then n = true end
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="BRD") then n = true end
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="FRD") then n = true end
    end
    if (tilePos[1]-1)<=0 then 
        w=true 
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="STR") then e = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="BRD") then e = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="FRD") then e = true end
    end
    if (tilePos[1]+1)>=#map[1] then 
        e=true 
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="STR") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="BRD") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="FRD") then w = true end
    end

    if ((tilePos[2]-1)>0) and ((tilePos[2]+1)<#map) then
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="STR") then n = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="STR") then s = true end
    end
    if ((tilePos[1]-1)>0) and ((tilePos[1]+1)<#map[1]) then
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="STR") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="STR") then e = true end
    end

    if ((tilePos[2]-1)>0) and ((tilePos[2]+1)<#map) then
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="FRD") then n = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="FRD") then s = true end
    end
    if ((tilePos[1]-1)>0) and ((tilePos[1]+1)<#map[1]) then
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="FRD") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="FRD") then e = true end
    end

    if ((tilePos[2]-1)>0) and ((tilePos[2]+1)<#map) then
        if (string.sub(map[tilePos[2]-1][tilePos[1]],1,3)=="BRD") then n = true end
        if (string.sub(map[tilePos[2]+1][tilePos[1]],1,3)=="BRD") then s = true end
    end
    if ((tilePos[1]-1)>0) and ((tilePos[1]+1)<#map[1]) then
        if (string.sub(map[tilePos[2]][tilePos[1]-1],1,3)=="BRD") then w = true end
        if (string.sub(map[tilePos[2]][tilePos[1]+1],1,3)=="BRD") then e = true end
    end


    if (n) and (s) and (not e) and (not w) then newType="_S__" end
    if (not n) and (not s) and (e) and (w) then newType="_E__" end
    
    if (n) and (not s) and (e) and (not w) then newType="_NE_" end
    if (not n) and (s) and (e) and (not w) then newType="_SE_" end
    if (not n) and (s) and (not e) and (w) then newType="_SW_" end
    if (n) and (not s) and (not e) and (w) then newType="_NW_" end

    if (n) and (s) and (e) and (w) then newType="_S__" end
    return newType
end

function MapEditor.ConvertMap(convertTo)
    local newMap=MapEditor.CurrentMap
    if convertTo=="Game" then
        for y=1,#newMap,1 do
            for x=1,#newMap[1],1 do
                local code=string.sub(newMap[y][x],1,3)
                if code=="GRS" then --GRASS--
                    newMap[y][x]="GRS_ALL"
                elseif (code=="FST")or(code=="SWP") then--FOREST AND SWAMP--
                    suffix = MapEditor.CheckAdjacentTiles_Terrain(MapEditor.CurrentMap,{x,y},newMap[y][x])
                    newMap[y][x]=newMap[y][x]..suffix
                elseif  (code=="TRP")or(code=="ROD") then--TURNPIKE AND ROAD--
                    suffix = MapEditor.CheckAdjacentTiles_Road(MapEditor.CurrentMap,{x,y},newMap[y][x])
                    newMap[y][x]=newMap[y][x]..suffix
                elseif  (code=="STR")or(code=="FRD")or(code=="BRD") then--STREAM, BRIDGE AND FORD--
                    suffix = MapEditor.CheckAdjacentTiles_Stream(MapEditor.CurrentMap,{x,y},newMap[y][x])
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