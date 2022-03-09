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
