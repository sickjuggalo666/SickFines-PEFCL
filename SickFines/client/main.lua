ESX = exports['es_extended']:getSharedObject()

local Job = false
PlayerData = ESX.GetPlayerData()
PlayerJob = PlayerData.job.name

local Inventory = exports.ox_inventory
local Target = exports.ox_target

local function SetUpTargets()
    Refresh()
    Target:addBoxZone({
        coords = vec3(487.5118, -983.9824, 26.2734),
        size = vec3(2, 2, 2),
        rotation = 45,
        debug = false,
        options = {
            {
                name = 'Fines',
                icon = 'fa-solid fa-cube',
                label = 'Open Fine Book',
                canInteract = function(entity, distance, coords, name, bone)
                    if Job then
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
    })

    local options = {
        {
            name = 'sick:fines',
            icon = 'fa-solid fa-notepad',
            label = 'Open Fine Book',
            canInteract = function(entity, distance, coords, name, bone)
                if Job then
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

    Target:addGlobalPlayer(options)
    for k,v in pairs(Config.Jobs) do
        Target:addBoxZone({
            coords = v.coords,
            size = vec3(2, 2, 2),
            rotation = 45,
            debug = false,
            options = {
                {
                    name = 'Fines',
                    icon = 'fa-solid fa-cube',
                    label = 'Open Ticket Storage',
                    canInteract = function(entity, distance, coords, name, bone)
                        if Job then
                            return true
                        else
                            return false
                        end
                    end,
                    onSelect = function()
                        Inventory:openInventory("Stash", v.id)
                    end
                }
            }
        })
    end
end

Citizen.CreateThread(function()
    Inventory:displayMetadata({
        amount = 'Ticket Amount',
        PlayerName = 'Offender Name',
        OfficerName = 'Officer Name',
        date = 'Date'
    })
    SetUpTargets()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler( "esx:setJob", function(job)
    PlayerData.job = job
    if Config.PoliceJobs[PlayerData.job.name] then
        Job = true
    else
        Job = false
    end
end)


local function Refresh()
    Citizen.Wait(100)
    Job = false
    PlayerData = ESX.GetPlayerData()
    if Config.PoliceJobs[PlayerData.job.name] then
        Job = true
    end
end

CreateThread(function()
    while true do
        local sleep = 1000
        local IsLoaded = ESX.IsPlayerLoaded()
        if IsLoaded then
            SetUpTargets()
            Refresh()
        end
        Wait(sleep)
    end
end)

local function OpenFineMenu()
    local FineInput = lib.inputDialog('Fine Options', {
        {type = 'input', label = 'Enter Player Server ID', description = 'Enter Server ID', required = true},
        {type = 'input', label = 'Enter Fine Amount', description = 'Fine Amount', required = true},
        {type = 'input', label = 'Enter Fine Reason', description = 'Fine Reason', required = true},
        {type = 'input', label = 'Enter Player Name', description = 'Enter Player Name', required = true},
        {type = 'input', label = 'Enter Your Name', description = 'Enter Your Name', required = true},
        {type = 'date', label = 'Select Todays Date', icon = {'far', 'calendar'}, default = true, format = "MM/DD/YYYY", required = true}
    })
    if not FineInput or (FineInput[1] == '' or FineInput[2] == '' or FineInput[3] == '' or FineInput[4] == '' or FineInput[5] == '') then
        lib.closeInputDialog()
        CNotify(3, 'Inputs Need to be filled out')
        return
    end
    local id = FineInput[1]
    local amount = tonumber(FineInput[2])
    local reason = FineInput[3]
    local PlayerName = FineInput[4]
    local OfficerName = FineInput[5]
    local date = FineInput[6]
    local job = PlayerJob

    TriggerServerEvent('SickFines:CheckInvoices', id, amount, reason, PlayerName, OfficerName, date, Job)
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