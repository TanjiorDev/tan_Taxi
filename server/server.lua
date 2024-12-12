ESX = exports["es_extended"]:getSharedObject()

--Coffre

-- Charger la configuration
Citizen.CreateThread(function()
    -- Attente pour être sûr que la config est prête
    Wait(1000)

    -- Vérification de l'activation de la ressource "ox_inventory"
    AddEventHandler('onServerResourceStart', function(resourceName)
        if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
            Wait(0)
            -- Enregistrement du coffre taxi avec les paramètres de config.lua
            exports.ox_inventory:RegisterStash(
                Config.TaxiService.coffre.id,        -- Identifiant du coffre
                Config.TaxiService.coffre.label,     -- Label du coffre
                Config.TaxiService.coffre.slots,     -- Nombre de slots
                Config.TaxiService.coffre.weight,    -- Poids
                Config.TaxiService.coffre.owner     -- Propriétaire
            )
        end
    end)
end)





TriggerEvent('esx_phone:registerNumber', 'taxi', 'alerte taxi', true, true)

TriggerEvent('esx_society:registerSociety', 'taxi', 'taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('Ouvre:taxi')
AddEventHandler('Ouvre:taxi', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'Les taxis sont désormais ouverts!'
			type = 'inform'
		})
	end
end)

RegisterServerEvent('Ferme:taxi')
AddEventHandler('Ferme:taxi', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'Les taxis sont désormais fermés
			type = 'inform'
		})
	end
end)

RegisterServerEvent('Recru:taxi')
AddEventHandler('Recru:taxi', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('ox_lib:notify', _source, {
			title = 'Recrutement en cours, rendez-vous au taxi !',
			type = 'inform'
		})
	end
end)

RegisterNetEvent('taxiperso')
AddEventHandler('taxiperso', function(msg)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'taxi', '~p~Annonce', msg, 'CHAR_TREVOR', 8)
    end
end)



-- Mission 

-- Event: FinishMission
RegisterNetEvent('taxi:payPlayerAndCompany', function(playerPay, companyPay)
    local xPlayer = ESX.GetPlayerFromId(source)

    if playerPay > 0 then
        xPlayer.addMoney(playerPay)
        TriggerClientEvent('esx:showNotification', source, ("~g~Vous avez reçu %s$ pour cette mission."):format(playerPay))
    end

    if companyPay > 0 and xPlayer.job.grade_name == 'boss' then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
            account.addMoney(companyPay)
        end)
        TriggerClientEvent('esx:showNotification', source, ("~g~L'entreprise a reçu %s$."):format(companyPay))
    end
end)



--##############################
--############ Accueil ##########
--##############################


RegisterNetEvent('accueil:envoyerNotification', function(message)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    -- Vérifiez si le joueur a le job Taxi
    if xPlayer.getJob().name == "taxi" then
        TriggerClientEvent('esx:showNotification', src, '~g~Vous avez envoyé une notification aux taxis !')

        -- Notifiez tous les taxis
        for _, playerId in pairs(ESX.GetPlayers()) do
            local targetPlayer = ESX.GetPlayerFromId(playerId)

            if targetPlayer and targetPlayer.getJob().name == "taxi" then
                TriggerClientEvent('esx:showNotification', playerId, '~b~[Notification Taxi]~s~ ' .. message)
            end
        end
    else
        TriggerClientEvent('esx:showNotification', src, '~r~Vous n\'êtes pas un taxi !')
    end
end)



RegisterServerEvent('getCompanyMoneytaxi')
AddEventHandler('getCompanyMoneytaxi', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    MySQL.Async.fetchScalar('SELECT money FROM addon_account_data WHERE account_name = @account_name', {
        ['@account_name'] = 'society_taxi' 
    }, function(money)
        if money then
            TriggerClientEvent('returnCompanyMoney', _source, money)
        else
            TriggerClientEvent('returnCompanyMoney', _source, 0)  
        end
    end)
end)



RegisterServerEvent('depositCompanyMoneytaxi')
AddEventHandler('depositCompanyMoneytaxi', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerMoney = xPlayer.getMoney()

    if amount > 0 and playerMoney >= amount then
        xPlayer.removeMoney(amount)

        MySQL.Async.execute('UPDATE addon_account_data SET money = money + @amount WHERE account_name = @account_name', {
            ['@amount'] = amount,
            ['@account_name'] = 'society_taxi'  
        }, function(rowsChanged)
            if rowsChanged > 0 then
            else
          TriggerClientEvent('esx:showNotification', source, "Vous n\'avez pas assez d\'argent.") 
            end
        end)
    else
    end
end)

RegisterServerEvent('withdrawCompanyMoneytaxi')
AddEventHandler('withdrawCompanyMoneytaxi', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchScalar('SELECT money FROM addon_account_data WHERE account_name = @account_name', {
        ['@account_name'] = 'society_taxi'  
    }, function(companyMoney)
        if amount > 0 and companyMoney >= amount then
            MySQL.Async.execute('UPDATE addon_account_data SET money = money - @amount WHERE account_name = @account_name', {
                ['@amount'] = amount,
                ['@account_name'] = 'society_taxi' 
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    xPlayer.addMoney(amount)
                    TriggerClientEvent('esx:showNotification', _source, 'Vous avez retiré $' .. amount .. ' de l\'entreprise.')
                else
                    TriggerClientEvent('esx:showNotification', _source, 'Erreur lors du retrait.')
                end
            end)
        else
            TriggerClientEvent('esx:showNotification', _source, 'L\'entreprise n\'a pas assez d\'argent.')
        end
    end)
end)


RegisterNetEvent('taxi:societybosstaxi:announceEmployee', function(job, title, desc)
    local source = source
    local sourceIde = ESX.GetPlayerFromId(source).identifier

    local Employees = ESX.GetExtendedPlayers('job', job)

    for i = 1, #Employees do
        sendServerNotify(Employees[i].source, title, desc, 'inform')
    end
end)

RegisterNetEvent('taxi:societybosstaxi:players', function(title, desc)
    local source = source
    local sourceIde = ESX.GetPlayerFromId(source).identifier

    sendServerNotify(-1, title, desc, 'inform')
end)
