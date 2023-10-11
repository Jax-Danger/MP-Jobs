handcuffed = false
local animation = {dict = "mp_arresting", name = "idle"}
local unarmed = GetHashKey("WEAPON_UNARMED")

RegisterNetEvent("Handcuff")
AddEventHandler("Handcuff", function()
    local player = PlayerId()
    local plyPed = GetPlayerPed(player)
    if DoesEntityExist(plyPed) then
        local coords = GetEntityCoords(plyPed)
        local nearestPlayer = lib.getClosestPlayer(coords, 5, false)
        if nearestPlayer ~= -1 then
            local playerPed = GetPlayerPed(nearestPlayer)
            if DoesEntityExist(playerPed) then
                if IsEntityPlayingAnim(playerPed, animation.dict, animation.name, 3) then
                    -- player is cuffed, uncuff them
                    ClearPedSecondaryTask(playerPed)
                    SetEnableHandcuffs(playerPed, false)
                    SetCurrentPedWeapon(playerPed, unarmed, true)
                    handcuffed = false
                else
                    -- player is not cuffed, cuff them
                    handsup = false
                    ClearPedTasksImmediately(playerPed)
                    RequestAnimDict(animation.dict)
                    while not HasAnimDictLoaded(animation.dict) do
                        Citizen.Wait(100)
                    end

                    TaskPlayAnim(playerPed, animation.dict, animation.name, 8.0, -8, -1, 49, 0, 0, 0, 0)
                    SetEnableHandcuffs(playerPed, true)
                    SetCurrentPedWeapon(playerPed, unarmed, true)
                    handcuffed = true
                end
            end
        end
    end
end)

RegisterNetEvent("Unhandcuff")
AddEventHandler("Unhandcuff", function()
    local player = PlayerId()
    local plyPed = GetPlayerPed(player)
    if DoesEntityExist(plyPed) then
        local coords = GetEntityCoords(plyPed)
        local nearestPlayer = lib.getClosestPlayer(coords, 5, false)
        if nearestPlayer ~= -1 then
            local playerPed = GetPlayerPed(nearestPlayer)
            if DoesEntityExist(playerPed) then
                if IsEntityPlayingAnim(playerPed, animation.dict, animation.name, 3) then
                    -- player is cuffed, uncuff them
                    ClearPedSecondaryTask(playerPed)
                    SetEnableHandcuffs(playerPed, false)
                    SetCurrentPedWeapon(playerPed, unarmed, true)
                    handcuffed = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		local player = PlayerId()
		local plyPed = GetPlayerPed(player)
		if DoesEntityExist(plyPed) then

			-- Cuffing Logic
			if not IsPedInAnyVehicle(plyPed, false) then
				if IsControlJustPressed(0, 186) then
					local targetped = GetPedInFront()
					print(targetped)
					if targetped ~= 0 then
						local targetplayer = GetPlayerFromPed(targetped)
						if targetedPlayer ~= -1 then
							TriggerServerEvent("CheckHandcuff", GetPlayerServerId(targetplayer))
						end
					end
				end
			end

			-- Backup Handcuffs
			if handcuffed then
				if not IsEntityPlayingAnim(plyPed, animation.dict, animation.name, 3) then
					Citizen.Wait(3000)
					if handcuffed then
						TaskPlayAnim(plyPed, animation.dict, animation.name, 8.0, -8, -1, 49, 0, 0, 0, 0)
					end
				end
			end

			-- Remove ability to drive vehicles
			if handcuffed then
				DisablePlayerFiring(player, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
				SetPedPathCanUseLadders(GetPlayerPed(PlayerId()), false)
				if IsPedInAnyVehicle(GetPlayerPed(PlayerId()), false) then
					DisableControlAction(0, 59, true)
				end
			end
			
		end
		Citizen.Wait(0)
	end
end)

function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

function GetPlayerFromPed(ped)
	for a = 0, 64 do
		if GetPlayerPed(a) == ped then
			return a
		end
	end
	return -1
end