local MP = exports['MP-Base']:GetObject()

math.randomseed(os.time())  -- Seed the random number generator at the beginning of your script

RegisterServerEvent('miner:addStone')
AddEventHandler('miner:addStone', function()
    local source = source
    local amount = math.random(2, 10)
    exports.ox_inventory:AddItem(source, 'stone', amount)
end)

RegisterServerEvent('miner:Extract')
AddEventHandler('miner:Extract', function()
    local source = source
    local amount = math.random(2, 5)
    local stoneCount = exports.ox_inventory:GetItemCount(source, 'stone')
    print('Player has ' .. stoneCount .. ' of stone.')
    if stoneCount == 1 then
        TriggerClientEvent('MP-Elements:SendNotification', 1, 'You need at least two stone to smelt.', 5000)
    else
        print('adding item ore to player inventory')
        exports.ox_inventory:AddItem(source, 'ore', amount)
        print('Removing item stone from player inventory')
        exports.ox_inventory:RemoveItem(source, 'stone', amount)
    end
end)

RegisterServerEvent('miner:Materials')
AddEventHandler('miner:Materials', function()
    local source = source
    if not source then
        print('Source is nil')
        return
    end
    
    local oreCount = exports.ox_inventory:GetItemCount(source, 'ore')
    if not oreCount or oreCount < 2 then
        TriggerClientEvent('MP-Elements:SendNotification', 1, 'You need at least two ores to extract materials.', 5000)
        return
    end
    
    local items = {
        "diamond",  -- Rare
        "gold",     -- Rare
        "aluminum", -- Medium
        "aluminum", -- Medium
        "iron",     -- Common
        "iron",     -- Common
        "iron",     -- Common
        "scrapmetal", -- Common
        "scrapmetal", -- Common
        "scrapmetal"  -- Common
    }
    local selectedItem = getRandomItem(items)
    if not selectedItem then
        print('Selected item is nil')
        return
    end
    
    local random = math.random(2, 8)
    print('Player has ' .. oreCount .. ' ore(s).')
    print('Selected Item is: ' .. selectedItem)
    if selectedItem == 'diamond' then
        exports.ox_inventory:RemoveItem(source, 'ore', random)
        exports.ox_inventory:AddItem(source, 'diamond', random)
    elseif selectedItem == 'aluminum' then
        exports.ox_inventory:RemoveItem(source, 'ore', random)
        exports.ox_inventory:AddItem(source, 'aluminum', random)
    elseif selectedItem == 'gold' then
        exports.ox_inventory:RemoveItem(source, 'ore', random)
        exports.ox_inventory:AddItem(source, 'goldbar', random)
    elseif selectedItem == 'iron' then
        exports.ox_inventory:RemoveItem(source, 'ore', random)
        exports.ox_inventory:AddItem(source, 'iron', random)
    elseif selectedItem == 'scrapmetal' then
        exports.ox_inventory:RemoveItem(source, 'ore', random)
        exports.ox_inventory:AddItem(source, 'scrapmetal', random)
    end
end)


function getRandomItem(tbl)
    if #tbl == 0 then  -- Check if the table is empty
        return nil  -- Return nil if the table has no items
    end
    
    local index = math.random(1, #tbl)  -- Get a random index between 1 and the length of the table
    local selectedItem = tbl[index]  -- Get the item at the randomly selected index
    
    table.remove(tbl, index)  -- Remove the selected item from the table
    
    return selectedItem  -- Return the selected item
end

function giveMoneyForItems()
    local source = source
    local Player = MP.Functions.GetPlayer(source)
    local aluminum = exports.ox_inventory:GetItemCount(source, 'aluminum', nil, true)
    local iron = exports.ox_inventory:GetItemCount(source, 'iron', nil, true)
    local goldbar = exports.ox_inventory:GetItemCount(source, 'goldbar', nil, true)
    local diamond = exports.ox_inventory:GetItemCount(source, 'diamond', nil, true)
    local amount = math.random(150, 1500)
    local RemIron = exports.ox_inventory:RemoveItem(source, 'aluminum', amount)
    if iron >= 10 or aluminum >= 10 or goldbar >= 10 or diamond >= 10 then
        print('iron amount is ' ..iron)
        exports.ox_inventory:RemoveItem(source, 'aluminum', 10)
        exports.ox_inventory:RemoveItem(source, 'iron', 10)
        exports.ox_inventory:RemoveItem(source, 'goldbar', 10)
        exports.ox_inventory:RemoveItem(source, 'diamond', 10)
        exports.ox_inventory:AddItem(source, 'money', amount)
    end
end

  

RegisterNetEvent('miner:HasMats')
AddEventHandler('miner:HasMats', function()
    local source = source
    giveMoneyForItems(source)
end)
