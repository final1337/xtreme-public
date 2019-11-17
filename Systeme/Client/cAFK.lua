AFK = {x1 = 0, y1 = 0, z1 = 0, x2 = 0, y2 = 0, z2 = 0, time = 0, state = false};
setElementData(localPlayer,"HighPing",0);

setTimer(function()
	if(getElementData(localPlayer,"loggedin") == 1)then
		AFK.x1,AFK.y1,AFK.z1 = AFK.x2,AFK.y2,AFK.z2;
		AFK.x2,AFK.y2,AFK.z2 = getElementPosition(localPlayer);
		if(getDistanceBetweenPoints3D(AFK.x1,AFK.y1,AFK.z1,AFK.x2,AFK.y2,AFK.z2) >= 0.5)then
			AFK.time = 0;
			if(AFK.state == true)then
				AFK.state = false;
				setElementData(localPlayer,"AFK",false);
			end
		else
			AFK.time = AFK.time + 1000;
			if(AFK.time == 301000)then
				AFK.state = true;
				setElementData(localPlayer,"AFK",true);
			end
		end
		if(getElementData(localPlayer,"Highping") == 30)then
			infobox("Achtung: Dein Ping ist sehr hoch!",120,0,0);
		end
		if(getPlayerPing(localPlayer) >= 250)then
			setElementData(localPlayer,"Highping",getElementData(localPlayer,"Highping")+1);
		else
			setElementData(localPlayer,"Highping",0);
		end
	end
end,1000,0)