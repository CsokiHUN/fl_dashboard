ADMIN_GROUPS = {
	admin = true,
	superadmin = true,
	moderator = true,
}

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
