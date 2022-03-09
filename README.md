### Dashboard ESX Szerverekhez.

#### Kompatibilis verzió: ESX Legacy

##### Használat

Megnyitás: Home gomb vagy /dashboard parancs

### Exportok

```lua
-- saveSettings() -> Beállítások mentése
exports.fl_dashboard:saveSettings()
```

```lua
-- isSettingEnabled(name: string) -> Beállítás státusz lekérése
--[[
alap beállítások: hud, radar (bővítés: client.lua -> Settings tábla.)
]]
exports.fl_dashboard:isSettingEnabled(name)
```

### Eventek

```lua
--Ez az event akkor fut le mikor változtatod egy beállítás értékét.
RegisterNetEvent("dashboard:settingChanged", function(name, state)
	print(name, state)
end)
```
