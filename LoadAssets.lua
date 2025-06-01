
Assets = {}

Assets.Map_Editor = {
    {"GRS",love.graphics.newImage("Images/Maps/Editor/Grass.png")},
    {"FRD",love.graphics.newImage("Images/Maps/Editor/Ford.png")},
    {"FST",love.graphics.newImage("Images/Maps/Editor/Forest.png")},
    {"BRD",love.graphics.newImage("Images/Maps/Editor/Bridge.png")},
    {"ROD",love.graphics.newImage("Images/Maps/Editor/Road.png")},
    {"STR",love.graphics.newImage("Images/Maps/Editor/Stream.png")},
    {"SWP",love.graphics.newImage("Images/Maps/Editor/Swamp.png")},
    {"TRP",love.graphics.newImage("Images/Maps/Editor/Turnpike.png")},
    {"URB",love.graphics.newImage("Images/Maps/Editor/Urban.png")},
}

--TEMPERATE MAP TILES--
Assets.MapTemperateGrass = {
    {"GRS_ALL",love.graphics.newImage("Images/Maps/Temperate/Grass.png")},
}
Assets.MapTemperateForest = {
    {"FST_ALL",love.graphics.newImage("Images/Maps/Temperate/Forest_All.png")},

    {"FST_N__",love.graphics.newImage("Images/Maps/Temperate/Forest_N.png")},
    {"FST_S__",love.graphics.newImage("Images/Maps/Temperate/Forest_S.png")},
    {"FST_E__",love.graphics.newImage("Images/Maps/Temperate/Forest_E.png")},
    {"FST_W__",love.graphics.newImage("Images/Maps/Temperate/Forest_W.png")},

    {"FST_NE_",love.graphics.newImage("Images/Maps/Temperate/Forest_NE.png")},
    {"FST_SE_",love.graphics.newImage("Images/Maps/Temperate/Forest_SE.png")},
    {"FST_NW_",love.graphics.newImage("Images/Maps/Temperate/Forest_NW.png")},
    {"FST_SW_",love.graphics.newImage("Images/Maps/Temperate/Forest_SW.png")},

    {"FST_ANE",love.graphics.newImage("Images/Maps/Temperate/Forest_ANE.png")},
    {"FST_ASE",love.graphics.newImage("Images/Maps/Temperate/Forest_ASE.png")},
    {"FST_ANW",love.graphics.newImage("Images/Maps/Temperate/Forest_ANW.png")},
    {"FST_ASW",love.graphics.newImage("Images/Maps/Temperate/Forest_ASW.png")},
}
Assets.MapTemperateSwamp = {
    {"SWP_ALL",love.graphics.newImage("Images/Maps/Temperate/Swamp_All.png")},

    {"SWP_N__",love.graphics.newImage("Images/Maps/Temperate/Swamp_N.png")},
    {"SWP_S__",love.graphics.newImage("Images/Maps/Temperate/Swamp_S.png")},
    {"SWP_E__",love.graphics.newImage("Images/Maps/Temperate/Swamp_E.png")},
    {"SWP_W__",love.graphics.newImage("Images/Maps/Temperate/Swamp_W.png")},

    {"SWP_NE_",love.graphics.newImage("Images/Maps/Temperate/Swamp_NE.png")},
    {"SWP_SE_",love.graphics.newImage("Images/Maps/Temperate/Swamp_SE.png")},
    {"SWP_NW_",love.graphics.newImage("Images/Maps/Temperate/Swamp_NW.png")},
    {"SWP_SW_",love.graphics.newImage("Images/Maps/Temperate/Swamp_SW.png")},

    {"SWP_ANE",love.graphics.newImage("Images/Maps/Temperate/Swamp_ANE.png")},
    {"SWP_ASE",love.graphics.newImage("Images/Maps/Temperate/Swamp_ASE.png")},
    {"SWP_ANW",love.graphics.newImage("Images/Maps/Temperate/Swamp_ANW.png")},
    {"SWP_ASW",love.graphics.newImage("Images/Maps/Temperate/Swamp_ASW.png")},
}
Assets.MapTemperateTurnpike = {
    {"TRP_S__",love.graphics.newImage("Images/Maps/Temperate/Turnpike_S.png")},
    {"TRP_E__",love.graphics.newImage("Images/Maps/Temperate/Turnpike_E.png")},

    {"TRP_NE_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_NE.png")},
    {"TRP_SE_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_SE.png")},
    {"TRP_NW_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_NW.png")},
    {"TRP_SW_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_SW.png")},
}

Assets.Map_Editor_ID = {
    {"Grass","GRS"},
    {"Ford","FRD"},
    {"Forest","FST"},
    {"Bridge","BRD"},
    {"Road","ROD"},
    {"Stream","STR"},
    {"Swamp","SWP"},
    {"Turnpike","TRP"},
    {"Urban","URB"},
}

return Assets