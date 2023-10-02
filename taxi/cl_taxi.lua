
RegisterNetEvent('spawnTaxi')
AddEventHandler('spawnTaxi', function()
    local player = PlayerPedId()
    local pos = vector3(901.9338, -182.6599, 73.9220)
    local heading = 323.6043

    -- Load the scrap vehicle model
    RequestModel("taxi")
    while not HasModelLoaded("taxi") do
        Citizen.Wait(500)
    end
        -- Create the scrap vehicle at the player's position
    local taxi = CreateVehicle(GetHashKey("taxi"), pos.x + 5, pos.y, pos.z, heading, true, false)
        -- Set the player as the driver of the scrap
    TaskWarpPedIntoVehicle(player, taxi, -1)  -- -1 is the driver seat
end)



local coords = vector3(911.17, -170.38, 74.18)
local point = lib.points.new(coords, 10)

function point:onEnter()
    lib.showTextUI('Open Radial Menu to Spawn Taxi', {
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
            id = 'taxi',
            label = 'Spawn Taxi',
            icon = 'car',
            onSelect = function()
                TriggerEvent('spawnTaxi')
                exports['MP-Elements']:Noti(3, 'You are now a taxi driver.', 5000)
                TriggerServerEvent('changeJob', 'taxi')
            end
        }
    })
end

function point:onExit()
    lib.removeRadialItem('taxi')
    lib.hideTextUI()
end
