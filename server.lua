ESX  = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("gandalf_hunting:checklicense", function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventoryItem(Config.Start.Items.License).count
    local inventory1 = xPlayer.getInventoryItem(Config.Start.Items.License1).count
    local inventory2 = xPlayer.getInventoryItem(Config.Start.Items.License2).count
    if data == "first" then
        if inventory >= 1 then
            cb(true)
        else
            cb(false)
        end
    elseif data == "second" then
        if inventory1 >= 1 then
            cb(true)
        else
            cb(false)
        end
    elseif data == "third" then
        if inventory2 >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('gandalf_hunting:reward')
AddEventHandler('gandalf_hunting:reward', function(Weight, Item)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Weight >= 1 then
        xPlayer.addInventoryItem(Config.Start.Items.Meat, 1)
    elseif Weight >= 40 then
        xPlayer.addInventoryItem(Config.Start.Items.Meat, 2)
    elseif Weight >= 80 then
        xPlayer.addInventoryItem(Config.Start.Items.Meat, 3)
    elseif Weight >= 160 then
        xPlayer.addInventoryItem(Config.Start.Items.Meat, 4)
    end

    if Item == 1682622302 then
        xPlayer.addInventoryItem(Config.Start.Items.Leather, math.random(2, 8))
    elseif Item == 307287994 then
        xPlayer.addInventoryItem(Config.Start.Items.LuxusLeather, math.random(2, 8))
    elseif Item == -417505688 then
        xPlayer.addInventoryItem(Config.Start.Items.LuxusLeather, math.random(2, 8))
    end
end)


RegisterServerEvent("gandalf_hunting:sell")
AddEventHandler("gandalf_hunting:sell", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local MeatQuantity = xPlayer.getInventoryItem(Config.Start.Items.Meat).count
    local LeatherQuantity = xPlayer.getInventoryItem(Config.Start.Items.Leather).count
    local LuxusLeatherQuantity = xPlayer.getInventoryItem(Config.Start.Items.LuxusLeather).count

    if MeatQuantity > 0 or LeatherQuantity > 0 or LuxusLeatherQuantity > 0 then

        if Config.BlackMoney.meat == true and MeatQuantity > 0 then
            xPlayer.removeInventoryItem(Config.Start.Items.Meat, MeatQuantity)
            xPlayer.addAccountMoney("black_money", MeatQuantity * Config.Sell.Price.Meat)
        elseif Config.BlackMoney.leather == true and LeatherQuantity > 0 then
            xPlayer.removeInventoryItem(Config.Start.Items.Leather, LeatherQuantity)
            xPlayer.addAccountMoney("black_money", LeatherQuantity * Config.Sell.Price.Leather)
        elseif Config.BlackMoney.luxusleather == true and LuxusLeatherQuantity > 0 then
            xPlayer.removeInventoryItem(Config.Start.Items.LuxusLeather, LuxusLeatherQuantity)
            xPlayer.addAccountMoney("black_money", LuxusLeatherQuantity * Config.Sell.Price.LuxusLeather)
        elseif Config.BlackMoney.meat == false and MeatQuantity > 0 then
            xPlayer.removeInventoryItem(Config.Start.Items.Meat, MeatQuantity)
            xPlayer.addAccountMoney("money", MeatQuantity * Config.Sell.Price.Meat)
        elseif Config.BlackMoney.leather == false and LeatherQuantity > 0 then
            xPlayer.removeInventoryItem(Config.Start.Items.Leather, LeatherQuantity)
            xPlayer.addAccountMoney("money", LeatherQuantity * Config.Sell.Price.Leather)
        elseif Config.BlackMoney.luxusleather == false and LuxusLeatherQuantity > 0 then
            xPlayer.removeInventoryItem(Config.Start.Items.LuxusLeather, LuxusLeatherQuantity)
            xPlayer.addAccountMoney("money", LuxusLeatherQuantity * Config.Sell.Price.LuxusLeather)
        end

        TriggerClientEvent('esx:showNotification', xPlayer.source, "Eladtál összesen " .. LeatherQuantity + MeatQuantity + LuxusLeatherQuantity .. " húst, bört és luxusbört kaptál $" .. Config.Sell.Price.LuxusLeather * LuxusLeatherQuantity + Config.Sell.Price.Leather * LeatherQuantity + Config.Sell.Price.Meat * MeatQuantity)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nincs nálad elég hús, bör, luxusbör')
    end 
end)