fx_version "cerulean"
game "gta5"
author "Csoki"

dependency "es_extended"
dependency "oxmysql"

shared_scripts { "@es_extended/imports.lua", "shared.lua" }
client_script "client.lua"
server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"premium.lua",
	"server.lua",
}

files {
	"ui/dist/**",
}

ui_page "ui/dist/index.html"
-- ui_page("http://192.168.1.17:8080")
