ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)



function OpenMenuGarage()
  local options = {}

  -- Ajouter l'option "Ranger votre véhicule"
  table.insert(options, {
      title = Config.Garage2.rangerVehicule.title,
      description = Config.Garage2.rangerVehicule.description,
      icon = Config.Garage2.rangerVehicule.icon,
      iconColor = Config.Garage2.rangerVehicule.iconColor,
      onSelect = function()
          local playerPed = PlayerPedId()
    
          if IsPedSittingInAnyVehicle(playerPed) then
              local vehicle = GetVehiclePedIsIn(playerPed, false)
            
              if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                  ESX.ShowNotification('La voiture a été mise dans le garage')
                  ESX.Game.DeleteVehicle(vehicle)
              else
                  ESX.ShowNotification('Mais toi place conducteur, ou sortez de la voiture.')
              end
          else
              local vehicle = ESX.Game.GetVehicleInDirection()
            
              if DoesEntityExist(vehicle) then
                  ESX.ShowNotification('La voiture a été placée dans le garage.')
                  ESX.Game.DeleteVehicle(vehicle)
              else
                  ESX.ShowNotification('Aucune voiture autour')
              end
          end
      end
  })

  -- Ajouter dynamiquement les véhicules à partir de la configuration
  for _, vehicle in ipairs(Config.Garage2.vehicles) do
      table.insert(options, {
          title = vehicle.title,
          description = vehicle.description,
          icon = vehicle.icon,
          iconColor = vehicle.iconColor,
          image = vehicle.image,
          onSelect = function()
              local model = GetHashKey(vehicle.model)
              RequestModel(model)
              while not HasModelLoaded(model) do Citizen.Wait(10) end
              local pos = GetEntityCoords(PlayerPedId())
              local createdVehicle = CreateVehicle(model, vehicle.coords.x, vehicle.coords.y, vehicle.coords.z, vehicle.coords.heading, true, true)
              SetVehicleCustomPrimaryColour(createdVehicle, vehicle.color.r, vehicle.color.g, vehicle.color.b)
              SetVehicleCustomSecondaryColour(createdVehicle, vehicle.color.r, vehicle.color.g, vehicle.color.b)
              lib.notify({
                  title = 'Véhicule',
                  description = 'Votre véhicule de service a été sorti',
                  type = 'success'
              })
          end
      })
  end

  -- Créer le menu avec les options
  lib.registerContext({
      id = 'menu_principal',
      title = 'Garage',
      options = options
  })

  -- Afficher le menu
  lib.showContext('menu_principal')
end



    Citizen.CreateThread(function()
      local zone = Config.Garage.TaxiGarage
  
      exports.ox_target:addBoxZone({
          coords = zone.coords,
          size = zone.size,
          drawSprite = true,
          options = {
              {
                  name = zone.garageMenu.name,
                  icon = zone.garageMenu.icon,
                  label = zone.garageMenu.label,
                  canInteract = function(entity, distance, coords, name)
                      local player = ESX.GetPlayerData()
                      -- Vérifie si le joueur a le job "taxi"
                      return player.job and player.job.name == 'taxi'
                  end,
                  onSelect = function()
                      -- Affiche le menu "taxi_taxi"
                      OpenMenuGarage()
                  end,
                  distance = zone.garageMenu.distance
              }
          }
      })
  end)

 -- Hash = https://docs.fivem.net/docs/game-references/ped-models/
 -- coords = vector4(X, Y, Z, H) - position X, Y, Z, H

 -- Charger les Peds depuis config.lua
Citizen.CreateThread(function()
  -- Parcourir les Peds de la section "Garage" dans la configuration
  for _, pedData in pairs(Config.Peds.Garage) do
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


