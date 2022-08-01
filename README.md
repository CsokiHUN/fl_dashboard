### Dashboard ESX Szerverekhez.

#### Szükséges scriptek

##### - [oxmysql](https://github.com/overextended/oxmysql)

#### Opcionális scriptek

##### - [fl_nametag](https://github.com/fivemland/fl_nametag) - Beállításokban kapcsolható a saját név megjelenítése

#### Kompatibilis verzió: ESX Legacy

#### [Preview](https://streamable.com/9wtxdh 'https://streamable.com/9wtxdh')

#### [Preview](https://streamable.com/bbpc0f 'https://streamable.com/bbpc0f')

##### Csatlakozz te is a FiveM Land discordjához, hogy további finomságokat találj! Discord: https://discord.gg/Zdaqj5EM5Z

### Használat

Megnyitás: Home gomb vagy /dashboard parancs

### Parancsok

- /setpp -> Játékos prémium pontjainak beállítása
- /givepp -> Játékos prémium pontjaihoz hozzáadás
- /takepp -> Játékos prémium pontjaiból levonás

### Exportok

#### Client

##### saveSettings()

- Beállítások mentése

```lua
exports.fl_dashboard:saveSettings()
```

##### isSettingEnabled(name)

- Beállítás státusz lekérése
- return -> boolean
- alap beállítások: hud, radar (bővítés: client.lua -> Settings tábla.)

```lua
exports.fl_dashboard:isSettingEnabled(name)
```

#### Server

##### getPlayerPP(player)

- játékos prémium pontjainak lekérése
- return -> number

```lua
exports.fl_dashboard:getPlayerPP(player)
```

##### setPlayerPP(player)

- játékos prémium pontjainak beállítása
- return boolean

```lua
exports.fl_dashboard:setPlayerPP(player)
```

##### takePlayerPP(player)

- játékos prémium pontjaiból levonás
- return boolean

```lua
exports.fl_dashboard:takePlayerPP(player, value)
```

### Eventek

#### Client

```lua
--Ez az event akkor fut le mikor változtatod egy beállítás értékét.
RegisterNetEvent("dashboard:settingChanged", function(name, state)
	print(name, state)
end)
```
