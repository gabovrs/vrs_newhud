local hudVisible = false
local playerhudVisible = false
local speedometerVisible = false
local seatbeltOn = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

Citizen.CreateThread(function()
    local wait = 250
    while true do
        if ESX.PlayerLoaded then 
            if hudVisible then
                UpdateHud()
            end
        end
        Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
    local wait = 1500
    while true do
        if seatbeltOn then
            DisableControlAction(0, 75)
            wait = 1
        else
            wait = 1500
        end
        Citizen.Wait(wait)
    end
end)

function UpdateHud()
    local pauseMenu = IsPauseMenuActive()

    if pauseMenu then
        showPlayerhud(false)
        showSpeedometer(false)
    else
        showPlayerhud(true)
    end

    local ped = PlayerPedId()
    local pedVehicle = GetVehiclePedIsIn(ped, false)
    local id = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))
    local username = GetPlayerName(PlayerId())
    local isPlayerTalking = NetworkIsPlayerTalking(PlayerId())
    local hour = calculateTimeToDisplay()
    local bool, lightsOn, highbeamsOn = GetVehicleLightsState(pedVehicle)
    local job = ESX.PlayerData.job.label
    local grade = ESX.PlayerData.job.grade_label
    local miclevel, vehicleSpeed, fuel, myhunge, mythirst, blackmoney, bank, money

    local proximity = LocalPlayer.state.proximity.mode

    if proximity == "Normal" then
        miclevel = ".."
    elseif proximity == "Whisper" then
        miclevel = "."
    elseif proximity == "Shouting" then
        miclevel = "..."
    end

    TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
        myhunger = hunger.getPercent()
    end)

    TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
        mythirst = thirst.getPercent()
    end)

    for i=1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == 'black_money' then
              blackmoney = ESX.PlayerData.accounts[i].money
        elseif ESX.PlayerData.accounts[i].name == 'bank' then
              bank = ESX.PlayerData.accounts[i].money
        elseif ESX.PlayerData.accounts[i].name == 'money' then
              money = ESX.PlayerData.accounts[i].money
        end
    end

    if pedVehicle ~= 0 then
        if not pauseMenu then
            showSpeedometer(true)
            fuel = math.ceil(GetVehicleFuelLevel(pedVehicle))
            vehicleSpeed = math.ceil(GetEntitySpeed(pedVehicle) * 3.6)
        end
    else
        if speedometerVisible then
            showSpeedometer(false)
        end

        if seatbeltOn then
            seatbeltOn = false
        end
    end

    SendNUIMessage(
        {
            id = id,
            hour = hour,
            username = username,
            job = job ..': '..grade,
            blackmoney = blackmoney,
            bank = bank,
            money = money,
            mic = isPlayerTalking,
            miclevel = miclevel,
            hunger = myhunger,
            thirst = mythirst,
            fuel = fuel,
            vehiclespeed = vehicleSpeed,
            lightson = lightsOn,
            highbeamson = highbeamsOn,
            seatbelt = seatbeltOn
        }
    )

end

function calculateTimeToDisplay()
	hour = GetClockHours()
	minute = GetClockMinutes()

	if hour <= 9 then
		hour = '0' .. hour
	end

	if minute <= 9 then
		minute = '0' .. minute
	end

    return hour .. ':' .. minute
end

RegisterKeyMapping('togglehud', 'Alternar Hud', 'keyboard', 'delete')

RegisterKeyMapping('togglecinturon', 'Alternar Cinturon', 'keyboard', 'y')

RegisterCommand('togglehud', function()
    showHud(not hudVisible)
end)

RegisterCommand('togglecinturon', function()
    if pedVehicle ~= 0 then
        seatbeltOn = not seatbeltOn
    end
end)

function showHud(boolean)
    SendNUIMessage(
        {
            show = boolean
        }
    )

    hudVisible = boolean
    playerhudVisible = boolean
    speedometerVisible = boolean
end

function showPlayerhud(boolean)
    SendNUIMessage(
        {
            showplayerhud = boolean
        }
    )

    playerhudVisible = boolean
end

function showSpeedometer(boolean)
    SendNUIMessage(
        {
            showspeedometer = boolean
        }
    )

    speedometerVisible = boolean
end

if ESX.PlayerLoaded then
    showHud(true)
end

