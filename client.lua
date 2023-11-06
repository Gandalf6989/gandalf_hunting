
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
    ScriptLoaded()
end)

local OnGoingHuntSession, Timer, License = false, false, false
local StartHuntingSession = {}

function ScriptLoaded()
	Citizen.Wait(1000)
	LoadBlips()
end

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Config.Start.Marker) do
            printDebug(v.Coords.x.."  "..v.Coords.y.."  "..v.Coords.z)
            local distance = GetDistanceBetweenCoords(playerCoords, v.Coords.x, v.Coords.y, v.Coords.z, true)
            if distance < 5.0 then
                sleep = 5
                DrawM(v.Text, v.Type, v.Coords.x, v.Coords.y, v.Coords.z -1, k, 255, 255, 255, 1.5, 15)
                if distance < 0.8 then
                    if IsControlJustReleased(0, Config.Key) then
                        if k == "StartHunting" then
                            if Timer == false then
                                if OnGoingHuntSession == false then
                                    OpenHuntingStartMenu()
                                else
                                    StopHunting()
                                end
                            else
                                ESX.ShowNotification(Config.Start.Text[5])
                            end
                        elseif k == "Shell" then
                            TriggerServerEvent('gandalf_hunting:sell')
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function OpenHuntingStartMenu()
    local elements = {
        {label = Config.Start.Type[1], value = "first"},
        {label = Config.Start.Type[2], value = "second"},
        {label = Config.Start.Type[3], value = "third"}
    }

    ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'starthunting',
		{
			title  = Config.Start.Type.Name,
            align =  Config.Start.Type.Position,
			elements = elements
		},
		function(data, menu)
            local lic = nil
			if data.current.value == "first" then
                lic = "first"
                ESX.TriggerServerCallback("gandalf_hunting:checklicense", function(data)
                    if data == true then
                        License = true
                    elseif data == false then
                        License = false
                    end
                end, lic)
                Citizen.Wait(200)
                if License == true then
				    StartHunting("first")
                else
                    ESX.ShowNotification(Config.Start.Text[2])
                end
                ESX.UI.Menu.CloseAll()
			elseif data.current.value == "second" then
                lic = "second"
                ESX.TriggerServerCallback("gandalf_hunting:checklicense", function(data)
                    if data == true then
                        License = true
                    elseif data == false then
                        License = false
                    end
                end, lic)
                Citizen.Wait(200)
                if License == true then
				    StartHunting("second")
                else
                    ESX.ShowNotification(Config.Start.Text[2])
                end
                ESX.UI.Menu.CloseAll()
			elseif data.current.value == "third" then
                lic = "third"
                ESX.TriggerServerCallback("gandalf_hunting:checklicense", function(data)
                    if data == true then
                        License = true
                    elseif data == false then
                        License = false
                    end
                end, lic)
                Citizen.Wait(200)
                if License == true then
				    StartHunting("third")
                else
                    ESX.ShowNotification(Config.Start.Text[2])
                end
                ESX.UI.Menu.CloseAll()
			end
		end,
		function(data, menu)
			menu.close()
		end
	)
end

function StartHunting(data)
    OnGoingHuntSession = true

    Citizen.CreateThread(function()
        for k, v in ipairs(Config.Start.Animals.Position[data]) do
            local peds = Config.Start.Animals.Type[data]

            local Animals = CreatePed(5, GetHashKey(peds[math.random(#peds)]), v.x, v.y, v.z, 0.0, true, false)
            
            TaskWanderStandard(Animals, true, true)
            SetEntityAsMissionEntity(Animals, true, true)

            local AnimalsBlip = AddBlipForEntity(Animals)
            SetBlipSprite(AnimalsBlip, 153)
            SetBlipColour(AnimalsBlip, 1)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.Start.Blip.Animals)
            EndTextCommandSetBlipName(AnimalsBlip)

            table.insert(StartHuntingSession, {
                id = Animals,
                x = v.x,
                y = v.y,
                z = v.z,
                Blipid = AnimalsBlip
            })
            printDebug(json.encode(StartHuntingSession, {indent = true}))
        end
        while OnGoingHuntSession do
            local sleep = 1000
            local date = 0
            for k, v in ipairs(StartHuntingSession) do
                if DoesEntityExist(v.id) then
                    local AnimalCoords = GetEntityCoords(v.id)
                    local PlayerCoords = GetEntityCoords(PlayerPedId())
                    local AnimalHealth = GetEntityHealth(v.id)
                    
                    local PlayToAnimal = GetDistanceBetweenCoords(PlayerCoords, AnimalCoords, true)

                    if AnimalHealth <= 0 then
                        SetBlipColour(v.Blipid, 3)
                        if PlayToAnimal < 2.0 then
                            sleep = 5

                            Draw3DText(AnimalCoords.x, AnimalCoords.y, AnimalCoords.z+1.0, Config.Start.Text[1])
                            if IsControlJustReleased(0, Config.Key) then
                                
                                if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE')  then
                                    if DoesEntityExist(v.id) then
                                        table.remove(StartHuntingSession, k)
                                        SlaughterAnimal(v.id)
                                    end
                                else
                                    ESX.ShowNotification(Config.Start.Text[3])
                                end
                            end

                        end
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

function SlaughterAnimal(AnimalId)
    local AnimalWeight = nil
    local AnimalNames = GetEntityModel(AnimalId)
	TaskPlayAnim(PlayerPedId(), Config.Start.Animals.Anims.anim[1] , Config.Start.Animals.Anims.anim[2] ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(PlayerPedId(), Config.Start.Animals.Anims.anim2[1] ,Config.Start.Animals.Anims.anim2[2] ,8.0, -8.0, -1, 48, 0, false, false, false )
	
    Citizen.Wait(5000)
	
    ClearPedTasksImmediately(PlayerPedId())

    printDebug(GetEntityModel(AnimalId))
    if GetEntityModel(AnimalId) == -541762431 then --rabbit
        AnimalWeight = Config.Sell.Weight.rabbit
    elseif GetEntityModel(AnimalId) == -664053099 then --deer
        AnimalWeight = Config.Sell.Weight.deer
    elseif GetEntityModel(AnimalId) == -832573324 then --boar
        AnimalWeight = Config.Sell.Weight.boar
    elseif GetEntityModel(AnimalId) == -1389097126 then --orleans
        AnimalWeight = Config.Sell.Weight.orleans
    elseif GetEntityModel(AnimalId) == 1682622302 then --coyote
        AnimalWeight = Config.Sell.Weight.coyote
    elseif GetEntityModel(AnimalId) == 307287994 then --mtlion
        AnimalWeight = Config.Sell.Weight.mtlion
    elseif GetEntityModel(AnimalId) == -417505688 then --panther
        AnimalWeight = Config.Sell.Weight.panther
    elseif GetEntityModel(AnimalId) == nil then
        printDebug("Nincs megadva a hash client oldalon.")
    end

	ESX.ShowNotification(Config.Start.Text[4].." "..AnimalWeight.. 'kg húst')

	TriggerServerEvent("gandalf_hunting:reward", AnimalWeight, AnimalNames)

	DeleteEntity(AnimalId)
end

function StopHunting()
    OnGoingHuntSession = false
    Timer = true

    for k, v in pairs(StartHuntingSession) do
        if DoesEntityExist(v.id) then
            DeleteEntity(v.id)
        end
    end

    local Time = Config.Timer * 60000

    Citizen.SetTimeout(Time, function()
        Timer = false
    end)
end

function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end
end

function printDebug(data)
    if Config.Debug then
        print(data)
    end
end

function DrawM(hint, type, x, y, z, k)
    if k == "StartHunting" then
        if OnGoingHuntSession then
            hint = Config.Start.Marker["StartHunting"].Text2
        elseif not OnGoingHuntSession then
            hint = Config.Start.Marker["StartHunting"].Text
        end
    elseif k == "Shell" then
        hint = Config.Start.Marker["Shell"].Text
    end

    Draw3DText(x, y, z+1.0, hint)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextDropShadow(0, 0, 0, 55)
		SetTextEdge(0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

function LoadBlips()
    Citizen.CreateThread(function()
        for k, v in pairs(Config.Start.Marker) do
            if k == "StartHunting" then
                if Config.Blips.Start == true then
                    local StartBlip = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
                    SetBlipSprite(StartBlip, 442)
                    SetBlipColour(StartBlip, 75)
                    SetBlipScale(StartBlip, 0.7)
                    SetBlipAsShortRange(StartBlip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(Config.Start.Blip.StartHunting)
                    EndTextCommandSetBlipName(StartBlip)
                end
            elseif k == "Shell" then
                if Config.Blips.Shell == true then
                    local StartBlip = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
                    SetBlipSprite(StartBlip, 442)
                    SetBlipColour(StartBlip, 75)
                    SetBlipScale(StartBlip, 0.7)
                    SetBlipAsShortRange(StartBlip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(Config.Start.Blip.Shell)
                    EndTextCommandSetBlipName(StartBlip)
                end
            end
        end
	end)

    LoadAnimDict(Config.Start.Animals.Anims.anim[1])
    LoadAnimDict(Config.Start.Animals.Anims.anim2[1])
    for k, v in pairs(Config.Start.Animals.Type) do
        for key, value in pairs(v) do
            LoadModel(value)
        end
    end
end