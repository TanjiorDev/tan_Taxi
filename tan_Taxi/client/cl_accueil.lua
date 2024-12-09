-- Fonction pour ouvrir le menu d'accueil
function OpenMenuaccueil()
    lib.registerContext({
        id = 'accueil_menu',
        title = 'Menu d\'Accueil',
        options = {
            {
                title = 'Envoyer une notification',
                description = 'Envoyer un message personnalisé aux taxis',
                icon = 'taxi',
                onSelect = function()
                    -- Demander un message personnalisé
                    local input = lib.inputDialog('Notification Taxi', {
                        {label = 'Message à envoyer', type = 'textarea', placeholder = 'Saisissez votre message ici...'}
                    })

                    -- Vérifie si l'utilisateur a bien saisi un message
                    if input and input[1] ~= nil and input[1] ~= '' then
                        TriggerServerEvent('accueil:envoyerNotification', input[1])
                    else
                        TriggerEvent('esx:showNotification', '~r~Vous devez entrer un message valide.')
                    end
                end
            }
        }
    })
    lib.showContext('accueil_menu')
end

-- Ajout d'une zone avec ox_target
Citizen.CreateThread(function()
    local zone = Config.Accueil.TaxiAccueil
    
    if zone then
        exports.ox_target:addBoxZone({
            coords = zone.coords,
            size = zone.size,
            drawSprite = true,
            options = {
                {
                    name = zone.accueilMenu.name,
                    icon = zone.accueilMenu.icon,
                    label = zone.accueilMenu.label,
                    onSelect = function()
                        -- Affiche le menu
                        OpenMenuaccueil()
                    end,
                    distance = zone.accueilMenu.distance
                }
            }
        })
    end
end)

-- Charger les Peds depuis config.lua
Citizen.CreateThread(function()
    for _, pedData in pairs(Config.Peds2.Accueil2) do
        local hash = GetHashKey(pedData.hash)

        -- Charger le modèle du Ped
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
        end

        -- Créer le Ped
        local ped = CreatePed(4, hash, pedData.coords.x, pedData.coords.y, pedData.coords.z, pedData.coords.w, false, true)

        -- Configurer le Ped
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
    end
end)
