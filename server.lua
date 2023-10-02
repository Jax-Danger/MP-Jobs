local MP = exports['MP-Base']:GetObject()
MP.Player = {}

local function changePlayerJob(newJob)
    local Player = MP.Functions.GetPlayer(source)
    if not Player then
        print("Failed to retrieve player data for source: " .. tostring(source))
        return
    end

    local citizenid = Player.Data.citizenid
    if not citizenid then
        print("Failed to retrieve citizenid for player: " .. citizenid)
        return
    end

    exports.oxmysql:execute('UPDATE players SET job = @job WHERE citizenid = @citizenid', {
        ['@job'] = newJob,
        ['@citizenid'] = citizenid
    }, function(rowsChanged)
        if rowsChanged == 0 then
            print("Failed to update job for player with citizenid: " .. citizenid)
        else
            print("Updated job for player with citizenid: " .. citizenid)
            
        end
    end)
end

RegisterNetEvent('changeJob')
AddEventHandler('changeJob', function(newJob)
    local source = source
    local Player = MP.Functions.GetPlayer(source)
    if not Player then
        print('something wrong...')
    else
        print('we are good!')
        Player.Data.job = newJob
        print('job ' ..newJob)
    end
end)


RegisterCommand('save', function(source, Player)
    local source = source
    local Player = MP.Functions.GetPlayer(source)
    if not Player then
        print('uh oh the misery everybody wants to be my enemy!')
    else
        print('hey, you are okay!')
        print('player job is ' ..Player.Data.job)
        Player.Data.job = newJob
    end
end)

RegisterCommand('setjob', function(source, args, rawCommand)
    local source = source
    local targetPlayerId = tonumber(args[1])
    local newJob = args[2]

    if targetPlayerId and newJob then
        if IsPlayerAceAllowed(source, "command.setjob") then  -- Make sure the executing player has admin permissions
            TriggerEvent('changeJob', targetPlayerId, newJob)  -- Trigger the changeJob event for the target player
            TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Player job is now updated to " .. newJob)  -- Notify Admin Player job is Updated
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Permission Denied!")  -- Notify the executing player if they don't have permission
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Usage: /setjob [playerId] [job]")  -- Notify the executing player if the command is used incorrectly
    end
end, false)


-- register a command called 'addMoney' that takes a number as an argument and calls the addMoney event
RegisterCommand('addMoney', function(source, args, rawCommand)
    -- get the source of the command
    local source = source
    -- get the amount from the command arguments
    local amount = tonumber(args[1])
    -- check if the amount is a number
    if amount then
        -- trigger the addMoney event for the source with the amount
        TriggerEvent('addMoney', source, amount)
    else
        -- send a message to the source player
        TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Usage: /addMoney [amount]")
    end
end, false)