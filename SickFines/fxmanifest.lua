fx_version 'cerulean'
game 'gta5'

name "SickFines"
description "Fine system using PEFCL"
author "SickJuggalo666"
version "1.0.0"
lua54 'yes'

shared_scripts {
	'shared/*.lua',
	'@ox_lib/init.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}
