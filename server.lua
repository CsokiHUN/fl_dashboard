CreateThread(function()
	for _, player in pairs(GetPlayers()) do
		print(player, " - ", GetPlayerName(player))

		if not Player(player).state.joinTime then
			Player(player).state.joinTime = os.time()
		end

		print(GetPlayerName(player), Player(player).state.joinTime)
	end
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

	table.insert(result, { title = "Játszott idő", value = "TODO", color = "red" })

	local joinTime = Player(source).state.joinTime or os.time()
	table.insert(result, { title = "Online Idő", value = secondsToClock(os.time() - joinTime), color = "yellow" })

	cb(result)
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
