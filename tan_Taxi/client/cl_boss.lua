--############################
--############ Boss ##########
--############################

lib.registerContext({
    id = 'taxi_boss',
    title = 'Boss Menu',
    options = {
        {
            title = "Society  taxi",
            icon = 'building',
            readOnly = true
        },
        { title = ' ' },
        {
            title = 'Argent de l\'entreprise',
            icon = 'money-check-dollar',
            onSelect = function (args)
                TriggerServerEvent('getCompanyMoneytaxi')
            end
        },
        
        {
            title = 'Déposer de l\'argent',
            icon = 'plus',
            onSelect = function (args)
                -- Récupérer les entreprises gérées par l'utilisateur
                ESX.TriggerServerCallback('getManagedBusinesses', function(businesses)
                    if businesses and #businesses > 0 then
                        -- Demander de choisir une entreprise
                        local input = lib.inputDialog('Choisir une entreprise', {
                            {type = 'select', label = 'Entreprise', options = businesses},
                            {type = 'number', label = 'Montant', description = 'Entrez le montant à déposer', icon = 'dollar-sign'},
                        })
                        if input and input[1] and input[2] then
                            local selectedBusiness = input[1]
                            local amount = tonumber(input[2])
                            if amount and amount > 0 then
                                TriggerServerEvent('depositCompanyMoney', selectedBusiness, amount)
                            else
                                
                                ESX.ShowNotification("Montant invalide")
                            end
                        end
                    else
                        ESX.ShowNotification("Vous ne gérez aucune entreprise.")
                    end
                end)
            end
        },
        {
            title = 'Retirer de l\'argent',
            icon = 'rotate-right',
            onSelect = function (args)
                local input = lib.inputDialog('Retirer de l\'argent', {
                    {type = 'number', label = 'Montant', description = 'Entrez le montant à retirer', icon = 'dollar-sign'},
                })
                if input and input[1] then
                    local amount = tonumber(input[1])
                    if amount and amount > 0 then
                        TriggerServerEvent('withdrawCompanyMoneytaxi', amount)
                    else
                  ESX.ShowNotification("montant invalide")
                    end
                end
            end
        },
        {
            title = 'Annouce',
            icon = 'bullhorn',
            onSelect = function (args)
                local input = lib.inputDialog("announce", {
                    {type = 'select', label = "announce Type", required = true, options = {
                        {value = 'Announce Employer', label = "employer"}, 
                        {value = 'Announce Citoyen', label = "players"}
                    }},
                    {type = 'input', label = "Annouce Titre", description = "Message Titre", required = true},
                    {type = 'input', label = "Announce Description", description = "Message Description", required = true}
                })
                if not input then return end

                if input[1] == 'Announce Employer' then
                    TriggerServerEvent('taxi:societybosstaxi:announceEmployee', ESX.PlayerData.job.name, input[2], input[3])
                elseif input[1] == 'Announce Citoyen' then
                    TriggerServerEvent('taxi:societybosstaxi:players', input[2], input[3])
                end
            end
            },
            {
                title = 'Coffre de l\'entreprise',
                icon = 'toolbox',
                onSelect = function (args)
                    local playerPed = GetPlayerPed(-1)
                    exports.ox_inventory:openInventory('stash', 'society_taxi')  
                    end
            },
            

    }
})

RegisterNetEvent('returnCompanyMoney')
AddEventHandler('returnCompanyMoney', function(money)
    lib.notify({
        title = 'Entreprise',
        description = "L'entreprise possède ~s~ $"..money,
        type = 'success'
    })
end)


Citizen.CreateThread(function()
    local zone = Config.Boss.TaxiBoss

    exports.ox_target:addBoxZone({
        coords = zone.coords,
        size = zone.size,
        drawSprite = true,
        groups = zone.society,
        options = {
            {
                name = zone.bossMenu.name,
                icon = zone.bossMenu.icon,
                label = zone.bossMenu.label,
                groups = zone.society,
                canInteract = function(entity, distance, coords, name)
                    local player = ESX.GetPlayerData()
                    return player.job.name == zone.society and player.job.grade >= zone.bossMenu.requiredGrade
                end,
                onSelect = function()
                    lib.showContext('taxi_boss')
                end,
                distance = zone.bossMenu.distance
            }
        }
    })
end)