ADMIN_GROUPS = {
	admin = true,
	superadmin = true,
	moderator = true,
}

PREMIUM = {
	items = {
		{
			name = "burger",
			price = 100,
		},
		{
			name = "beer",
			price = 100,
		},
		{
			name = "cola",
			price = 5,
		},
	},
	vehicles = {
		{
			name = "sultan",
			price = 100,
		},
		{
			name = "sultanrs",
			price = 100,
		},
		{
			name = "enduro",
			price = 10000,
		},
	},
	money = {
		{ price = 1000, name = 1000, img = "http://pluspng.com/img-png/money-png--3179.png" },
		{ price = 500, name = 10000, img = "http://pluspng.com/img-png/money-png--3179.png" },
	},
}

function getItemImagePath(itemName)
	return "nui://ox_inventory/web/images/" .. itemName .. ".png"
end

function getItemData(Item, typ)
	for _, item in pairs(PREMIUM[typ]) do
		if item.name == Item.name and item.price then
			return item
		end
	end

	return false
end

function secondsToClock(seconds)
	local seconds = tonumber(seconds)
	if not seconds then
		return "00:00:00"
	end

	if seconds <= 0 then
		return "00:00:00"
	end
	local hours = string.format("%02.f", math.floor(seconds / 3600))
	local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
	local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

	return hours .. ":" .. mins .. ":" .. secs
end

function chatbox(message, color, target)
	local msg = {
		color = color or { 255, 255, 255 },
		multiline = true,
		args = { "Szerver", message },
	}

	if IsDuplicityVersion() then
		TriggerClientEvent("chat:addMessage", target or -1, msg)
		return
	end

	TriggerEvent("chat:addMessage", msg)
end
