function createSQLColumn(name)
	local exists = MySQL.Sync.fetchScalar("SHOW COLUMNS FROM `users` LIKE '" .. name .. "'")
	if not exists then
		MySQL.Async.execute([[
			ALTER TABLE `users`
			ADD COLUMN `]] .. name .. [[` INT(11) NULL DEFAULT '0';
		]])
	end
end

CreateThread(function()
	createSQLColumn("playedTime")
	createSQLColumn("premiumPoints")

	for _, player in pairs(GetPlayers()) do
		local sb = Player(player).state

		if not sb.joinTime then
			Player(player).state.joinTime = os.time()
		end

		if not sb.playedTime then
			loadPlayerPlayedTime(player)
		end

		loadPlayerPP(player)
	end
end)

RegisterNetEvent(GetCurrentResourceName() .. "->playerLoaded", function()
	Player(source).state.joinTime = os.time()
	loadPlayerPlayedTime(source)
end)

function loadPlayerPlayedTime(player)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return
	end

	local playedTime = MySQL.Sync.fetchScalar(
		"SELECT playedTime FROM users WHERE identifier = ?",
		{ xPlayer.identifier }
	)
	Player(player).state.playedTime = playedTime
end

function savePlayedTime(player)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return
	end

	local sb = Player(player).state
	local oldTime = sb.playedTime or 0
	local joinTime = sb.joinTime or os.time()
	local newTime = oldTime + (os.time() - joinTime)

	MySQL.Async.execute("UPDATE users SET playedTime = ? WHERE identifier = ?", { newTime, xPlayer.identifier })
end

AddEventHandler("playerDropped", function()
	savePlayedTime(source)
end)

ESX.RegisterServerCallback("requestServerAdmins", function(source, cb)
	local result = {}

	for _, player in pairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(player)

		if xPlayer and xPlayer.getGroup() ~= "user" then
			table.insert(result, {
				id = player,
				group = xPlayer.getGroup(),
				name = GetPlayerName(player),
			})
		end
	end

	cb(result)
end)

ESX.RegisterServerCallback("requestPlayerDatas", function(source, cb)
	local result = {}

	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then
		return cb({})
	end

	table.insert(result, { title = "ID", value = source })
	table.insert(result, { title = "Steam Név", value = GetPlayerName(source) })
	table.insert(result, { title = "Születési idő", value = xPlayer.variables.dateofbirth })
	table.insert(result, { title = "Magasság", value = xPlayer.variables.height .. "cm" })

	for _, account in pairs(xPlayer.accounts) do
		table.insert(
			result,
			{ title = account.label, value = account.money .. "$", color = account.money >= 0 and "green" or "red" }
		)
	end

	local currentPP = getPlayerPP(source)
	table.insert(result, {
		title = "Prémium Pont",
		value = currentPP .. "PP",
		color = currentPP >= 0 and "green" or "red",
	})

	local vehicleCount = MySQL.Sync.fetchScalar(
		"SELECT COUNT(*) FROM owned_vehicles WHERE owner = ?",
		{ xPlayer.identifier }
	)

	table.insert(result, { title = "Járművek", value = vehicleCount .. "db" })

	table.insert(result, { title = "Group", value = xPlayer.getGroup() })
	table.insert(result, { title = "Munka", value = xPlayer.job and xPlayer.job.label or "Ismeretlen" })
	table.insert(result, { title = "Rang", value = xPlayer.job and xPlayer.job.grade_label or "Ismeretlen" })
	table.insert(
		result,
		{ title = "Fizetés", value = xPlayer.job and xPlayer.job.grade_salary .. "$" or "Nincs 😢", color = "green" }
	)

	table.insert(result, { title = "Identifier", value = xPlayer.identifier, color = "red", blur = true })

	local sb = Player(source).state
	local joinTime = sb.joinTime or os.time()
	local currentSessionTime = os.time() - joinTime
	local playedTime = (sb.playedTime or 0) + currentSessionTime

	table.insert(result, { title = "Játszott idő", value = secondsToClock(playedTime), color = "yellow" })
	table.insert(result, { title = "Online Idő", value = secondsToClock(currentSessionTime), color = "yellow" })

	cb(result, xPlayer.getName())
end)

ESX.RegisterServerCallback("requestPlayerVehicles", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then
		return cb({})
	end

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = ?", { xPlayer.identifier }, function(result)
		cb(result)
	end)
end)
