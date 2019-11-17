--

Krankenhaus = {};

function Krankenhaus.dxDraw()
    dxDrawRectangle(1056*(x/1280), 10*(y/1024), 218*(x/1280), 161*(y/1024), tocolor(28, 28, 28, 213), false)
    dxDrawRectangle(1056*(x/1280), 10*(y/1024), 218*(x/1280), 10*(y/1024), tocolor(247, 0, 0, 213), false)
    dxDrawRectangle(1056*(x/1280), 20*(y/1024), 218*(x/1280), 10*(y/1024), tocolor(219, 0, 0, 213), false)
    dxDrawText("Xtreme Krankenhaus", 1056*(x/1280), 10*(y/1024), 1274*(x/1280), 30*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
    dxDrawImage(1119*(x/1280), 40*(y/1024), 92*(x/1280), 90*(y/1024), "Files/Images/Herz.png", 0, 0, 0, tocolor(255, 11, 11, 255), false)
    dxDrawText("Respawn in: "..Krankenhaus.time, 1056*(x/1280), 141*(y/1024), 1274*(x/1280), 161*(y/1024), tocolor(255, 255, 255, 255), 1.20*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
end

addEvent("Krankenhaus.start",true)
addEventHandler("Krankenhaus.start",root,function(time)
	Krankenhaus.time = time or 60;
	addEventHandler("onClientRender",root,Krankenhaus.dxDraw);
	setElementData(localPlayer,"ShowHUD",false);
	setTimer( function() 
		setCameraMatrix(-2547.24609375,575.43090820313,47.648700714111,-2548.0732421875,575.90161132813,47.341449737549);
	end, 150, 1)
	Krankenhaus.timer = setTimer(function()
		Krankenhaus.time = Krankenhaus.time - 1;
	end,1000,Krankenhaus.time)
end)

addEvent("Krankenhaus.stop",true)
addEventHandler("Krankenhaus.stop",root,function()
	removeEventHandler("onClientRender", root, Krankenhaus.dxDraw);
end)

--[[
	if(Krankenhaus.time == 0)then
		if(isTimer(Krankenhaus.timer))then killTimer(Krankenhaus.timer)end
		triggerServerEvent("newSpawnPlayer",localPlayer,localPlayer);
		setElementData(localPlayer,"ShowHUD",true);
		removeEventHandler("onClientRender",root,Krankenhaus.dxDraw);
	end
--]]