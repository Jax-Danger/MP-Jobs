-- Ensure the config is loaded
if not blips then
    print("[Error] Blips configuration not found!")
    return
end

-- Loop through the blips configuration and create them
Citizen.CreateThread(function()
    for _, blipData in ipairs(blips) do
        local blip = AddBlipForCoord(blipData.x, blipData.y, blipData.z)
        
        SetBlipSprite(blip, blipData.sprite)
        SetBlipAsShortRange(blip, blipData.shortRange)
        SetBlipColour(blip, blipData.color)
        SetBlipScale(blip, blipData.scale)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipData.name)
        EndTextCommandSetBlipName(blip)
    end
end)
