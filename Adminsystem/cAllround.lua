

Adminsystem = {
	["Namen"] = {
		[1] = "Ticketbeauftragter",
		[2] = "Supporter",
		[3] = "Moderator",
		[4] = "Developer",
		[5] = "Administrator",
		[6] = "Servermanager",
		[7] = "Stellv. Projektleiter",
		[8] = "Projektleiter",
	},
};

addEvent("setObjectsUnbreakable", true)
addEventHandler("setObjectsUnbreakable", root, function ( objects )
	for key, object in ipairs(objects) do
		setObjectBreakable(object, false)
	end
end)

addEvent("loginSuccess", true)