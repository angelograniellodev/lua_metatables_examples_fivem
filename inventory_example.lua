ESX = exports["es_extended"]:getSharedObject()
local inventory = {}



local inventoryMeta = {
    __index = function (table, key)
        return rawget(table, key) or 0
    end,

    __newindex = function(table, key, value)
        if value < 0 then
            ESX.ShowNotification("Cantidad erronea, tiene que ser mas de 0")
        else
            rawset(table, key, value)
        end
    end
}

setmetatable(inventory, inventoryMeta)

function AddItem(item, quantity)
    inventory[item] = inventory[item] + quantity
end

function RemoveItem(item, quantity)
    if inventory[item] >= quantity then
        inventory[item] = inventory[item] - quantity
    else
        ESX.ShowNotification("No tienes suficientes de esto")
    end
end

function OpenInventory()
    local elements = {}

    for item, quantity in pairs(inventory) do
        table.insert(elements, { label = item .. ": " .. quantity, value = item })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_menu', {
        title    = 'Personal Inventory',
        align    = 'bottom-right',
        elements = elements
    }, function(data, menu)

    end, function(data, menu)
        menu.close()
    end)

end

function UsableItem(itemname)
    --soon
end

RegisterCommand("additem", function(source, args, rawCommand)
    if #args < 2 then
        ESX.ShowNotification("Uso: /additem [nombre_item] [cantidad]")
        return
    end
    local itemName = args[1]
    local quantity = tonumber(args[2])
    AddItem(itemName, quantity)
    ESX.ShowNotification("Item agregado: " .. itemName .. " Cantidad: " .. quantity)
    menu.close()
end, false)

RegisterCommand("removeitem", function(source, args, rawCommand)
    if #args < 2 then
        ESX.ShowNotification("Uso: /removeitem [nombre_item] [cantidad]")
        return
    end
    local itemName = args[1]
    local quantity = tonumber(args[2])
    RemoveItem(itemName, quantity)
    ESX.ShowNotification("Item Eliminado: " .. itemName .. " Cantidad: " .. quantity)
    menu.close()
end, false)

RegisterCommand("openinv", function ()
    OpenInventory()
end, false)

RegisterKeyMapping('openinv', 'Abrir Inventario', 'keyboard', 'I')