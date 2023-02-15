function createSQLColumn(name)
	local p = promise.new()

	local exists = MySQL.scalar.await("SHOW COLUMNS FROM `users` LIKE '" .. name .. "'")
	if exists then
		return p:resolve(false)
	end

	MySQL.query([[
			ALTER TABLE `users`
			ADD COLUMN `]] .. name .. [[` INT(11) NULL DEFAULT '0';
		]], function()
		p:resolve(true)
	end)

	return p
end

CreateThread(function()
	Citizen.Await(createSQLColumn("playedTime"))
	Citizen.Await(createSQLColumn("premiumPoints"))

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

	local playedTime = MySQL.scalar.await("SELECT playedTime FROM users WHERE identifier = ?", { xPlayer.identifier })
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

	exports.oxmysql:update("UPDATE users SET playedTime = ? WHERE identifier = ?", { newTime, xPlayer.identifier })
end

AddEventHandler("playerDropped", function()
	savePlayedTime(source)
end)

ESX.RegisterServerCallback("requestServerAdmins", function(source, cb)
	local result = {}

	for _, player in pairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(player)

		if xPlayer and ADMIN_GROUPS[xPlayer.getGroup()] then
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

	MySQL.query("SELECT * FROM owned_vehicles WHERE owner = ?", { xPlayer.identifier }, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback("requestPremiumStuff", function(source, cb)
	local items = {}

	for _, item in pairs(PREMIUM.items) do
		item.label = ESX.GetItemLabel(item.name)

		if item.label then
			item.img = getItemImagePath(item.name)
			table.insert(items, item)
		end
	end

	cb(getPlayerPP(source), items)
end)

ESX.RegisterServerCallback("buyPremiumItem", function(source, cb, item, typ, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	local currentPP = getPlayerPP(source)

	local item = getItemData(item, typ)
	if not item or not item.price then
		return cb(currentPP)
	end

	if currentPP < item.price then
		return chatbox("Nincs elég prémium pontod!", { 255, 0, 0 }, source)
	end

	if typ == "items" then
		local itemLabel = ESX.GetItemLabel(item.name)
		if not itemLabel then
			return chatbox(("Érvénytelen tárgy! %s"):format(item.name), {255, 0, 0}, source)
		end

		if not xPlayer.canCarryItem(item.name, 1) then
			chatbox("Tárgy nemfér el nálad!", { 255, 0, 0 }, source)
			return cb(currentPP)
		end

		xPlayer.addInventoryItem(item.name, 1)
		takePlayerPP(source, item.price)
		chatbox("Sikeres vásároltál egy " .. itemLabel .. " tárgyat", { 0, 255, 0 }, source)
	elseif typ == "vehicles" then
		takePlayerPP(source, item.price)

		local plate = generatePlate()

		MySQL.insert("INSERT INTO owned_vehicles SET owner = ?, plate = ?, vehicle = ?", {
			xPlayer.identifier,
			plate,
			json.encode({ model = GetHashKey(tostring(item.name)), plate = plate }),
		})

		chatbox("Sikeres jármű vásárlás. Model: " .. label, { 0, 255, 0 }, source)

		return cb(getPlayerPP(source), { item = item, plate = plate })
	elseif typ == "money" then
		takePlayerPP(source, item.price)
		xPlayer.addMoney(item.name)

		chatbox("Sikeres vásároltál " .. item.name .. "$-t", { 0, 255, 0 }, source)
	end

	cb(getPlayerPP(source), spawnVehicle)
end)

function generatePlate()
	local plate = ""

	local str = "abcdefghijklmnopqrstuvwxyz"
	for index = 1, 3 do
		plate = plate .. string.char(str:byte(math.random(1, #str)))
	end

	plate = plate:upper() .. " "

	for index = 1, 3 do
		plate = plate .. math.random(0, 9)
	end

	if MySQL.scalar.await("SELECT plate FROM owned_vehicles WHERE plate = ?", { plate }) then
		return generatePlate()
	end

	return plate
end
