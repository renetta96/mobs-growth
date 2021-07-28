-- This information tells other players more about the mod
name = "Mobs Growth"
description = ""
author = "Zeta"
version = "1.0.1.2" -- This is the version of the template. Change it to your own number.

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = ""


-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true

-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false

-- Character mods need this set to true
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {
	"tweaks",
	"hardcore",
	"growth"
}

configuration_options = {
	{
		name = 'GROWTH_INTERVAL',
		label = 'Growth interval',
		options = {
			{ description = '10 days', data = 10 },
			{ description = '20 days', data = 20 },
			{ description = '30 days', data = 30 },
			{ description = '40 days', data = 40 },
			{ description = '50 days', data = 50 },
			{ description = '60 days', data = 60 },
			{ description = '70 days', data = 70 },
			{ description = '80 days', data = 80 },
			{ description = '90 days', data = 90 },
			{ description = '100 days', data = 100 },
		},
		default = 50,
		hover = 'How many days per growth'
	},
	{
		name = 'MOB_HEALTH_GROWTH_RATE',
		label = 'Mob health growth rate',
		options = {
			{ description = '10%', data = 0.1 },
			{ description = '20%', data = 0.2 },
			{ description = '30%', data = 0.3 },
			{ description = '40%', data = 0.4 },
			{ description = '50%', data = 0.5 },
			{ description = '60%', data = 0.6 },
			{ description = '70%', data = 0.7 },
			{ description = '80%', data = 0.8 },
			{ description = '90%', data = 0.9 },
			{ description = '100%', data = 1 },
		},
		default = 0.3,
		hover = 'How much health mobs grow each interval'
	},
	{
		name = 'MOB_DAMAGE_GROWTH_RATE',
		label = 'Mob damage growth rate',
		options = {
			{ description = '10%', data = 0.1 },
			{ description = '20%', data = 0.2 },
			{ description = '30%', data = 0.3 },
			{ description = '40%', data = 0.4 },
			{ description = '50%', data = 0.5 },
			{ description = '60%', data = 0.6 },
			{ description = '70%', data = 0.7 },
			{ description = '80%', data = 0.8 },
			{ description = '90%', data = 0.9 },
			{ description = '100%', data = 1 },
		},
		default = 0.2,
		hover = 'How much damage mobs grow each interval'
	},
	{
		name = 'BOSS_HEALTH_GROWTH_RATE',
		label = 'Boss health growth rate',
		options = {
			{ description = '10%', data = 0.1 },
			{ description = '20%', data = 0.2 },
			{ description = '30%', data = 0.3 },
			{ description = '40%', data = 0.4 },
			{ description = '50%', data = 0.5 },
			{ description = '60%', data = 0.6 },
			{ description = '70%', data = 0.7 },
			{ description = '80%', data = 0.8 },
			{ description = '90%', data = 0.9 },
			{ description = '100%', data = 1 },
		},
		default = 0.3,
		hover = 'How much health bosses grow each interval'
	},
	{
		name = 'BOSS_DAMAGE_GROWTH_RATE',
		label = 'Boss damage growth rate',
		options = {
			{ description = '10%', data = 0.1 },
			{ description = '20%', data = 0.2 },
			{ description = '30%', data = 0.3 },
			{ description = '40%', data = 0.4 },
			{ description = '50%', data = 0.5 },
			{ description = '60%', data = 0.6 },
			{ description = '70%', data = 0.7 },
			{ description = '80%', data = 0.8 },
			{ description = '90%', data = 0.9 },
			{ description = '100%', data = 1 },
		},
		default = 0.2,
		hover = 'How much damage bosses grow each interval'
	},
}
