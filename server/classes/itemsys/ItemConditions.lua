ItemConditions = {}

ItemConditions.StateFactions = {
	[1] = true,
	[2] = true,
	[7] = true,
}

-- Is player on ground ItemCondition
-- Id: 00000001

ItemConditions[00000001] = {
	Condition = {
		["DE"] = "Auf dem Boden.",
		["EN"] = "Be at groundlevel.",
	},
	Func = function (player, item)
		return isPedOnGround(player)
	end,
	Negative = {
		["DE"] = "Du bist nicht auf dem Boden.",
		["EN"] = "You are not on the ground.",
	},
}

-- is in state faction
-- Id: 00000002

ItemConditions[00000002] = {
	Condition = {
		["DE"] = "Staatsfraktionist.",
		["EN"] = "state faction member.",
	},
	Func = function (player, item)
		if getElementData(player,"Fraktion") == 1 or getElementData(player,"Fraktion") == 2 or getElementData(player,"Fraktion") == 3 then
			return true
		end
		return false
	end,
	Negative = {
		["DE"] = "Du bist in keiner Staatsfraktion.",
		["EN"] = "You are not a member of a state faction.",
	},
}


-- Default deny
-- Id: 00000003

ItemConditions[00000003] = {
	Condition = {
		["DE"] = "Deaktiviert.",
		["EN"] = "state faction member.",
	},
	Func = function (player, item)
		return false
	end,
	Negative = {
		["DE"] = "Deaktiviert.",
		["EN"] = "You are not a member of a state faction.",
	},
}


-- duty check
-- Id: 00000004

ItemConditions[00000004] = {
	Condition = {
		["DE"] = "Duty.",
		["EN"] = "state faction member.",
	},
	Func = function (player, item)
		return getElementData(player, "Duty")
	end,
	Negative = {
		["DE"] = "Sie müssen im Dienst sein.",
		["EN"] = "You need to be on duty.",
	},
}

-- Noob-Protection

ItemConditions[00000005] = {
	Condition = {
		["DE"] = "Noobschutz.",
		["EN"] = "Noobprotection.",
	},
	Func = function (player, item)
		return (getElementData(player,"Spielstunden") > 180)
	end,
	Negative = {
		["DE"] = "Du musst über 3 Stunden haben.",
		["EN"] = "You need more than 3 hours of gametime.",
	},
}

-- Open World

ItemConditions[00000006] = {
	Condition = {
		["DE"] = "Offene Welt.",
		["EN"] = "Open World.",
	},
	Func = function (player, item)
		return (getElementInterior(player) == 0 and getElementDimension(player) == 0)
	end,
	Negative = {
		["DE"] = "Du musst in der offenen Welt sein.",
		["EN"] = "You need to be in the open world.",
	},
}

-- Firefighter

ItemConditions[00000007] = {
	Condition = {
		["DE"] = "Staatsfraktionist.",
		["EN"] = "state faction member.",
	},
	Func = function (player, item)
		if getElementData(player,"Fraktion") == 9 then
			return true
		end
		return false
	end,
	Negative = {
		["DE"] = "Du bist nicht in der Feuerwehr.",
		["EN"] = "You are not a member of a state faction.",
	},
}

-- Energylimit

ItemConditions[00000008] = {
	Condition = {
		["DE"] = "Staatsfraktionist.",
		["EN"] = "state faction member.",
	},
	Func = function (player, item)
		return ( not player:getData("EnergyUsed") or getRealTime()["timestamp"] >= player:getData("EnergyUsed"))
	end,
	Negative = {
		["DE"] = "Du kannst nur alle 5 Sekunden einen Energy trinken.",
		["EN"] = "You can only drink an energy every 5 seconds.",
	},
}

-- Salatlimit

ItemConditions[00000009] = {
	Condition = {
		["DE"] = "Staatsfraktionist.",
		["EN"] = "state faction member.",
	},
	Func = function (player, item)
		return not getElementData(player,"waitTime") and (player:getVelocity()):getLength() == 0
	end,
	Negative = {
		["DE"] = "Das kannst du derzeit noch nicht essen.",
		["EN"] = "You cannot eat that yet.",
	},
}