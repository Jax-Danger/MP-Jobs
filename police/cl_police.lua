
-- Arrest Player Event
local handcuffed = false
RegisterNetEvent('MP-Jobs:arrest')
AddEventHandler('MP-Jobs:arrest', function()
    local pID = PlayerPedId()
    if (DoesEntityExist(pID)) then
        Citizen.CreateThread(function()
            lib.requestAnimDict('mp_arresting')
            while not lib.requestAnimDict('mp_arresting') do
                Citizen.Wait(0)            
            end

            if handcuffed then
                handcuffed = false
                Citizen.Wait(500)
                SetEnableHandcuffs(pID, false)
                ClearPedTasksImmediately(pID)
            else
                handcuffed = true
                SetEnableHandcuffs(pID, true)
                TaskPlayAnim(pID, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
        end)
    else
        print('ERORORORORORR!')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if handcuffed then
            if not IsEntityPlayingAnim(GetPlayerPed(PlayerId()), 'mp_arresting', 'idle', 3) then
                TaskPlayAnim(GetPlayerPed(PlayerId()), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end

            SetCurrentWeapon(PlayerPedId(), 'weapon_unarmed', true)

            if IsPedInAnyVehicle(GetPlayerPed(PlayerId)) then
                DisableControlAction(1, 23, true) -- F
                DisableControlAction(1, 75, true) -- F
                DisableControlAction(1, 142, true) -- Left Click
            end
        end
    end
end)


-- Escort Events
local escort = false
local officer = -1
RegisterNetEvent('MP-Jobs:escort')
AddEventHandler('MP-Jobs:escort', function()
    escort = not escort

    if not escort then
        DetachEntity(PlayerPedId(), true, false)
    end

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if escort then
            local Ped1 = GetPlayerPed(GetPlayerFromServerId(officer))
            local Ped2 = PlayerPedId()
            AttatchEntityToEntity(Ped2, Ped, 4103, 0.35, 0.38, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            DisableControlAction(1, 141, true) -- Q Key
            DisableControlAction(1, 142, true) -- Left Click
        end
    end
end)

