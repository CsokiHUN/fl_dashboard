Panel = {
	visible = false,

	init = function(self)
		RegisterCommand("dashboard", function()
			self:toggle()
		end)
		RegisterKeyMapping("dashboard", "Dashboard megnyitasa", "keyboard", "HOME")

		RegisterNUICallback("requestAdmins", function(...)
			self:getAdmins(...)
		end)

		RegisterNUICallback("close", function(...)
			self:toggle(...)
		end)

		-- TODO: TEST!!!
		SendNUIMessage({
			visible = false,
		})
	end,

	toggle = function(self)
		self.visible = not self.visible

		SendNUIMessage({
			visible = self.visible,
		})
		SetNuiFocus(self.visible, self.visible)
		print("toggleDash", self.visible)
	end,

	getAdmins = function(self, data, cb)
		ESX.TriggerServerCallback("requestServerAdmins", function(result)
			cb({ admins = result })
		end)
	end,
}
Panel.__index = Panel

CreateThread(function()
	Wait(500)
	Panel:init()
end)
