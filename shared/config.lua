Config = {}


Config.TaxiStations = {

	TAXI = {

		Blip = {
			Coords  = vec3(907.859375, -174.975830, 74.134033),
			Sprite  = 198,
			Display = 4,
			Scale   = 0.7,
			Colour  = 5,
            Name    = "~g~Entreprise~s~ | Taxi"
		},
    }
}

--##############################
--############ Accueil ##########
--##############################



Config.Accueil = {
    TaxiAccueil = {
        coords = vector3(908.442505,-156.009888,74.499947), -- Coordonnées X, Y, Z
        size = vec3(2.0, 2.0, 2.0), -- Dimensions de la zone
        accueilMenu = {
            name = 'menu_accueil',
            icon = 'fas fa-taxi',
            label = 'Accès Menu Taxi',
            distance = 2.5 -- Distance d'interaction
        }
    }
}


 -- Hash = https://docs.fivem.net/docs/game-references/ped-models/
 -- coords = vector4(X, Y, Z, H) - position X, Y, Z, H
Config.Peds2 = {
    -- Liste des peds avec leurs informations
    Accueil2 = {
        {
            hash = "a_m_y_genstreet_01", -- Modèle du Ped
            coords = vector4(908.45, -155.76, 73.22, 148.82) , -- Coordonnées du Ped (x, y, z, heading)
        }
    }
}

--##############################
--############ Coffre ##########
--##############################

Config.Coffre = {
    TaxiCoffre = {
        coords = vector3(892.099976,-158.903717,78.770378),  -- Exemple de coordonnée
        size = vector3(1.5, 1.5, 2.0),  -- Taille de la zone d'interaction
        coffreMenu = {
            name = 'taxi_coffre',
            icon = 'fas fa-user',  -- Icône à afficher
            label = 'Accéder au coffre',
            distance = 2.0  -- Distance d'interaction
        }
    }
}

Config.TaxiService = {
    coffre = {
        id = 'taxicoffre',          -- Identifiant du coffre
        label = 'Coffre taxi',      -- Label du coffre
        slots = 50,                 -- Nombre d'emplacements
        weight = 20000,             -- Poids maximal du coffre
        owner = 'steam:'            -- Propriétaire du coffre (peut être un identifiant Steam ou autre)
    }
}

--############################
--########### Garage #########
--############################



Config.Garage = {
    TaxiGarage = {
        coords = vector3(892.126953,-145.322876,69.629135),  -- Exemple de coordonnée
        size = vector3(1.5, 1.5, 2.0),  -- Taille de la zone d'interaction
        garageMenu = {
            name = 'taxi_garage',
            icon = 'fas fa-user',  -- Icône à afficher
            label = 'Accéder au garage',
            distance = 2.0  -- Distance d'interaction
        }
    }
}

-- config.lua


Config.Garage2 = {
    rangerVehicule = {
        title = 'Ranger votre véhicule',
        description = 'Ranger',
        icon = 'fas fa-home',
        iconColor = '#ffffff',
    },
    vehicles = {
        {
            title = 'Taxi',
            description = 'Taxi',
            icon = 'fas fa-truck',
            iconColor = '#ffffff',
            image = "https://wiki.rage.mp/images/thumb/a/a6/Taxi.png/164px-Taxi.png",
            model = "Taxi",
            coords = {x = 891.217590, y = -148.536255, z = 68.944336, heading = 59.527554},
            color = {r = 255, g = 255, b = 0}
        },
        {
            title = 'Streiter Taxi',
            description = 'streitertaxi',
            icon = 'fas fa-car',
            iconColor = '#ffffff',
            image = "https://cdn.discordapp.com/attachments/1229009151796187207/1315067602787110942/11af12-Taxi_1.webp?ex=6756b865&is=675566e5&hm=717e4d8ddba8e09a4fe5cb4afbcf1fc63447bc35fbb8d9192bb4f1cec8519d85&",
            model = "streitertaxi",
            coords = {x = 891.217590, y = -148.536255, z = 68.944336, heading = 59.527554},
            color = {r = 255, g = 255, b = 0}
        }
		
    }
}

Config.Peds = {
    -- Liste des peds avec leurs informations
    Garage = {
        {
            hash = "a_m_m_hillbilly_01", -- Modèle du Ped
            coords = vector4(892.087891, -145.068130, 68.365601, 144.566910), -- Coordonnées du Ped (x, y, z, heading)
        }
    }
}

--############################
--########### Vestiaire ##########
--############################


-- Configuration du vestiaire
Config.Vestiaire = {
    TaxiVestiaire = {
        coords = vector3(901.510620,-149.440979,75.496834),  -- Exemple de coordonnée
        size = vector3(1.5, 1.5, 2.0),  -- Taille de la zone d'interaction
        vestiaireMenu = {
            name = 'taxi_vestiaire',
            icon = 'fas fa-user',  -- Icône à afficher
            label = 'Accéder au Vestiaire',
            distance = 2.0  -- Distance d'interaction
        }
    }
}


-- Liste des tenues


Config.Outfits = {
    {
        name = "Civil", -- Nom unique de la tenue
        label = "Tenue : Civile",
        description = "Revenir en tenue civile.",
        armor = 0, -- Armure de la tenue
        skinCallback = function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end
    },
    {
        name = "Travail", -- Nom unique de la tenue
        label = "Tenue : Travail",
        description = "Mettre la tenue de Travail.",
        skinCallback = function()
            local model = GetEntityModel(GetPlayerPed(-1))
            local clothesSkin
            TriggerEvent('skinchanger:getSkin', function(skin)
                if model == GetHashKey("mp_m_freemode_01") then
                    clothesSkin = {
                        ['tshirt_1'] = 39,  ['tshirt_2'] = 0,
                        ['torso_1'] = 209,   ['torso_2'] = 0,
                        ['decals_1'] = 0,   ['decals_2'] = 0,
                        ['arms'] = 30,
                        ['pants_1'] = 46,   ['pants_2'] = 0,
                        ['shoes_1'] = 25,   ['shoes_2'] = 0,
                        ['helmet_1'] = -1,  ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['mask_1'] = -1,    ['mask_2'] = 0,
                        ['bproof_1'] = 25,  ['bproof_2'] = 0,
                        ['ears_1'] = -1,     ['ears_2'] = 0
                    }
                else
                    clothesSkin = {
                        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                        ['torso_1'] = 65,   ['torso_2'] = 2,
                        ['decals_1'] = 0,   ['decals_2'] = 2,
                        ['arms'] = 36,
                        ['pants_1'] = 38,   ['pants_2'] = 0,
                        ['shoes_1'] = 12,   ['shoes_2'] = 0,
                        ['helmet_1'] = 45,  ['helmet_2'] = 0,
                        ['chain_1'] = 0,    ['chain_2'] = 0,
                        ['mask_1'] = -1,    ['mask_2'] = 0,
                        ['bproof_1'] = 25,  ['bproof_2'] = 0,
                        ['ears_1'] = -1,     ['ears_2'] = 0
                    }
                end
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end)
        end
    }
}





--############################
--########### Boss ##########
--############################
Config.Boss = {
    TaxiBoss = {
        coords = vector3(898.774048,-165.515533,73.968719),
        size = vector3(2.0, 2.0, 2.0),
        society = 'taxi',
        bossMenu = {
            name = "open_bossmenu",
            icon = 'fa-solid fa-building',
            label = "Menu patron taxi",
            requiredGrade = 4,  -- Grade minimum requis pour interagir
            distance = 2.5
        }
    }
}

--############################
--########### Missions ##########
--############################
Config.TaxiPayments = {
    player = 200,    -- Paiement pour le joueur
    company = 100    -- Paiement pour l'entreprise
}

Config.Notification = {
    Title = 'Mission terminée',
    SuccessMessage = "Vous avez terminé votre mission.\nGain: ~g~{gain}$\nGain entreprise: ~g~{society_gain}$"
}

Config.PossibleMissions = {
	vector3(293.5, -590.2, 42.7),
	vector3(253.4, -375.9, 44.1),
	vector3(120.8, -300.4, 45.1),
	vector3(-38.4, -381.6, 38.3),
	vector3(-107.4, -614.4, 35.7),
	vector3(-252.3, -856.5, 30.6),
	vector3(-236.1, -988.4, 28.8),
	vector3(-277.0, -1061.2, 25.7),
	vector3(-576.5, -999.0, 21.8),
	vector3(-602.8, -952.6, 21.6),
	vector3(-790.7, -961.9, 14.9),
	vector3(-912.6, -864.8, 15.0),
	vector3(-1069.8, -792.5, 18.8),
	vector3(-1306.9, -854.1, 15.1),
	vector3(-1468.5, -681.4, 26.2),
	vector3(-1380.9, -452.7, 34.1),
	vector3(-1326.3, -394.8, 36.1),
	vector3(-1383.7, -270.0, 42.5),
	vector3(-1679.6, -457.3, 39.4),
	vector3(-1812.5, -416.9, 43.7),
	vector3(-2043.6, -268.3, 23.0),
	vector3(-2186.4, -421.6, 12.7),
	vector3(-1862.1, -586.5, 11.2),
	vector3(-1859.5, -617.6, 10.9),
	vector3(-1635.0, -988.3, 12.6),
	vector3(-1284.0, -1154.2, 5.3),
	vector3(-1126.5, -1338.1, 4.6),
	vector3(-867.9, -1159.7, 5.0),
	vector3(-847.5, -1141.4, 6.3),
	vector3(-722.6, -1144.6, 10.2),
	vector3(-575.5, -318.4, 34.5),
	vector3(-592.3, -224.9, 36.1),
	vector3(-559.6, -162.9, 37.8),
	vector3(-535.0, -65.7, 40.6),
	vector3(-758.2, -36.7, 37.3),
	vector3(-1375.9, 21.0, 53.2),
	vector3(-1320.3, -128.0, 48.1),
	vector3(-1285.7, 294.3, 64.5),
	vector3(-1245.7, 386.5, 75.1),
	vector3(-760.4, 285.0, 85.1),
	vector3(-626.8, 254.1, 81.1),
	vector3(-563.6, 268.0, 82.5),
	vector3(-486.8, 272.0, 82.8),
	vector3(88.3, 250.9, 108.2),
	vector3(234.1, 344.7, 105.0),
	vector3(435.0, 96.7, 99.2),
	vector3(482.6, -142.5, 58.2),
	vector3(762.7, -786.5, 25.9),
	vector3(809.1, -1290.8, 25.8),
	vector3(490.8, -1751.4, 28.1),
	vector3(432.4, -1856.1, 27.0),
	vector3(164.3, -1734.5, 28.9),
	vector3(-57.7, -1501.4, 31.1),
	vector3(52.2, -1566.7, 29.0),
	vector3(310.2, -1376.8, 31.4),
	vector3(182.0, -1332.8, 28.9),
	vector3(-74.6, -1100.6, 25.7),
	vector3(-887.0, -2187.5, 8.1),
	vector3(-749.6, -2296.6, 12.5),
	vector3(-1064.8, -2560.7, 19.7),
	vector3(-1033.4, -2730.2, 19.7),
	vector3(-1018.7, -2732.0, 13.3),
	vector3(797.4, -174.4, 72.7),
	vector3(508.2, -117.9, 60.8),
	vector3(159.5, -27.6, 67.4),
	vector3(-36.4, -106.9, 57.0),
	vector3(-355.8, -270.4, 33.0),
	vector3(-831.2, -76.9, 37.3),
	vector3(-1038.7, -214.6, 37.0),
	vector3(1918.4, 3691.4, 32.3),
	vector3(1820.2, 3697.1, 33.5),
	vector3(1619.3, 3827.2, 34.5),
	vector3(1418.6, 3602.2, 34.5),
	vector3(1944.9, 3856.3, 31.7),
	vector3(2285.3, 3839.4, 34.0),
	vector3(2760.9, 3387.8, 55.7),
	vector3(1952.8, 2627.7, 45.4),
	vector3(1051.4, 474.8, 93.7),
	vector3(866.4, 17.6, 78.7),
	vector3(319.0, 167.4, 103.3),
	vector3(88.8, 254.1, 108.2),
	vector3(-44.9, 70.4, 72.4),
	vector3(-115.5, 84.3, 70.8),
	vector3(-384.8, 226.9, 83.5),
	vector3(-578.7, 139.1, 61.3),
	vector3(-651.3, -584.9, 34.1),
	vector3(-571.8, -1195.6, 17.9),
	vector3(-1513.3, -670.0, 28.4),
	vector3(-1297.5, -654.9, 26.1),
	vector3(-1645.5, 144.6, 61.7),
	vector3(-1160.6, 744.4, 154.6),
	vector3(-798.1, 831.7, 204.4)
}

Config.PossiblePeds = {
	"a_f_m_skidrow_01",
	"a_f_m_tramp_01",
	"a_f_m_soucent_01",
	"a_f_y_femaleagent",
	"a_f_y_eastsa_03",
	"a_f_y_genhot_01",
	"a_f_y_vinewood_03",
	"a_f_y_vinewood_04",
	"a_f_y_yoga_01",
	"a_m_m_business_01",
	"a_m_m_bevhills_02",
	"a_m_m_golfer_01",
	"a_m_m_eastsa_02",
	"a_m_m_soucent_04",
	"a_m_m_socenlat_01",
	"a_m_y_bevhills_02",
	"a_m_y_bevhills_01",
	"a_m_y_beachvesp_02",
	"a_m_y_business_02",
	"a_m_y_busicas_01",
	"a_m_y_business_01",
	"a_m_y_clubcust_01"
}

Config.Messages = {
    JobAssigned = "~o~Demande de transport. Une mission vous a été attribuée ! Consultez votre GPS.",
    GoToLocation = "Allez sur la zone GPS",
    ApproachClient = "Approchez-vous du client",
    WaitForClient = "Attendez que le client monte dans le véhicule",
    DriveToDestination = "Allez là où le client vous a demandé",
    StopVehicle = "Arrêtez le véhicule pour laisser descendre le client",
    FinishMission = "Mission terminée ! Vous avez reçu un bonus."
}

--############################
--########### Animations ##########
--############################
Config.LoadProgress = {
    Duty = { Duration = 5000, Label = "Prise de service..." }
}

--############################
--########### Blips ##########
--############################
Config.Blips = {
    {
        Coords = vector3(198.5, -162.5, 56.1),
        Sprite = 198,
        Display = 4,
        Scale = 1.2,
        Colour = 5,
        Name = "Station de Taxi"
    }
}


