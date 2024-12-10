ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

function OpenMenucoffre()
    -- Ouvre directement l'inventaire, pas besoin de table ici
    exports.ox_inventory:openInventory('stash', 'society_taxi')
end

Citizen.CreateThread(function()
    local zone = Config.Coffre.TaxiCoffre

    exports.ox_target:addBoxZone({
        coords = zone.coords,
        size = zone.size,
        drawSprite = true,
        options = {
            {
                name = zone.coffreMenu.name,
                icon = zone.coffreMenu.icon,
                label = zone.coffreMenu.label,
                canInteract = function(entity, distance, coords, name)
                    local player = ESX.GetPlayerData()
                    -- Vérifie si le joueur a le job "taxi"
                    return player.job and player.job.name == 'taxi'
                end,
                onSelect = function()
                    -- Affiche le menu "taxi_taxi"
                    OpenMenucoffre()
                end,
                distance = zone.coffreMenu.distance
            }
        }
    })
end)