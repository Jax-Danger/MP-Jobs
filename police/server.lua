-- Server side Arresting
RegisterNetEvent('MP-Jobs:ArrestPlayer')
AddEventHandler('MP-Jobs:ArrestPlayer', function(pID)
    if pID == -1 or pID == '-1' then
        if source ~= '' then
            print('ERROR')
        else
            print('Another Error')
        end

        return

    end

    if pID ~= false then
        TriggerClientEvent('MP-Jobs:arrest', pID)
    end
end)


-- Server side Escorting
RegisterNetEvent('MP-Jobs:EscortPlayer')
AddEventHandler('MP-Jobs:EscortPlayer', function(pID)
    if pID == -1 or pID == '-1' then
        if source ~= '' then
            print('ERROR')
        else
            print('Another Error')
        end

        return

    end

    if pID ~= false then
        TriggerClientEvent('MP-Jobs:escort', pID)
    end
end)


