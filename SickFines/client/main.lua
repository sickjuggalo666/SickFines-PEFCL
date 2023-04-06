ESX = exports['es_extended']:getSharedObject()

PlayerData = ESX.GetPlayerData()
local Inventory = exports.ox_inventory

Citizen.CreateThread(function()
    Inventory:displayMetadata({        
        amount = 'Ticket Amount',
        PlayerName = 'Offender Name',
        OfficerName = 'Officer Name',
        date = 'Date'
    })
end)

local function OpenFineMenu()
    local FineInput = lib.inputDialog('Fine Options', {
        {type = 'input', label = 'Enter Player Server ID', description = 'Enter Server ID'},
        {type = 'input', label = 'Enter Fine Amount', description = 'Fine Amount'},
        {type = 'input', label = 'Enter Fine Reason', description = 'Fine Reason', icon = 'hashtag'},
        {type = 'input', label = 'Enter Player Name', description = 'Enter Player Name'},
        {type = 'input', label = 'Enter Your Name', description = 'Enter Your Name'},
        {type = 'date', label = 'Select Todays Date', icon = {'far', 'calendar'}, default = true, format = "MM/DD/YYYY"}
    })
    if not FineInput or FineInput[1] == '' or FineInput[2] == '' or FineInput[3] == '' or FineInput[4] == '' then
        lib.closeInputDialog()
        Cnotify(3, 'Inputs Need to be filled out')
        return
    end

    local id = GetPlayerServerId(FineInput[1])
    local amount = tonumber(FineInput[2])
    local reason = FineInput[3]
    local PlayerName = FineInput[4]
    local OfficerName = FineInput[5]
    local date = FineInput[6]
    local job = PlayerData.job.name

    TriggerServerEvent('SickFines:CheckInvoices', id, amount, reason, PlayerName, OfficerName, date, Job)
end


SetTargetOptions = function ()
    for k,v in pairs(Config.Jobs) do
        local options = {
            {
                name = 'sick:fines',
                icon = 'fa-solid fa-notepad',
                label = 'Open Fine Book',
                canInteract = function(entity, distance, coords, name, bone)
                    if PlayerData.job.name == v.name then
                        return true
                    else
                        return false
                    end
                end,
                onSelect = function()
                    OpenFineMenu()
                end
            }
        }
    end
    exports.ox_target:addGlobalPlayer(options)
end

function CNotify(noty_type,message)
    if noty_type and message then
        if Config.Notifications.Client == 'esx' then
            ESX.ShowNotification(message)

        elseif Config.Notifications.Client == 'okok' then
            if noty_type == 1 then
                exports['okokNotify']:Alert('Fines', message, 2500, 'success')
            elseif noty_type == 2 then
                exports['okokNotify']:Alert('Fines', message, 2500, 'info')
            elseif noty_type == 3 then
                exports['okokNotify']:Alert('Fines', message, 2500, 'error')
            end

        elseif Config.Notifications.Client == 'YOUR_NOTIFICATIONS_HERE' then
            
        end
    end
end