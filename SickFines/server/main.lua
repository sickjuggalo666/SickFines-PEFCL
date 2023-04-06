ESX = exports['es_extended'];getSharedObject()

local Bank = exports.pefcl

local Inventory = exports.ox_inventory

Citizen.CreateThread(function()
    for k, v in pairs(Config.Jobs) do
        local tickets = {
            id = v.id,
            label = v.label,
            slots = v.slots,
            maxWeight = v.maxWeight,
            groups = { [v.name] = v.rank }
        }

        Inventory:RegisterStash(tickets.id, tickets.label, tickets.slots, tickets.maxWeight, nil, tickets.groups)
    end
end)

RegisterNetEvent('SickFines:CheckInvoices')
AddEventHandler('SickFines:CheckInvoices', function(id, amount, reason, PlayerName, OfficerName, date, Job)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromId(id)
    Bank:createInvoice(source, {
        to = PlayerName,
        toIdentifier = target.identifier,
        from = OfficerName,
        fromIdentifier = xPlayer.identifier,
        amount = amount,
        message = reason,
        receiverAccountIdentifier = Job
    })

    local info = {
        amount = amount,
        PlayerName = PlayerName,
        OfficerName = OfficerName,
        date = date
    }

    Inventory:AddItem('police_tickets', 'ticket', 1, info )

end)