Config = {}

Config.Debug = false

Config.Key = 38

Config.Timer = 0.10 -- Ez idő után tudja csak ujrakezdeni. percben megadva

Config.Blips = {
    Shell = false,
    Start = true
}

Config.BlackMoney = {
    meat = false,
    leather = false,
    luxusleather = true
}

Config.Start = {
    Blip = {
        StartHunting = "Vadászat",
        Sell = "Eladás",
        Animals = "Vad"
    },

    Marker = {
        ["StartHunting"] = {
            Coords = { x = -770.02, y = 5578.42, z = 33.49 },  -- x = -677.67, y = 5841.58, z = 17.34
            Colors = {255, 255, 255},
            Type = 27,
            Text = "[E] Vadászat elkezdése",
            Text2 =  "[E] Vadászat megszakítása"
        },

        ["Shell"] = {
            Coords = { x = -770.25, y = 5563.3, z = 33.49 }, -- x = -679.95, y = 5800.34, z = 57.83
            Colors = {255, 255, 255},
            Type = 27,
            Text = "[E] Eladás"
        },
    },

    Text = {
        "[E] Megnyúzd az állatot",
        "~r~Nem rendelkezel engedéllyel!",
        "~r~Nem rendelkezel késsel!",
        "Megnyúztad az állat tetemet és szereztél",
        "Elszaladtak a vadak, nézz vissza késöbb."
    },

    Type = {
        Position = "right",
        Name = "Vadászati fajták",
        "Élmény a hegyen",
        "Prémes élmény",
        "Féld az életed"
    },

    Items = {
        License = "hunting_license",
        License1 = "hunting_license1",
        License2 = "hunting_license2",
        Meat = "meat",
        Leather = "leather",
        LuxusLeather = "luxusleather"
    },

    Animals = {
        Position = {
            ["first"] = {
                { x = -1505.2, y = 4887.39, z = 78.38 },
                { x = -1164.68, y = 4806.76, z = 223.11 },
                { x = -1410.63, y = 4730.94, z = 44.0369 },
                { x = -1377.29, y = 4864.31, z = 134.162 },
                { x = -1697.63, y = 4652.71, z = 22.2442 },
                { x = -1259.99, y = 5002.75, z = 151.36 },
                { x = -960.91, y = 5001.16, z = 183.0 },
                { x = -1534.5, y = 4617.97, z = 29.09 }
            },

            ["second"] = {
                { x = -1164.68, y = 4806.76, z = 223.11 },
                { x = -1410.63, y = 4730.94, z = 44.0369 },
                { x = -1377.29, y = 4864.31, z = 134.162 }
            },

            ["third"] = {
                { x = -1505.2, y = 4887.39, z = 78.38 },
                { x = -1410.63, y = 4730.94, z = 44.0369 },
                { x = -1697.63, y = 4652.71, z = 22.2442 }
            }
        },
        
        Type = {
            ["first"] = {
                "a_c_rabbit_01", -- -541762431
                "a_c_deer", -- -664053099
                "a_c_boar", -- -832573324
                "cs_orleans" -- -1389097126
            },

            ["second"] = {
                "a_c_coyote" -- 1682622302
            },

            ["third"] = {
                "a_c_mtlion", -- 307287994
                "a_c_panther" -- -417505688
            }
        },

        Anims = {
            anim = {
                "amb@medic@standing@kneel@base",
                "base"
            },
            anim2 = {
                "anim@gangops@facility@servers@bodysearch@",
                "player_search"
            }
        }
    }
}

Config.Sell = {
    Weight = {
        rabbit = math.random(5, 8), -- 5 - 8 kg
        deer = math.random(40, 70), -- 40 - 70 kg
        boar = math.random(80, 150), -- 80 - 150 kg
        orleans = math.random(160, 190), -- 160 - 190 kg

        coyote = math.random(8, 13), -- 8 - 13 kg

        mtlion = math.random(8, 13), -- 8 - 13 kg
        panther = math.random(8, 13) -- 8 - 13 kg
    },

    Price = {  -- eladási árak / item
        Meat = 100, 
        Leather = 150,
        LuxusLeather = 200
    }
}
