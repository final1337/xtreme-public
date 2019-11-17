

Gym = {};

function Gym.dxDraw()
	if(isWindowOpen())then
		dxDrawRectangle(1056*(x/1280), 180*(y/1024), 218*(x/1280), 21*(y/1024), tocolor(255, 100, 0, 255), false)
		dxDrawRectangle(1056*(x/1280), 201*(y/1024), 218*(x/1280), 51*(y/1024), tocolor(28, 28, 28, 213), false)
		dxDrawText("Fitnessstudio", 1056*(x/1280), 180*(y/1024), 1274*(x/1280), 201*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Muskeln: "..getElementData(localPlayer,"Muskeln").."/1000\nFett: "..getElementData(localPlayer,"Fett").."/1000", 1056*(x/1280), 201*(y/1024), 1274*(x/1280), 252*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
	end
end

addEvent("Gym.dxDraw",true)
addEventHandler("Gym.dxDraw",root,function(type)
	if(type == "create")then
		addEventHandler("onClientRender",root,Gym.dxDraw);
		outputChatBox("#fa6400[INFO] #ffffffTippe #fa6400/stopTraining#ffffff, um das Training zu beenden.",255,255,255,true);
	else
		removeEventHandler("onClientRender",root,Gym.dxDraw);
	end
end)