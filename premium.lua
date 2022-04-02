local playerPP = {}

function loadPlayerPP(player)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return 0
	end

	local value = MySQL.scalar.await("SELECT premiumPoints FROM users WHERE identifier = ?", { xPlayer.identifier })

	playerPP[player] = value

	return value
end

function getPlayerPP(player)
	if not playerPP[player] then
		return loadPlayerPP(player)
	end

	return playerPP[player] or 0
end
exports("getPlayerPP", getPlayerPP)

function setPlayerPP(player, value)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return false
	end

	playerPP[player] = value

	MySQL.query("UPDATE users SET premiumPoints = ? WHERE identifier = ?", { value, xPlayer.identifier })

	return true
end
exports("setPlayerPP", setPlayerPP)

function takePlayerPP(player, value)
	local currentPP = getPlayerPP(player)
	if currentPP < value then
		return false
	end

	currentPP = currentPP - value
	setPlayerPP(player, currentPP)

	return true
end
exports("takePlayerPP", takePlayerPP)

RegisterCommand("setpp", function(player, args)
	local xPlayer = ESX.GetPlayerFromId(player)

	if not ADMIN_GROUPS[xPlayer.getGroup()] then
		return chatbox("Nincs jogod ehhez!", { 255, 0, 0 }, player)
	end

	if #args < 2 or not tonumber(args[2]) then
		return chatbox("/setpp [ID] [PP]", { 255, 150, 0 }, player)
	end

	local xTarget = ESX.GetPlayerFromId(args[1] == "me" and player or args[1])
	if not xTarget then
		return chatbox("Játékos nem található!", { 255, 0, 0 }, player)
	end

	local value = math.floor(tonumber(args[2]))
	if value <= 0 then
		return chatbox("Ne má", { 255, 0, 0 }, player)
	end
	setPlayerPP(xTarget.source, value)

	chatbox(
		GetPlayerName(player) .. " beállította a prémium pontjaid. Érték: " .. value,
		{ 0, 255, 0 },
		xTarget.source
	)
end)

RegisterCommand("givepp", function(player, args)
	local xPlayer = ESX.GetPlayerFromId(player)

	if not ADMIN_GROUPS[xPlayer.getGroup()] then
		return chatbox("Nincs jogod ehhez!", { 255, 0, 0 }, player)
	end

	if #args < 2 or not tonumber(args[2]) then
		return chatbox("/givepp [ID] [PP]", { 255, 150, 0 }, player)
	end

	local xTarget = ESX.GetPlayerFromId(args[1] == "me" and player or args[1])
	if not xTarget then
		return chatbox("Játékos nem található!", { 255, 0, 0 }, player)
	end

	local value = math.floor(tonumber(args[2]))
	if value <= 0 then
		return chatbox("Ne má", { 255, 0, 0 }, player)
	end
	setPlayerPP(xTarget.source, getPlayerPP(xTarget.source) + value)

	chatbox(GetPlayerName(player) .. " adott prémium pontot. Mennyiség: " .. value, { 0, 255, 0 }, xTarget.source)
end)

RegisterCommand("takepp", function(player, args)
	local xPlayer = ESX.GetPlayerFromId(player)

	if not ADMIN_GROUPS[xPlayer.getGroup()] then
		return chatbox("Nincs jogod ehhez!", { 255, 0, 0 }, player)
	end

	if #args < 2 or not tonumber(args[2]) then
		return chatbox("/takepp [ID] [PP]", { 255, 150, 0 }, player)
	end

	local xTarget = ESX.GetPlayerFromId(args[1] == "me" and player or args[1])
	if not xTarget then
		return chatbox("Játékos nem található!", { 255, 0, 0 }, player)
	end

	local value = math.floor(tonumber(args[2]))
	if value <= 0 then
		return chatbox("Ne má", { 255, 0, 0 }, player)
	end
	if not takePlayerPP(xTarget.source, value) then
		return chatbox("Játékosnak nem lehet negatívba a prémiumja", { 255, 0, 0 }, player)
	end
	chatbox(GetPlayerName(player) .. " levont prémium pontot. Mennyiség: " .. value, { 0, 255, 0 }, xTarget.source)
end)
