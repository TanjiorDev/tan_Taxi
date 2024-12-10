--############################
--############ Client ############
--############################

function OpenMenuVestiaire()
    -- Créer dynamiquement les options de menu basées sur les tenues
    local options = {}
    for outfitName, outfitData in pairs(Config.Outfits) do
        table.insert(options, {
            title = outfitData.label,
            description = outfitData.description,
            icon = 'fas fa-home',
            iconColor = '#ffffff',
            onSelect = function()
                outfitData.skinCallback()  -- Charge la tenue via le callback configuré
                SetPedArmour(GetPlayerPed(-1), outfitData.armor)  -- Définit l'armure
                ESX.ShowNotification("Vous avez mis : " .. outfitData.label)
            end
        })
    end

    -- Enregistrement du menu contextuel avec les options créées
    lib.registerContext({
        id = 'menu_vestiaire',
        title = 'Vestiaire',
        options = options
    })

    -- Affichage du menu contextuel
    lib.showContext('menu_vestiaire')
end


function civil() ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin) TriggerEvent('skinchanger:loadSkin', skin) end) end

-- Fonction pour charger la tenue
function loadTenue(clothesSkin)
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
    end)
end

Citizen.CreateThread(function()
    local zone = Config.Vestiaire.TaxiVestiaire

    exports.ox_target:addBoxZone({
        coords = zone.coords,
        size = zone.size,
        drawSprite = true,
        options = {
            {
                name = zone.vestiaireMenu.name,
                icon = zone.vestiaireMenu.icon,
                label = zone.vestiaireMenu.label,
                canInteract = function(entity, distance, coords, name)
                    local player = ESX.GetPlayerData()
                    -- Vérifie si le joueur a le job "taxi"
                    return player.job and player.job.name == 'taxi'
                end,
                onSelect = function()
                    -- Affiche le menu "taxi_Vestiaire"
                    OpenMenuVestiaire()
                end,
                distance = zone.vestiaireMenu.distance
            }
        }
    })
end)
