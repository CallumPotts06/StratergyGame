
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
    {"FRM",love.graphics.newImage("Images/Maps/Editor/Farm.png")},
}

--TEMPERATE MAP TILES--
Assets.MapTemperateOther = {
    {"GRS_ALL",love.graphics.newImage("Images/Maps/Temperate/Grass.png")},
    {"FRM_ALL",love.graphics.newImage("Images/Maps/Temperate/Farm.png")},
    {"URB_ALL",love.graphics.newImage("Images/Maps/Temperate/Urban.png")},
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
    {"TRP_ALL",love.graphics.newImage("Images/Maps/Temperate/Turnpike_ALL.png")},

    {"TRP_S__",love.graphics.newImage("Images/Maps/Temperate/Turnpike_S.png")},
    {"TRP_E__",love.graphics.newImage("Images/Maps/Temperate/Turnpike_E.png")},

    {"TRP_NE_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_NE.png")},
    {"TRP_SE_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_SE.png")},
    {"TRP_NW_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_NW.png")},
    {"TRP_SW_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_SW.png")},

    {"TRP_AN_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_AN.png")},
    {"TRP_AS_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_AS.png")},
    {"TRP_AE_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_AE.png")},
    {"TRP_AW_",love.graphics.newImage("Images/Maps/Temperate/Turnpike_AW.png")},
}
Assets.MapTemperateRoad = {
    {"ROD_ALL",love.graphics.newImage("Images/Maps/Temperate/Road_ALL.png")},

    {"ROD_S__",love.graphics.newImage("Images/Maps/Temperate/Road_S.png")},
    {"ROD_E__",love.graphics.newImage("Images/Maps/Temperate/Road_E.png")},

    {"ROD_NE_",love.graphics.newImage("Images/Maps/Temperate/Road_NE.png")},
    {"ROD_SE_",love.graphics.newImage("Images/Maps/Temperate/Road_SE.png")},
    {"ROD_NW_",love.graphics.newImage("Images/Maps/Temperate/Road_NW.png")},
    {"ROD_SW_",love.graphics.newImage("Images/Maps/Temperate/Road_SW.png")},

    {"ROD_AN_",love.graphics.newImage("Images/Maps/Temperate/Road_AN.png")},
    {"ROD_AS_",love.graphics.newImage("Images/Maps/Temperate/Road_AS.png")},
    {"ROD_AE_",love.graphics.newImage("Images/Maps/Temperate/Road_AE.png")},
    {"ROD_AW_",love.graphics.newImage("Images/Maps/Temperate/Road_AW.png")},
}
Assets.MapTemperateStream = {
    {"STR_S__",love.graphics.newImage("Images/Maps/Temperate/Stream_S.png")},
    {"STR_E__",love.graphics.newImage("Images/Maps/Temperate/Stream_E.png")},

    {"STR_NE_",love.graphics.newImage("Images/Maps/Temperate/Stream_NE.png")},
    {"STR_SE_",love.graphics.newImage("Images/Maps/Temperate/Stream_SE.png")},
    {"STR_NW_",love.graphics.newImage("Images/Maps/Temperate/Stream_NW.png")},
    {"STR_SW_",love.graphics.newImage("Images/Maps/Temperate/Stream_SW.png")},
}
Assets.MapTemperateBridges = {
    {"FRD_S__",love.graphics.newImage("Images/Maps/Temperate/Ford_S.png")},
    {"FRD_E__",love.graphics.newImage("Images/Maps/Temperate/Ford_E.png")},

    {"BRD_S__",love.graphics.newImage("Images/Maps/Temperate/Bridge_S.png")},
    {"BRD_E__",love.graphics.newImage("Images/Maps/Temperate/Bridge_E.png")},
}
Assets.MapTemperateDetails = {
    {"Tree1",love.graphics.newImage("Images/Maps/Details/Tree1.png")},
    {"Forest_All",love.graphics.newImage("Images/Maps/Details/Forest_All_1.png")},
    {"Forest_ANE",love.graphics.newImage("Images/Maps/Details/Forest_All_1.png")},
    {"Forest_ANW",love.graphics.newImage("Images/Maps/Details/Forest_All_1.png")},
    {"Forest_ASE",love.graphics.newImage("Images/Maps/Details/Forest_All_1.png")},
    {"Forest_ASW",love.graphics.newImage("Images/Maps/Details/Forest_All_1.png")},
    {"Forest_NE_",love.graphics.newImage("Images/Maps/Details/Forest_NE.png")},
    {"Forest_NW_",love.graphics.newImage("Images/Maps/Details/Forest_NW.png")},
    {"Forest_SE_",love.graphics.newImage("Images/Maps/Details/Forest_SE.png")},
    {"Forest_SW_",love.graphics.newImage("Images/Maps/Details/Forest_SW.png")},
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
    {"Farm","FRM"},
}

return Assets