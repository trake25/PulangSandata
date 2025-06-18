extends WorldBuilding_Data

class_name Settlement_Data

func _init() -> void:
	world_building_type = "Settlement"
	resources = {
		"food": randi_range(105,255),     
		"wood": randi_range(105,255),    
		"weapons": randi_range(105,255),
		"wealth": randi_range(105,255),
	}
	
	production = 1
	population = randi_range(105,255)
	population_limit = int((resource_capacity["food"] + resource_capacity["wood"] 
	+ resource_capacity["weapons"] + resource_capacity["wealth"]) / 4)
	contentment = randi_range(63,87)
	
	upgrades = {
		"Fortress": {
			"local_name": "Kuta",
			"description": "Center gathering of garrisoned units. +3 unit deployment limit",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false, 
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Watch Tower": {
			"local_name": "Bantayan",
			"description": "A watch tower to oversee surrounding area. Provides 1 tile vision over fog of war per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Housing": {
			"local_name": "Bahay Kubo",
			"description": "Housing for Freemen/Commoners. Increase population limit 1000 per level",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Cook Sheds": {
			"local_name": "Batalan",
			"description": "House extension outdoor kitchen. Increase food production by 1% per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Woodworks": {
			"local_name": "Panday Kahoy",
			"description": "Center for carpentry. Increase wood production by 1% per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Forge": {
			"local_name": "Pandayan",
			"description": "Center for weapon production. Increase weapons production by 1% per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Market": {
			"local_name": "Pamilihan/Talipapa",
			"description": "Center for goods trading. Increase wealth production by 1% per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Granary": {
			"local_name": "Kamalig",
			"description": "Food storage facility. Increase food storage capacity by 500 per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Depot Huts": {
			"local_name": "Bahay Imbakan",
			"description": "Materials storage facility. Increase wood storage capacity by 500 per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Armory": {
			"local_name": "Sandatahan",
			"description": "Weapon storage facility. Increase weapon storage capacity by 500 per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Noble House": {
			"local_name": "Balay Datu/Lakan/Rajah",
			"description": "Ruling Faction's residence. Increase wealth storage capacity by 500 per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Laborer Huts": {
			"local_name": "Bahay Alipin",
			"description": "Housing for the slaves and labour-debt. Allows recruitment of laborers. Increase stats by 1% per level.",
			"level": 1,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Military Hall": {
			"local_name": "Palihanan",
			"description": "Center for gathering military recruits. Allows recruitment of warriors, archers. Increase stats by 1% per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Harbor": {
			"local_name": "Pantalan",
			"description": "Center for boat docking. Allows capturing sea tiles. +1 sea unit deployment limit",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Shipyard": {
			"local_name": "Balangayan",
			"description": "Center for boat construction. Allows recruitment of ships. Increase stats by 1% per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Spiritual Hut": {
			"local_name": "Babaylan",
			"description": "Shaman/Herbalist/Healers house. Allows recruitment of healers. Increase stats by 1% per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Elite Quarters": {
			"local_name": "Balay Maharlika/Timawa/Bagani",
			"description": "Housing for middle class warriors. Allows recruitment of elite warriors. Increase stats by 1% per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Ritual Altars": {
			"local_name": "Sambahan",
			"description": "Worshipping places. +1 contentment every midnight per level.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
		"Center Hall": {
			"local_name": "Balangay Hall",
			"description": "Center for gathering. Allows recruitment of Spies. Increase stats by 1% per level.", #(Tiktik / Bulongero / Marites, Alingawngaw, Sulsolero / Sulsolera)
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 100,
				"wealth": 50
		}
	},
	}
	
	recruitable_units = {
		"Archers": {
			"required_building": "Military Hall",
			"local_name": "Mangangaso",
			"description": "Freefolk and commoner hunters.\nEquipped with range weapons.\nRequired Lv1 Military Hall.\nBasic range unit.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"food": 40,
				"weapons": 40,
				"wealth": 8
				}
			},
		"Elite Archers": {
			"required_building": "Elite Quarters",
			"local_name": "Asintados",
			"description": "The sharpshooters.\nNoble blood elite shooters.\nRequired Lv1 Elite Quarters.\nAdvance Range unit.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"food": 500,
				"weapons": 200,
				"wealth": 100
				}
			},
		"Elite Warriors": {
			"required_building": "Elite Quarters",
			"local_name": "Pintados",
			"description": "The Painted ones.\nNoble blood elite warriors.\nRequired Lv1 Elite Quarters.\nAdvance Melee unit.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"food": 500,
				"weapons": 200,
				"wealth": 100
				}
			},
		"Healers": {
			"required_building": "Spiritual Hut",
			"local_name": "Babaylan",
			"description": "Shaman, Healer, Herbalist, Exorcist, Priest.\nRequired Lv1 Spiritual Hut.\nAdvance Healer unit.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"food": 100,
				"wealth": 50
				}
			},
		"Laborers": {
			"required_building": "Laborer Huts",
			"local_name": "Alipin",
			"description": "Slaves and debt-bound laborers.\nRequired Lv1 Laborer Huts.\nBest for building.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"food": 10,
				"wealth": 1
				}
			},
		"Militia": {
			"required_building": "Military Hall",
			"local_name": "Tanod/Kawal",
			"description": "Polce, Guards, town watchers.\nRequired Lv1 Military Hall.\nBasic garrison unit.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"food": 20,
				"weapons": 20,
				"wealth": 2
				}
			},
		"Spies": {
			"required_building": "Center Hall",
			"local_name": "Tiktik",
			"description": "Freefolk information gatherers.\nRequired Lv1 Center Hall.\nAdvance Spy unit.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"food": 10,
				"wealth": 50
				}
			},
		"War Canoes": {
			"required_building": "Shipyard",
			"local_name": "Balangay Pandigma",
			"description": "Warship multi outrigger canoes.\nRequired Lv1 Shipyard.\nAdvance Sea unit.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"wood": 500,
				"wealth": 100
				}
			},
		"Warriors": {
			"required_building": "Military Hall",
			"local_name": "Mandirigma",
			"description": "Freefolk and commoner warriors.\nEquipped with melee weapons.\nRequired Lv1 Military Hall.\nBasic melee unit.",
			"level": 0,
			"max_level": 10,
			"progress": 0.0, 
			"in_progress": false,
			"cost": {
				"food": 50,
				"weapons": 50,
				"wealth": 10
				}
			},
	}
