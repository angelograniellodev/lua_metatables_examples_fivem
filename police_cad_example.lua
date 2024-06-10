local policeRecords = {}

local policeRecordsMeta = {
    __index = function (table, key)
        if not rawget(table, key) then
            print("ERROR: No se encontró el registro para '" .. key .. "'.")
            return nil
        end
        return rawget(table, key)
    end,

    __newindex = function(table, key, value)
        if rawget(table, key) then
            print("Error: El registro para '" .. key .. "' ya existe.")
        else
            rawset(table, key, value)
            print("Registro agregado para '" .. key .. "'.")
        end
    end
}

setmetatable(policeRecords, policeRecordsMeta)

function AddCriminalRecords(name, details)
    policeRecords[name] = details
end

function ShowAllCriminalRecords()
    print("Resultados: ")
    for name, details in pairs(policeRecords) do
        print("Nombre: " .. name .. ", Detalles: " .. details)
    end
end

RegisterCommand("newcriminalrecord", function(source, args, rawCommand)
    if #args < 2 then
        print("Uso: /newcriminalrecord [nombre] [crimen]")
        return
    end
    local playerName = args[1]
    local crime = table.concat(args, " ", 2)
    AddCriminalRecords(playerName, crime)
    print(policeRecords[playerName])
end, false)

RegisterCommand("showcriminalrecords", function(source, args, rawCommand)
    ShowAllCriminalRecords()
end, false)
