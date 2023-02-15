Settings = {
	radar = {
		label = "Radar megjelenítése",
		state = true,
		defaultValue = true,
		callback = function(value)
			DisplayRadar(value)
		end,
	},
	hud = {
		label = "HUD megjelenítése",
		state = true,
		defaultValue = true,
		callback = function(value)
			if ESX.UI and ESX.UI.HUD then
				ESX.UI.HUD.SetDisplay(value and 1 or 0)
			end
		end,
	},
}

if GetResourceState('fl_nametag') == "started" then 
	Settings.myname = {
		label = "Saját név megjelenítése",
		state = exports.fl_nametag:getMyNameVisible(),
		defaultValue = true,
		callback = function(value)
			exports.fl_nametag:setMyNameVisible(value)
		end
	}
end

Panel = {
	visible = false,

	requestFunctions = {
		admins = function(cb)
			ESX.TriggerServerCallback("requestServerAdmins", function(result)
				cb({ admins = result })
			end)
		end,

		cards = function(cb)
			ESX.TriggerServerCallback("requestPlayerDatas", function(result, playerName)
				cb({ cards = result, playerName = playerName })
			end)
		end,

		property = function(cb)
			ESX.TriggerServerCallback("requestPlayerVehicles", function(result)
				local vehicles = {}

				for _, vehicleData in pairs(result) do
					if vehicleData and vehicleData.vehicle then
						local vehicle = json.decode(vehicleData.vehicle)
						local name = GetDisplayNameFromVehicleModel(vehicle.model)

						table.insert(vehicles, {
							plate = vehicleData.plate or "Ismeretlen",
							name = name or "Ismeretlen",
							label = GetLabelText(name) or "Ismeretlen",
							state = math.floor((vehicle.bodyHealth or 1000) / 10),
							fuel = vehicle.fuelLevel or 0,
							stored = (vehicleData.stored or 0) == 1,
							vehicle = vehicle,
						})
					end
				end

				cb({ vehicles = vehicles })
			end)
		end,
	},

	init = function(self)
		RegisterCommand("dashboard", function()
			self:toggle()
		end)
		CreateThread(function()
			Wait(1)
			RegisterKeyMapping("dashboard", "Dashboard megnyitasa", "keyboard", "HOME")
		end)

		RegisterNUICallback("close", function(...)
			self:toggle(...)
		end)

		RegisterNUICallback("requestData", function(data, cb)
			self:request(data.name, cb)
		end)

		RegisterNUICallback("updateSetting", function(data)
			if not Settings[data.name] then
				return
			end

			Settings[data.name].state = data.checked
			Settings[data.name].callback(data.checked)

			if not data.storeLoad then
				TriggerEvent("dashboard:settingChanged", data.name, data.checked)
			end
		end)

		CreateThread(function()
			local settings = {}

			for name, data in pairs(Settings) do
				table.insert(settings, { name = name, label = data.label, defaultValue = data.defaultValue })
			end

			SendNUIMessage({
				loadSettings = settings,
			})
		end)

		CreateThread(function()
			local money = {}
			local vehicles = {}

			for _, item in pairs(PREMIUM.money) do
				item.label = item.name .. "$"
				table.insert(money, item)
			end
			PREMIUM.money = money

			for _, vehicle in pairs(PREMIUM.vehicles) do
				vehicle.label = GetLabelText(vehicle.name) or "Ismeretlen"
				table.insert(vehicles, vehicle)
			end
			PREMIUM.vehicles = vehicles
		end)

		-- Premium shits
		RegisterNUICallback("getPremiumStuff", function(data, cb)
			ESX.TriggerServerCallback("requestPremiumStuff", function(currentPP, items)
				cb({
					currentPP = currentPP,
					items = items,
					vehicles = PREMIUM.vehicles,
					money = PREMIUM.money,
				})
			end)
		end)

		RegisterNUICallback("buyPremiumItem", function(data, cb)
			if not data.item then
				return cb({})
			end

			ESX.TriggerServerCallback("buyPremiumItem", function(currentPP, vehicleData)
				if vehicleData and vehicleData.item and vehicleData.plate then
					local playerPed = PlayerPedId()

					ESX.Game.SpawnVehicle(
						vehicleData.item.name,
						GetEntityCoords(playerPed) + vector3(0, 1.5, 0),
						GetEntityHeading(playerPed),
						function(vehicle)
							ESX.Game.SetVehicleProperties(vehicle, { plate = vehicleData.plate })
						end
					)
				end

				cb({ currentPP = currentPP })
			end, data.item, data.typ, data.item.label)
		end)
	end,

	toggle = function(self)
		self.visible = not self.visible

		SendNUIMessage({
			visible = self.visible,
		})
		SetNuiFocus(self.visible, self.visible)

		if not self.visible then
			saveSettings()
		end
	end,

	request = function(self, name, cb)
		if not self.requestFunctions[name] then
			return cb({})
		end

		self.requestFunctions[name](cb)
	end,
}
Panel.__index = Panel

function saveSettings()
	local settings = {}

	for setting, data in pairs(Settings) do
		table.insert(settings, { name = setting, state = data.state })
	end

	SendNUIMessage({
		saveSettings = settings,
	})
end
exports("saveSettings", saveSettings)

function isSettingEnabled(name)
	return Settings[name] and Settings[name].state or false
end
exports("isSettingEnabled", isSettingEnabled)

--[[
	--Custom event for settings	
	RegisterNetEvent("dashboard:settingChanged", function(name, state)
		print(name, state)
	end)
]]

CreateThread(function()
	Wait(500)

	while not ESX.IsPlayerLoaded() do
		Wait(1)
	end

	Panel:init()
end)

RegisterNetEvent("esx:playerLoaded", function()
	TriggerServerEvent(GetCurrentResourceName() .. "->playerLoaded")
end)
