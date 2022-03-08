ESX.RegisterServerCallback("requestServerAdmins", function(source, cb)
	local result = {}

	for _, player in pairs(ESX.GetPlayers()) do
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
