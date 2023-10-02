-- register event called addMoney
RegisterServerEvent('addMoney')
-- add event handler for addMoney
AddEventHandler('addMoney', function(amount)
    -- get the source of the event
    local source = source
    -- get the player object of the source
    local sourcePlayer = GetPlayerPed(source)
    -- add the amount to the player's money
    MP.AddMoney(sourcePlayer, amount)
    -- send a message to the source player
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You have been given $" .. amount .. "!")
end)