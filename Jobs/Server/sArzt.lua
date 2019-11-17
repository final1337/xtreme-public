

Arzt = {playerHeal = {}, targetTimer = {},
	["Vehicles"] = {
		{416,-2544.0725097656,587.08282470703,14.75269985199,0,0,90},
		{416,-2544.0725097656,593.02838134766,14.76340007782,0,0,90},
		{416,-2544.0725097656,598.99768066406,14.76340007782,0,0,90},
		{416,-2544.0725097656,604.89398193359,14.76340007782,0,0,90},
		{416,-2544.0725097656,610.74261474609,14.76340007782,0,0,90},
	},
};

for _,v in pairs(Arzt["Vehicles"])do
	local vehicle = createVehicle(v[1],v[2],v[3],v[4],v[5],v[6],v[7],"Xtreme");
	
	addEventHandler("onVehicleEnter",vehicle,function(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			if(getElementData(player,"Job") ~= "Arzt")then
				infobox(player,loc("JOB_ARZT_EXIT",player),120,0,0);
				ExitVehicle(player);
			end
		end
	end)
end

addEvent("Arzt.start",true)
addEventHandler("Arzt.start",root,function()
	if(getElementModel(client) ~= 276)then
		setElementModel(client,276);
		infobox(client,loc("JOB_ARZT_START",client),0,120,0);
		triggerClientEvent(client,"dxClassClose",client);
		setElementData(client,"Job","Arzt");
	else infobox(client,loc("JOB_ARZT_ALREADY",client),120,0,0)end
end)

addCommandHandler("heilen",function(player,cmd,target)
	if(getElementData(player,"loggedin") == 1)then
		if(target)then
			if(target ~= getPlayerName(player))then
				local target = getPlayerFromName(target);
				if(isElement(target) and getElementData(target,"loggedin") == 1)then
					local x,y,z = getElementPosition(target);
					if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 5)then
						if(getElementHealth(target) < 100)then
							if(Arzt.playerHeal[player] == nil)then
								if(Arzt.playerHeal[target] == nil)then
									Arzt.playerHeal[target] = getPlayerName(player);
									Arzt.playerHeal[player] = getPlayerName(target);
									infobox(player,loc("JOB_ARZT_HEILUNGANGEBOTEN",player):format(getPlayerName(target),0,120,0));
									infobox(target,loc("JOB_ARZT_HEILUNGANGEBOTENTARGET",target):format(getPlayerName(player),0,120,0));
									Arzt.targetTimer[target] = setTimer(function(target)
										local player = getPlayerFromName(Arzt.playerHeal[target]);
										Arzt.playerHeal[target] = nil;
										Arzt.playerHeal[player] = nil;
									end,60000,1,target)
								else infobox(player,loc("JOB_ARZT_SPIELERALREADYHEILUNG",player),120,0,0)end
							else infobox(player,loc("JOB_ARZT_ALREADYHEILUNG",player),120,0,0)end
						else infobox(player,loc("JOB_ARZT_GEHEILT",player),120,0,0)end
					else infobox(player,loc("JOB_ARZT_ENTFERNUNG",player),120,0,0)end
				else infobox(player,loc("JOB_ARZT_HEILUNG",player),120,0,0)end
			end
		else infobox(player,loc("JOB_ARZT_SYNTAX",player),120,0,0)end
	end
end)

addCommandHandler("acceptHeilen",function(player)
	if(getElementData(player,"loggedin") == 1)then
		if(Arzt.playerHeal[player] ~= nil)then
			local target = getPlayerFromName(Arzt.playerHeal[player]);
			local health = 100-getElementHealth(player);
			local costs = health*2;
			local x,y,z = getElementPosition(target);
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 5)then
				if(getElementData(player,"Geld") >= costs)then
					setElementData(player,"Geld",getElementData(player,"Geld")-math.floor(costs));
					infobox(player,loc("JOB_ARZT_HEALED",player),0,120,0);
					infobox(target,loc("JOB_ARZT_PLAYERHEALED",player):format(getPlayerName(player)),0,120,0);
					setElementData(target,"Geld",getElementData(target,"Geld")+math.floor(costs/2));
					Arzt.playerHeal[player] = nil;
					Arzt.playerHeal[target] = nil;
					if(isTimer(Arzt.targetTimer[player]))then killTimer(Arzt.targetTimer[player])end
					setElementHealth(player,100);
				else infobox(player,loc("JOB_ARZT_NOMONEY",player):format(costs),120,0,0)end
			else infobox(player,loc("JOB_ARZT_ZUWEITENTFERNT",player),120,0,0)end
		else infobox(player,loc("JOB_ARZT_KEINEHEILUNG",player),120,0,0)end
	end
end)

addCommandHandler("quitjob",function(player)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementModel(player) == 276)then
			setElementModel(player,getElementData(player,"Skin"));
			infobox(player,loc("JOB_ARZT_NODUTY",player),120,0,0);
		end
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if(Arzt.playerHeal[source] ~= nil)then
		local player = getPlayerFromName(Arzt.playerHeal[source]);
		Arzt.playerHeal[source] = nil;
		Arzt.playerHeal[player] = nil;
		if(isTimer(Arzt.targetTimer[player]))then killTimer(Arzt.targetTimer[player])end
	end
end)