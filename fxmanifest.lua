fx_version("cerulean")
game("gta5")
author("Csoki")

shared_script("@es_extended/imports.lua")
client_script("client.lua")
server_script("server.lua")

files({
	"ui/dist/**",
})

ui_page("ui/dist/index.html")
