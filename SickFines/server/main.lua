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
        print(('Creating Inventory for %s, Label: %s, Slots: %s, MaxWeight: %s, Groups: %s'):format(id,label,slots,maxWeight,groups))
    end
end)

local Discord_url = '' -- server side to protect you webhooks

local function LetEmKnow(color, name, message, footer)
    local embed = {
        {
            ["color"] = 3085967,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer,
            },
            ["author"] = {
            ["name"] = 'Made by | SickJuggalo666',
            ['icon_url'] = 'https://i.imgur.com/arJnggZ.png'
            }
        }
    }
      
    PerformHttpRequest(Discord_url, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('SickFines:CheckInvoices')
AddEventHandler('SickFines:CheckInvoices', function(id, amount, reason, PlayerName, OfficerName, date, Job)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local target = ESX.GetPlayerFromId(id)
    if xPlayer ~= nil then return end

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

    if exports.ox_inventory:CanCarryItem(source, 'ticket', 1) then
        Inventory:AddItem(source, 'ticket', 1, info )
    else
        Inventory:AddItem('police_tickets', 'ticket', 1, info)
    end

    if exports.ox_inventory:CanCarryItem(id, 'ticket', 1) then
        Inventory:AddItem(source, 'ticket', 1, info )
    end
    local name = "Sick Ticket System"
    local message = (('%s Issued a Ticket to %s, \nReaon: %s, \nAmount $:'..amount):format(OfficerName,PlayerName,reason,amount))
    LetEmKnow(name,message)

end)