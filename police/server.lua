
--create a function that detects if the player's job is ems or EMS and adds the player to the EMTs table
function setJob(id, job)
    if job == 'ems' or job == 'EMS' then
        table.insert(EMTs, id)
        print('Player ' .. id .. ' has been added to the EMTs table')
        print(json.encode(EMTs, {indent=true}))
    else
        -- if player is not an EMT, remove them from the EMTs table
        for k, v in pairs(EMTs) do
            if v == id then
                table.remove(EMTs, k)
                print('Player ' .. id .. ' has been removed from the EMTs table')
                print(json.encode(EMTs, {indent=true}))
            end
        end
    end
end


-- Create a job called setjob with the player id as the first argument and the job as the second argument
RegisterCommand('setjob', function(source, args)
    local id = tonumber(args[1])
    local job = args[2]
    local grade = tonumber(args[3])
    if id and job and grade then
        TriggerServerEvent('ox:setGroup', id, job, grade)
        -- send a message to player that their job updated
        TriggerClientEvent('chatMessage', source, 'JOB', {255, 0, 0}, 'Your job has been updated to ' .. job)
    else
        -- send a message to player that they need to enter a valid job
        TriggerClientEvent('chatMessage', source, 'SERVER: ', {255, 0, 0}, 'Invalid use! /setjob [id] [job]')
    end
end, false)




-- When the player leaves the server, change their job to 'unemployed' and remove them from the EMTs table
AddEventHandler('playerDropped', function()
    job = 'unemployed'
    for k, v in pairs(EMTs) do
        if v == source then
            table.remove(EMTs, k)
        end
    end
end)