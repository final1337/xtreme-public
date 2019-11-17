addEvent("setObjectsUnbreakable", true)
addEventHandler("setObjectsUnbreakable", root, function ( objects )
	for key, object in ipairs(objects) do
		setObjectBreakable(object, false)
	end
end)

HanfTransport = inherit(ActivityBase)
inherit(Singleton, HanfTransport)

function HanfTransport:constructor(name, id, abbreviation)
	ActivityBase.constructor(self, name, id, abbreviation)
end