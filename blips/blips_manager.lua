
-- Ensure the config is loaded
if not blips then
    print("[Error] Blips configuration not found!")
    return
end

for _, blipData in ipairs(blips) do
    local blip = AddBlipForCoord(blipData.x, blipData.y, blipData.z)
    SetBlipSprite(blip, blipData.sprite)
    SetBlipAsShortRange(blip, true)  -- Let's set it to true for now to ensure visibility when nearby
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipData.name)
    EndTextCommandSetBlipName(blip)
    SetBlipDisplay(blip, blipData.display)
    SetBlipCategory(blip, blipData.category)
    SetBlipPriority(blip, blipData.priority)
    SetBlipColour(blip, blipData.color)
end

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)

        for _, blip in pairs(blips) do
            local x, y, z = blip.x, blip.y, blip.z
            local red, green, blue, alpha = 0, 0, 255, 255
            DrawMarker(27, x, y, z, red, green, blue, alpha, 0.0, 0.0, 0.5, 0.5, 0.0, 0.0, 0.0, 255, 255, false, false, 2)
        end
    end
end)