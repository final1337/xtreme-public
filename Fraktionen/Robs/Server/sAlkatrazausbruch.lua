Alkatrazausbruch = {delState = false, canBeHacked = false, hacked = false};

Alkatrazausbruch.keypad = createObject(2886,-3520.2583007813,461.54190063477,2.6050999164581,0,0,180);
Alkatrazausbruch.gate = createObject(980,-3520.958984375,466.9716796875,3.2826299667358,0,0,269.65393066406);
Alkatrazausbruch.marker1 = createMarker(-3515.8654785156,470.41940307617,0.2119999974966,"cylinder",10,0,0,0,0);
Alkatrazausbruch.marker2 = createMarker(-3515.8444824219,464.80270385742,0.2119999974966,"cylinder",10,0,0,0,0);

addEventHandler("onElementClicked",Alkatrazausbruch.keypad,function(button,state,player)
	if(button == "left" and state == "down")then
		if(isTerrorist(player) and getElementData(player,"Rang") >= 3)then
			if(Alkatrazausbruch.canBeHacked == true)then
				if(Alkatrazausbruch.delState == false)then
					infobox(player,"Halte die Position drei Minuten lang!",0,120,0);
					Alkatrazausbruch.delState = true;
					setElementData(player,"AlkatrazHacker",true);
          
					Alkatrazausbruch.hackTimer = setTimer(function(player)
						Alkatrazausbruch.hacked = true;
						infobox(player,"Alkatraz wurde erfolgreich gehackt.",0,120,0);
						outputChatBox("[#ff0000ROB#ffffff] Alkatraz wird gehackt!",root,255,255,255,true);
						if(isTimer(Alkatrazausbruch.refreshDeadPed))then killTimer(Alkatrazausbruch.refreshDeadPed)end
						moveObject(Alkatrazausbruch.gate,5000,-3520.958984375,466.9716796875,3.2826299667358-7.5);
						setTimer(function()
							moveObject(Alkatrazausbruch.gate,5000,-3520.958984375,466.9716796875,3.2826299667358);
							Alkatrazausbruch.hacked = false;
						end,60000,1)
					end,180000,1,player)
				else infobox(player,"Alkatraz wird bereits gehackt!",120,0,0)end
			else infobox(player,"Alkatraz kann zurzeit nicht gehackt werden!",120,0,0)end
		else infobox(player,"Du bist nicht dazu befugt, Alkatraz zu hacken!",120,0,0)end
	end
end)

function Alkatrazausbruch.createPed()
	if(isElement(Alkatrazausbruch.ped))then destroyElement(Alkatrazausbruch.ped)end
	Alkatrazausbruch.ped = createPed(287,-3517.1069335938,461.9621887207,2.1621000766754,0);
	giveWeapon(Alkatrazausbruch.ped,31,9999,true);
	setElementFrozen(Alkatrazausbruch.ped,true);
  
	addEventHandler("onPedWasted",Alkatrazausbruch.ped,function(ammo,attacker,weapon,bodypart,stealth)
		if(isTerrorist(attacker) and getElementData(attacker,"Rang") >= 3)then
			if(Alkatrazausbruch.state == false and Alkatrazausbruch.canBeHacked == true)then
				infobox(attacker,"Klicke nun auf das Keypad, um das Tor zu hacken! Ihr habt 10 Minuten Zeit.",0,120,0);
				Alkatrazausbruch.state = true;
				Alkatrazausbruch.canBeHacked = true;
          
				Alkatrazausbruch.refreshDeadPed = setTimer(function()
					if(isElement(Alkatrazausbruch.ped))then
						destroyElement(Alkatrazausbruch.ped);
					end
					Alkatrazausbruch.canBeHacked = false;
				end,600000,1)
			else
				infobox(attacker,"Zurzeit kann kein Knastausbruch gestartet werden!");
				Knastausbruch.createPed();
			end
		else
			infobox(attacker,"Du bist nicht befugt, einen Knastausbruch zu starten!");
			Alkatrazausbruch.createPed();
		end
	end)
end
Alkatrazausbruch.createPed();

function Alkatrazausbruch.deleteWanteds(player)
	if(Alkatrazausbruch.hacked == true)then
		if(getElementData(player,"Knastzeit") <= 30)then
			setElementData(player,"Knastzeit",0);
			infobox(player,"Du bist entkommen!",0,120,0);
		else
			infobox(player,"Deine Knastzeit ist zu hoch, um auszubrechen!",120,0,0);
			local rnd = math.random(1,#Alkatrazspawn);
			x,y,z,rot = Alkatrazspawn[rnd][1],Alkatrazspawn[rnd][2],Alkatrazspawn[rnd][3],Alkatrazspawn[rnd][4];
			setElementDimension(player,0);
			setElementInterior(player,0);
		end
	end
end
addEventHandler("onMarkerHit",Alkatrazausbruch.marker1,Alkatrazausbruch.deleteWanteds)
addEventHandler("onMarkerHit",Alkatrazausbruch.marker2,Alkatrazausbruch.deleteWanteds)

addEventHandler("onPlayerWasted",root,function()
	if(getElementData(source,"AlkatrazHacker") == true)then
		setElementData(source,"AlkatrazHacker",false);
		Alkatraz.delState = false;
		if(isTimer(Alkatrazausbruch.hackTimer))then killTimer(Alkatrazausbruch.hackTimer)end
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if(getElementData(source,"AlkatrazHacker") == true)then
		setElementData(source,"AlkatrazHacker",false);
		Alkatraz.delState = false;
		if(isTimer(Alkatrazausbruch.hackTimer))then killTimer(Alkatrazausbruch.hackTimer)end
	end
end)