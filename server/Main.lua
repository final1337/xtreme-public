Main = inherit(Singleton)

function Main.Event_OnResourceStart()
	Core:new()
end
addEventHandler("onResourceStart", resourceRoot, Main.Event_OnResourceStart)

-- Todo: fix delete bug
function Main.Event_OnResourceStop()
	Core:delete()
end
addEventHandler("onResourceStop", resourceRoot, Main.Event_OnResourceStop)