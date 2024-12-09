ESX = exports["es_extended"]:getSharedObject()

-- Mettre à jour les données du joueur lorsque son métier change
RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- Récupérer les données ESX lors de la reconnexion ou au démarrage
RegisterNetEvent('esx:playerLoaded', function(playerData)
    ESX.PlayerData = playerData
end)

-- Initialisation des données ESX
CreateThread(function()
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

-- Paiement au joueur et à l'entreprise
RegisterNetEvent('taxi:payPlayerAndCompany', function(playerPay, companyPay)
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Paiement au joueur
    if playerPay > 0 then
        xPlayer.addMoney(playerPay)
        TriggerClientEvent('esx:showNotification', source, ("~g~Vous avez reçu %s$ pour cette mission."):format(playerPay))
    end

    -- Paiement à l'entreprise
    if companyPay > 0 and xPlayer.job.grade_name == 'boss' then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
            account.addMoney(companyPay)
        end)
        TriggerClientEvent('esx:showNotification', source, ("~g~L'entreprise a reçu %s$."):format(companyPay))
    end
end)

local inMission = false
local currentMissionBlip = nil
local currentMissionPed = nil
local missionDestination = nil
local chainMissions = false -- Mode missions enchaînées

-- Fonction pour récupérer une position aléatoire
local function GetRandomPos()
    if not Config.PossibleMissions or #Config.PossibleMissions == 0 then
        print("^1Erreur : PossibleMissions est vide ou non défini.^7")
        return vector3(0.0, 0.0, 0.0)
    end
    return Config.PossibleMissions[math.random(1, #Config.PossibleMissions)]
end

-- Fonction pour récupérer un PNJ aléatoire
local function GetRandomPed()
    if not Config.PossiblePeds or #Config.PossiblePeds == 0 then
        print("^1Erreur : PossiblePeds est vide ou non défini.^7")
        return 'a_m_m_farmer_01'
    end
    return Config.PossiblePeds[math.random(1, #Config.PossiblePeds)]
end

-- Fonction pour terminer une mission
local function FinishMission()
    if currentMissionBlip then
        RemoveBlip(currentMissionBlip)
        currentMissionBlip = nil
    end

    if currentMissionPed then
        DeleteEntity(currentMissionPed)
        currentMissionPed = nil
    end

    inMission = false
    ESX.ShowNotification("~g~Mission terminée avec succès !")

    -- Paiement pour le joueur et l'entreprise
    TriggerServerEvent('taxi:payPlayerAndCompany', Config.TaxiPayments.player, Config.TaxiPayments.company)

    -- Si le mode "missions enchaînées" est activé, démarrer une nouvelle mission
    if chainMissions then
        Citizen.Wait(2000) -- Petite pause avant de relancer
        StartMission()
    end
end

-- Fonction pour démarrer une mission
function StartMission()
    if inMission then
        ESX.ShowNotification("~r~Vous êtes déjà en mission.")
        return
    end

    -- Vérifier si le joueur est dans un véhicule de taxi
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 or not IsVehicleModel(vehicle, GetHashKey("taxi")) then
        ESX.ShowNotification("~r~Vous devez être dans un véhicule de taxi pour commencer une mission.")
        return
    end

    inMission = true
    local missionPos = GetRandomPos()
    local pedModel = GetRandomPed()

    -- Ajouter un blip pour la mission
    currentMissionBlip = AddBlipForCoord(missionPos)
    SetBlipSprite(currentMissionBlip, 280)
    SetBlipColour(currentMissionBlip, 5)
    SetBlipRoute(currentMissionBlip, true)

    ESX.ShowNotification("~y~Rendez-vous à l'emplacement marqué sur votre carte.")

    -- Charger le PNJ une fois sur place
    Citizen.CreateThread(function()
        while inMission do
            local playerCoords = GetEntityCoords(playerPed)
            if #(playerCoords - missionPos) < 20.0 then
                ESX.ShowNotification("~g~Vous êtes arrivé. Attendez que le client monte dans le véhicule.")

                -- Charger le modèle de PNJ
                RequestModel(pedModel)
                while not HasModelLoaded(pedModel) do
                    Citizen.Wait(10)
                end

                -- Créer le PNJ
                currentMissionPed = CreatePed(4, pedModel, missionPos.x, missionPos.y, missionPos.z, 0.0, true, true)

                -- PNJ entre dans le véhicule
                TaskEnterVehicle(currentMissionPed, vehicle, -1, 2, 1.0, 0, 0)

                -- Attendre que le PNJ monte
                Citizen.Wait(5000)

                -- Définir une destination
                missionDestination = GetRandomPos()
                SetBlipCoords(currentMissionBlip, missionDestination)
                SetBlipRoute(currentMissionBlip, true)
                ESX.ShowNotification("~y~Conduisez le client à sa destination.")
                break
            end
            Citizen.Wait(500)
        end

        -- Suivre la route jusqu'à la destination
        while inMission do
            local playerCoords = GetEntityCoords(playerPed)
            if #(playerCoords - missionDestination) < 20.0 then
                ESX.ShowNotification("~g~Vous avez atteint la destination. Merci de vous arrêter.")
                Citizen.Wait(2000)

                -- PNJ sort du véhicule
                TaskLeaveAnyVehicle(currentMissionPed, 0, 0)
                Citizen.Wait(2000)

                -- Fin de la mission
                FinishMission()
                break
            end
            Citizen.Wait(500)
        end
    end)
end

-- Fonction pour annuler la mission
local function CancelMission()
    if inMission then
        -- Supprimer le blip et le PNJ
        if currentMissionBlip then
            RemoveBlip(currentMissionBlip)
            currentMissionBlip = nil
        end

        if currentMissionPed then
            DeleteEntity(currentMissionPed)
            currentMissionPed = nil
        end

        -- Annuler l'état de la mission
        inMission = false
        ESX.ShowNotification("~r~Mission annulée.")

        -- Si des missions enchaînées étaient activées, les désactiver
        chainMissions = false
    else
        ESX.ShowNotification("~r~Aucune mission en cours à annuler.")
    end
end

-- Menu principal
function menutaxi()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
        lib.registerContext({
            id = 'menu_Taxi',
            title = "Menu Taxi",
            options = {
                {
                    title = 'Lancer des missions du PNJ',
                    description = "Lancez une mission de taxi avec un client.",
                    onSelect = function()
                        Mission()
                    end
                },
                {
                    title = 'Annonces',
                    description = "ouvrir le menu annonce.",
                    onSelect = function()
                        Annonces()
                    end
                },
                {
                    title = 'Faire une Facture',
                    description = 'ouvrir le menu Facture',
                    event = "taxi:Facture"
                }
            }
        })
        lib.showContext('menu_Taxi')
    end
end

-- Menu des missions
function Mission()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
        lib.registerContext({
            id = 'menu_missions',
            title = "Missions",
            options = {
                {
                    title = 'Lancer des missions enchaînées',
                    description = "Les missions continueront automatiquement.",
                    onSelect = function()
                        chainMissions = true
                        StartMission()
                    end
                },
                {
                    title = 'Arrêter toutes les missions',
                    description = "Annuler toutes les missions en cours.",
                    onSelect = CancelMission
                },
                {
                    title = 'Retourner',
                    menu = 'menu_Taxi',
                }
            }
        })
        lib.showContext('menu_missions')
    end
end

-- Annonces Menu
function Annonces()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
        lib.registerContext({
            id = 'menu_annonce',
            title = "Menu annonce",
            options = {
                {
                    title = 'Annonce Ouvertures',
                    description = 'Faire une annonce',
                    icon = 'fas fa-home',
                    iconColor = '#ffffff',
                    onSelect = function() TriggerServerEvent('Ouvre:taxi') end
                },
                {
                    title = 'Annonce Fermetures',
                    description = 'Faire une annonce',
                    icon = 'fas fa-home',
                    iconColor = '#ffffff',
                    onSelect = function() TriggerServerEvent('Ferme:taxi') end
                },
                {
                    title = 'Annonce Recrutement',
                    description = 'Faire une annonce',
                    icon = 'fas fa-home',
                    iconColor = '#ffffff',
                    onSelect = function() TriggerServerEvent('Recru:taxi') end
                },
                {
                    title = 'Annonce Perso',
                    description = 'Faire l\'annonce personnalisée',
                    arrow = true,
                    onSelect = function()
                        local input = lib.inputDialog('Annonce Personnalisée', { {type = 'input', label = 'Message', required = true, min = 4, max = 75} })
                        if input then
                            TriggerServerEvent('taxiperso', input[1])
                        end
                    end
                },
                {
                    title = 'Retourner',
                    menu = 'menu_Taxi',
                }
            }
        })
        lib.showContext('menu_annonce')
    end
end

-- FACTURE
RegisterNetEvent('taxi:Facture')
AddEventHandler('taxi:Facture', function()
    local input = lib.inputDialog('fais une facture', {'Montant'})
    if input then
        local amount = tonumber(input[1])
        if amount and amount >= 0 then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 4.0 then
                ESX.ShowNotification('~r~Personne proche !')
            else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_taxi', 'Facture taxi', amount)
            end
        else
            ESX.ShowNotification('Montant Invalide')
        end
    end
end)

-- Commandes
RegisterCommand("taxi", function() menutaxi() end)
RegisterKeyMapping("taxi", "Menu Taxi", "keyboard", "F6")
