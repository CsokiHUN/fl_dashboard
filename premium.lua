local playerPP = {}

function loadPlayerPP(player)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return 0
	end

	local value = MySQL.Sync.fetchScalar("SELECT premiumPoints FROM users WHERE identifier = ?", { xPlayer.identifier })

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

	MySQL.Async.execute("UPDATE users SET premiumPoints = ? WHERE identifier = ?", { value, xPlayer.identifier })

	return true
end
exports("setPlayerPP", setPlayerPP)

RegisterCommand("setpp", function(player, args, cmd)
	local xPlayer = ESX.GetPlayerFromId(player)

	if not ADMIN_GROUPS[xPlayer.getGroup()] then
		return chatbox("Nincs jogod ehhez!", { 255, 0, 0 }, player)
	end

	if #args < 2 or not tonumber(args[1]) or not tonumber(args[2]) then
		return chatbox("/" .. cmd .. " [ID] [PP]", { 255, 150, 0 }, player)
	end

	local xTarget = ESX.GetPlayerFromId(args[1])
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
