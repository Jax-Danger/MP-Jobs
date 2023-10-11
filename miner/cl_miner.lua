local nearMine = false

RegisterNetEvent('spawnScrap')
AddEventHandler('spawnScrap', function()
    local player = PlayerPedId()
    local pos = vector3(2825.2227, 2796.7036, 57.6615)
    local heading = 179.5591

    -- Load the scrap vehicle model
    RequestModel("Scrap")
    while not HasModelLoaded("Scrap") do
        Citizen.Wait(500)
    end
        -- Create the scrap vehicle at the player's position
    local Scrap = CreateVehicle(GetHashKey("Scrap"), pos.x + 5, pos.y, pos.z, heading, true, false)
        -- Set the player as the driver of the scrap
    TaskWarpPedIntoVehicle(player, Scrap, -1)  -- -1 is the driver seat
end)


local truck = vector3(2825.2227, 2796.7036, 57.6615)
local minerJob = lib.points.new(truck, 10)

function minerJob:onEnter()
    nearMine = false
    lib.showTextUI('Open Radial Menu to spawn the truck', {
        position = "top-center",
        icon = 'car',
        style = {
            borderRadius = 0,
            backgroundColor = '#48BB78',
            color = 'white'
        }
    })
    lib.addRadialItem({
        {
            id = 'scrap',
            label = 'Spawn Truck',
            icon = 'car',
            onSelect = function()
                TriggerEvent('spawnScrap')
                exports['MP-Elements']:Noti(3, 'You are now a Miner.', 5000)
                TriggerServerEvent('changeJob', 'miner')
            end
        }
    })
end

function minerJob:onExit()
    lib.removeRadialItem('scrap')
    lib.hideTextUI()
end

local rock1 = vector3(2976.4, 2792.53, 40.52)
local mine1 = lib.points.new(rock1, 2)

function mine1:onEnter()
    nearMine = true
    lib.showTextUI('Press E to start mining!', {
        position = "top-center",
        icon = 'hand',
        style = {
            borderRadius = 0,
            backgroundColor = '#48BB78',
            color = 'white'
        }
    })
    TriggerEvent('miningProg')
end

function mine1:onExit()
    nearMine = false
    lib.hideTextUI()
end
-- Register the 'miningProg' event
RegisterNetEvent('miningProg')
AddEventHandler('miningProg', function()
    -- Check for 'E' key press inside the event
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                
            if nearMine then                
                if IsControlJustReleased(0, 38) then
                    local pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true)
                    AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.1, 0, 0, 270.0, 150.0, 0.0, true, true, false, true, 1, true)
                    lib.progressBar({
                        duration = 3000,
                        label = 'Extracting stone(s)',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            move = true,
                        },
                        anim = {
                            dict = 'melee@small_wpn@streamed_core_fps',
                            clip = 'ground_attack_0',
                        }
                    })
                    DeleteObject(pickaxe)
                    TriggerServerEvent('miner:addStone')
                    --CancelEvent()
                end
            else
                Citizen.Wait(500)
            end
        end
    end)
end)

--Smelting and recieving ore

local extracting = vector3(1110.04, -2008.22, 30.9)
local furnace = lib.points.new(extracting, 3)

function furnace:onEnter()
    lib.showTextUI('Open Radial Menu to smelt stone!', {
        position = "top-center",
        icon = 'rock',
        style = {
            borderRadius = 0,
            backgroundColor = '#48BB78',
            color = 'white'
        }
    })
    lib.addRadialItem({
        {
            id = 'smelt',
            label = 'Smelt stone',
            icon = 'car',
            onSelect = function()
                if lib.progressBar({
                        duration = 2500,
                        label = 'Extracting Ore(s) from stone(s)',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                        },
                    })
                then
                    TriggerServerEvent('miner:Extract')
                else
                    exports['MP-Elements']:Noti(3, 'Cancelled.', 5000)
                end
            end
        }
    })
end

function furnace:onExit()
    lib.removeRadialItem('smelt')
    lib.hideTextUI()
end

local smelting = vector3(1087.48, -2002.27, 30.88)
local smeltOre = lib.points.new(smelting, 3)

function smeltOre:onEnter()
    lib.showTextUI('Open Radial Menu to smelt ore!', {
        position = "top-center",
        icon = 'rock',
        style = {
            borderRadius = 0,
            backgroundColor = '#48BB78',
            color = 'white'
        }
    })
    lib.addRadialItem({
        {
            id = 'smelt',
            label = 'Smelt Ore',
            icon = 'car',
            onSelect = function()
                if lib.progressBar({
                        duration = 2500,
                        label = 'Smelting Ore',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = false,
                        },
                    })
                then
                    TriggerServerEvent('miner:Materials')
                else
                    exports['MP-Elements']:Noti(3, 'Cancelled.', 5000)
                end
            end
        }
    })
end
function smeltOre:onExit()
    lib.removeRadialItem('smelt')
    lib.hideTextUI()
end   

local sellZone = vector3(-622.3541, -230.8962, 38.1571)
local seller = lib.points.new(sellZone, 3)
local nearSeller = false

function seller:onEnter()
    nearSeller = true
    lib.showTextUI('Open Radial menu to sell materials', {
        position = "top-center",
        icon = 'rock',
        style = {
            borderRadius = 0,
            backgroundColor = '#48BB78',
            color = 'white'
        }
    })
    lib.addRadialItem({
        {
            id = 'seller',
            label = 'Sell materials',
            icon = 'hand',
            onSelect = function()
                if lib.progressBar({
                    duration = 2500,
                    label = 'Attempting to sell materials',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = false,
                    },
                }) then
                TriggerServerEvent('miner:HasMats')
                else
                    exports['MP-Elements']:Noti(3, 'Cancelled.', 5000)
                end
            end
        }
    })
end
function seller:onExit()
    nearSeller = false
    lib.removeRadialItem('seller')
    lib.hideTextUI()
end   
