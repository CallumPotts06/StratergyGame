
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
    {"CRN",love.graphics.newImage("Images/Maps/Editor/Farm.png")},
    {"WHE",love.graphics.newImage("Images/Maps/Editor/Farm.png")},
}
Assets.Map_Details_Editor = {
    {"TY01",love.graphics.newImage("Images/Maps/Details/Ty01.png")},
    {"TY02",love.graphics.newImage("Images/Maps/Details/Ty02.png")},
    {"TY03",love.graphics.newImage("Images/Maps/Details/Ty03.png")},
    {"TY04",love.graphics.newImage("Images/Maps/Details/Ty04.png")},
    {"SPNA",love.graphics.newImage("Images/Maps/Details/SpawnA.png")},
    {"SPNB",love.graphics.newImage("Images/Maps/Details/SpawnB.png")},
}


--TEMPERATE MAP TILES--
Assets.MapTemperateOther = {
    {"GRS_ALL",love.graphics.newImage("Images/Maps/Temperate/Grass.png")},
    {"CRN_ALL",love.graphics.newImage("Images/Maps/Temperate/Farm.png")},
    {"WHE_ALL",love.graphics.newImage("Images/Maps/Temperate/Farm.png")},
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

--TEMPERATE MAP DETAILS--
Assets.MapTemperateForestDetails = {
    {"Tree1",love.graphics.newImage("Images/Maps/Details/Tree1.png")},
    {"Forest_ALL",love.graphics.newImage("Images/Maps/Details/Forest_ALL.png")},

    {"Forest_N__",love.graphics.newImage("Images/Maps/Details/Forest_ALL.png")},
    {"Forest_S__",love.graphics.newImage("Images/Maps/Details/Forest_ALL.png")},
    {"Forest_E__",love.graphics.newImage("Images/Maps/Details/Forest_ALL.png")},
    {"Forest_W__",love.graphics.newImage("Images/Maps/Details/Forest_ALL.png")},

    {"Forest_ANE",love.graphics.newImage("Images/Maps/Details/Forest_ANE.png")},
    {"Forest_ANW",love.graphics.newImage("Images/Maps/Details/Forest_ANW.png")},
    {"Forest_ASE",love.graphics.newImage("Images/Maps/Details/Forest_ASE.png")},
    {"Forest_ASW",love.graphics.newImage("Images/Maps/Details/Forest_ASW.png")},

    {"Forest_NE_",love.graphics.newImage("Images/Maps/Details/Forest_NE.png")},
    {"Forest_NW_",love.graphics.newImage("Images/Maps/Details/Forest_NW.png")},
    {"Forest_SE_",love.graphics.newImage("Images/Maps/Details/Forest_SE.png")},
    {"Forest_SW_",love.graphics.newImage("Images/Maps/Details/Forest_SW.png")},
}
Assets.MapTemperateSwampDetails = {
    {"Swamp_ALL",love.graphics.newImage("Images/Maps/Details/Forest_ALL.png")},

    {"Swamp_N__",love.graphics.newImage("Images/Maps/Details/Forest_ALL.png")},
    {"Swamp_S__",love.graphics.newImage("Images/Maps/Details/Forest_ALL.png")},
    {"Swamp_E__",love.graphics.newImage("Images/Maps/Details/Forest_ALL.png")},
    {"Swamp_W__",love.graphics.newImage("Images/Maps/Details/Forest_ALL.png")},

    {"Swamp_ANE",love.graphics.newImage("Images/Maps/Details/Forest_ANE.png")},
    {"Swamp_ANW",love.graphics.newImage("Images/Maps/Details/Forest_ANW.png")},
    {"Swamp_ASE",love.graphics.newImage("Images/Maps/Details/Forest_ASE.png")},
    {"Swamp_ASW",love.graphics.newImage("Images/Maps/Details/Forest_ASW.png")},

    {"Swamp_NE_",love.graphics.newImage("Images/Maps/Details/Forest_NE.png")},
    {"Swamp_NW_",love.graphics.newImage("Images/Maps/Details/Forest_NW.png")},
    {"Swamp_SE_",love.graphics.newImage("Images/Maps/Details/Forest_SE.png")},
    {"Swamp_SW_",love.graphics.newImage("Images/Maps/Details/Forest_SW.png")},
}
Assets.MapTemperateOtherDetails = {
    {"Corn_ALL",love.graphics.newImage("Images/Maps/Details/Cornfield.png")},
    {"Wheat_ALL",love.graphics.newImage("Images/Maps/Details/Barley.png")},
}
Assets.MapTemperateHouseDetails = {
    {"TY01",love.graphics.newImage("Images/Maps/Details/Ty01.png")},
    {"TY02",love.graphics.newImage("Images/Maps/Details/Ty02.png")},
    {"TY03",love.graphics.newImage("Images/Maps/Details/Ty03.png")},
    {"TY04",love.graphics.newImage("Images/Maps/Details/Ty04.png")},
    {"SPNA",love.graphics.newImage("Images/Maps/Details/SpawnA.png")},
    {"SPNB",love.graphics.newImage("Images/Maps/Details/SpawnB.png")},
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
    {"Corn","CRN"},
    {"Wheat","WHE"},
}
Assets.Map_Editor_Detail_ID = {
    {"House1","TY01"},
    {"House2","TY02"},
    {"House3","TY03"},
    {"House4","TY04"},
    {"SpawnA","SPNA"},
    {"SpawnB","SPNB"},
}



Assets.Effects = {
    {"Smoke",love.graphics.newImage("Images/Effects/Smoke1.png")},

    {"BulletHit1",love.graphics.newImage("Images/Effects/BulletHit1.png")},
    {"BulletHit2",love.graphics.newImage("Images/Effects/BulletHit2.png")},
    {"BulletHit3",love.graphics.newImage("Images/Effects/BulletHit3.png")},

    {"CannonHit1",love.graphics.newImage("Images/Effects/CannonHit1.png")},
    {"CannonHit2",love.graphics.newImage("Images/Effects/CannonHit2.png")},
    {"CannonHit3",love.graphics.newImage("Images/Effects/CannonHit3.png")},

    {"DeadFrenchLineInfantry",love.graphics.newImage("Images/FrenchTroops/LineInfantry/DeadSoldier.png")},
    {"DeadPrussianLineInfantry",love.graphics.newImage("Images/PrussianTroops/LineInfantry/DeadSoldier.png")},
}

Assets.FireSounds = {
    {"RegularCharge",love.audio.newSource("Sounds/Fire/Charge.mp3","static")},
    
    {"MusketShot1",love.audio.newSource("Sounds/Fire/MusketFire1.mp3","static")},
    {"MusketShot2",love.audio.newSource("Sounds/Fire/MusketFire2.mp3","static")},
    {"MusketShot3",love.audio.newSource("Sounds/Fire/MusketFire3.mp3","static")},
    {"MusketShot4",love.audio.newSource("Sounds/Fire/MusketFire4.mp3","static")},
    {"MusketShot5",love.audio.newSource("Sounds/Fire/MusketFire5.mp3","static")},
    {"MusketShot6",love.audio.newSource("Sounds/Fire/MusketFire6.mp3","static")},
    {"MusketShot7",love.audio.newSource("Sounds/Fire/MusketFire7.mp3","static")},
    {"MusketShot8",love.audio.newSource("Sounds/Fire/MusketFire8.mp3","static")},
    {"MusketShot9",love.audio.newSource("Sounds/Fire/MusketFire9.mp3","static")},
    {"MusketShot10",love.audio.newSource("Sounds/Fire/MusketFire1.mp3","static")},
    {"MusketShot11",love.audio.newSource("Sounds/Fire/MusketFire2.mp3","static")},
    {"MusketShot12",love.audio.newSource("Sounds/Fire/MusketFire3.mp3","static")},
    {"MusketShot13",love.audio.newSource("Sounds/Fire/MusketFire4.mp3","static")},
    {"MusketShot14",love.audio.newSource("Sounds/Fire/MusketFire5.mp3","static")},
    {"MusketShot15",love.audio.newSource("Sounds/Fire/MusketFire6.mp3","static")},
    {"MusketShot16",love.audio.newSource("Sounds/Fire/MusketFire7.mp3","static")},
    {"MusketShot17",love.audio.newSource("Sounds/Fire/MusketFire8.mp3","static")},
    {"MusketShot18",love.audio.newSource("Sounds/Fire/MusketFire9.mp3","static")},

    {"CannonShot1",love.audio.newSource("Sounds/Fire/CannonFire1.mp3","static")},
    {"CannonShot2",love.audio.newSource("Sounds/Fire/CannonFire2.mp3","static")},
    {"CannonShot3",love.audio.newSource("Sounds/Fire/CannonFire3.mp3","static")},
    {"CannonShot4",love.audio.newSource("Sounds/Fire/CannonFire1.mp3","static")},
    {"CannonShot5",love.audio.newSource("Sounds/Fire/CannonFire2.mp3","static")},
    {"CannonShot6",love.audio.newSource("Sounds/Fire/CannonFire3.mp3","static")},
    {"CannonShot7",love.audio.newSource("Sounds/Fire/CannonFire1.mp3","static")},
    {"CannonShot8",love.audio.newSource("Sounds/Fire/CannonFire2.mp3","static")},
    {"CannonShot9",love.audio.newSource("Sounds/Fire/CannonFire3.mp3","static")},
}

Assets.MarchSounds = {
    {"Grass1",love.audio.newSource("Sounds/March/Grass1.mp3","static"),false},
    {"Forest1",love.audio.newSource("Sounds/March/Forest1.mp3","static"),false},
    {"Road1",love.audio.newSource("Sounds/March/Road1.mp3","static"),false},
    {"Stream1",love.audio.newSource("Sounds/March/Stream1.mp3","static"),false},

    {"Grass2",love.audio.newSource("Sounds/March/Grass1.mp3","static"),false},
    {"Forest2",love.audio.newSource("Sounds/March/Forest1.mp3","static"),false},
    {"Road2",love.audio.newSource("Sounds/March/Road1.mp3","static"),false},
    {"Stream2",love.audio.newSource("Sounds/March/Stream1.mp3","static"),false},

    {"Grass3",love.audio.newSource("Sounds/March/Grass1.mp3","static"),false},
    {"Forest3",love.audio.newSource("Sounds/March/Forest1.mp3","static"),false},
    {"Road3",love.audio.newSource("Sounds/March/Road1.mp3","static"),false},
    {"Stream3",love.audio.newSource("Sounds/March/Stream1.mp3","static"),false},

    {"Grass4",love.audio.newSource("Sounds/March/Grass1.mp3","static"),false},
    {"Forest4",love.audio.newSource("Sounds/March/Forest1.mp3","static"),false},
    {"Road4",love.audio.newSource("Sounds/March/Road1.mp3","static"),false},
    {"Stream4",love.audio.newSource("Sounds/March/Stream1.mp3","static"),false},

    {"Grass5",love.audio.newSource("Sounds/March/Grass1.mp3","static"),false},
    {"Forest5",love.audio.newSource("Sounds/March/Forest1.mp3","static"),false},
    {"Road5",love.audio.newSource("Sounds/March/Road1.mp3","static"),false},
    {"Stream5",love.audio.newSource("Sounds/March/Stream1.mp3","static"),false},

    {"Grass6",love.audio.newSource("Sounds/March/Grass1.mp3","static"),false},
    {"Forest6",love.audio.newSource("Sounds/March/Forest1.mp3","static"),false},
    {"Road6",love.audio.newSource("Sounds/March/Road1.mp3","static"),false},
    {"Stream6",love.audio.newSource("Sounds/March/Stream1.mp3","static"),false},
}

Assets.OtherSounds = {
    {"EuropeanAmbience",love.audio.newSource("Sounds/Ambience/EuropeanAmbience.mp3","stream")},
    {"AmericanAmbience",love.audio.newSource("Sounds/Ambience/AmericanAmbience.mp3","stream")},
}

Assets.UnitCards = {
    {"PrussianLineInfantry",love.graphics.newImage("Images/PrussianTroops/LineInfantry/FlagLarge.png")},
    {"PrussianLightInfantry",love.graphics.newImage("Images/PrussianTroops/LightInfantry/FlagLarge.png")},
    {"PrussianArtillery",love.graphics.newImage("Images/PrussianTroops/Artillery/FlagLarge.png")},

    {"FrenchLineInfantry",love.graphics.newImage("Images/FrenchTroops/LineInfantry/FlagLarge.png")},
    {"FrenchLightInfantry",love.graphics.newImage("Images/FrenchTroops/LightInfantry/FlagLarge.png")},
}

return Assets