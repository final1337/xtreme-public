--

-- [[ TABLES ]] --

Pizza = {id = 1, allowed = true,
	["Menues"] = { -- Preis, Name, Model-ID, Leben
		{5,"Buster",2218,15},
		{8,"Double D-Luxe",2219,25},
		{15,"Full Rack",2220,50},
	},
};

-- [[ OBJEKT BEWEGEN ]] --

function Pizza.moveObject()
	if(isElement(Pizza.tablet))then
		local sx,sy,sz = getPedBonePosition(getPizzaPed(),35);
		setElementPosition(Pizza.tablet,sx-0.55,sy,sz+0.05);
	end
end

local Animations = {
	[1] = "SHP_Tray_Pose",
	[2] = "SHP_Tray_Lift",
	[3] = "SHP_Tray_Return",
};

-- [[ MARKER ERSTELEN ]] --

for i = 0,1 do
	local marker = createMarker(375.70697021484,-119.25256347656,1000.5,"cylinder",0.8,255,0,0,150);
	setElementInterior(marker,5);
	setElementDimension(marker,i);
	addEventHandler("onClientMarkerHit",marker,function(player)
		if(player == localPlayer)then
			if(not(isPedInVehicle(localPlayer)))then
				if(getElementDimension(localPlayer) == getElementDimension(source))then
					Pizza.createWindow();
				end
			end
		end
	end)
end

-- [[ PEDS ]] --

Pizza.ped1 = createPed(155,375.70291137695,-117.3,1001.4921875,180);
setElementInterior(Pizza.ped1,5);
Pizza.ped2 = createPed(155,375.70291137695,-117.3,1001.4921875,180);
setElementInterior(Pizza.ped2,5);
setElementDimension(Pizza.ped2,1);

function getPizzaPed()
	local dim = getElementDimension(localPlayer);
	if(dim == 0)then
		ped = Pizza.ped1;
	elseif(dim == 1)then
		ped = Pizza.ped2;
	end
	return ped;
end

-- [[ FENSTER ÖFFNEN ]] --

function Pizza.createWindow()
	if(Pizza.allowed == true)then
		if(not(isElement(Pizza.tableMarker)))then
			Pizza.allowed = true;
			Pizza.id = 1;
			addEventHandler("onClientRender",root,Pizza.moveObject);
			bindKey("arrow_l","down",Pizza.left);
			bindKey("arrow_r","down",Pizza.right);
			bindKey("enter","down",Pizza.buy);
			bindKey("backspace","down",Pizza.close);
			setElementPosition(localPlayer,377.09866333008,-119.51579284668,1001.4995117188);
			setPedRotation(localPlayer,0);
			setCameraMatrix(375.70697021484,-119.25256347656,1002,375.70697021484,-118.25256347656,1002);
			addEventHandler("onClientRender",root,Pizza.dxDrawWindow);
			showChat(false);
			setElementData(localPlayer,"elementClicked",true);
			toggleAllControls(false);
			
			Pizza.allowed = false;
			setPedAnimation(getPizzaPed(),"food",Animations[3],1,false);
			Pizza.timer1 = setTimer(function()
				setPedAnimation(getPizzaPed(),"food",Animations[2],1,false);
				if(isElement(Pizza.tablet))then destroyElement(Pizza.tablet)end
				Pizza.timer2 = setTimer(function()
					Pizza.tablet = createObject(Pizza["Menues"][Pizza.id][3],-1230,181,15,206,206,74);
					setElementDimension(Pizza.tablet,getElementDimension(localPlayer));
					setElementInterior(Pizza.tablet,5);
				end,500,1)
				Pizza.timer3 = setTimer(function()
					Pizza.allowed = true;
					setElementDimension(localPlayer, 0)
				end,1800,1)
			end,2500,1)
		else infobox("Deine Bestellung steht bereits auf dem Tisch!",120,0,0)end
	end
end

-- [[ SCHLIESSEN ]] --

function Pizza.close()
	if(Pizza.allowed == true)then
		showChat(true);
		unbindKey("arrow_l","down",Pizza.left);
		unbindKey("arrow_r","down",Pizza.right);
		unbindKey("enter","down",Pizza.buy);
		unbindKey("backspace","down",Pizza.close);
		removeEventHandler("onClientRender",root,Pizza.dxDrawWindow);
		toggleAllControls(true);
		setElementData(localPlayer,"elementClicked",false);
		setCameraTarget(localPlayer);
		
		Pizza.allowed = false;
		setPedAnimation(getPizzaPed(),"food",Animations[3],1,false);
		Pizza.timer1 = setTimer(function()
			setPedAnimation(getPizzaPed(),"food",Animations[2],1,false);
			if(isElement(Pizza.tablet))then destroyElement(Pizza.tablet)end
			Pizza.timer3 = setTimer(function()
				Pizza.allowed = true;
				removeEventHandler("onClientRender",root,Pizza.moveObject);
			end,1800,1)
		end,2500,1)
	end
end

-- [[ LINKS / RECHTS ]] --

function Pizza.left()
	if(Pizza.allowed == true)then
		if(Pizza.id > 1)then
			Pizza.allowed = false;
			Pizza.id = Pizza.id - 1;
			setPedAnimation(getPizzaPed(),"food",Animations[3],1,false);
			Pizza.timer1 = setTimer(function()
				setPedAnimation(getPizzaPed(),"food",Animations[2],1,false);
				if(isElement(Pizza.tablet))then destroyElement(Pizza.tablet)end
				Pizza.timer2 = setTimer(function()
					Pizza.tablet = createObject(Pizza["Menues"][Pizza.id][3],-1230,181,15,206,206,74);
					setElementDimension(Pizza.tablet,getElementDimension(localPlayer));
					setElementInterior(Pizza.tablet,5);
				end,500,1)
				Pizza.timer3 = setTimer(function()
					Pizza.allowed = true;
				end,1800,1)
			end,2500,1)
		end
	end
end

function Pizza.right()
	if(Pizza.allowed == true)then
		if(Pizza.id < 3)then
			Pizza.allowed = false;
			Pizza.id = Pizza.id + 1;
			setPedAnimation(getPizzaPed(),"food",Animations[3],1,false);
			Pizza.timer1 = setTimer(function()
				setPedAnimation(getPizzaPed(),"food",Animations[2],1,false);
				if(isElement(Pizza.tablet))then destroyElement(Pizza.tablet)end
				Pizza.timer2 = setTimer(function()
					Pizza.tablet = createObject(Pizza["Menues"][Pizza.id][3],-1230,181,15,206,206,74);
					setElementDimension(Pizza.tablet,getElementDimension(localPlayer));
					setElementInterior(Pizza.tablet,5);
				end,500,1)
				Pizza.timer3 = setTimer(function()
					Pizza.allowed = true;
				end,1800,1)
			end,2500,1)
		end
	end
end

-- [[ PIZZA KAUFEN ]] --

function Pizza.buy()
	local preis = Pizza["Menues"][Pizza.id][1];
	if(Pizza.allowed == true)then
		if(getElementData(localPlayer,"Geld") >= preis)then
			Pizza.close();
			infobox("Setze dich an den Tisch, deine Bestellung kommt gleich.",0,120,0);
			Pizza.tableMarker = createMarker(378.17047119141,-125.42088317871,1001.4995117188+0.5,"arrow",1,255,0,0);
			setElementDimension(Pizza.tableMarker,getElementDimension(localPlayer));
			setElementInterior(Pizza.tableMarker,5);
			
			addEventHandler("onClientMarkerHit",Pizza.tableMarker,function(player)
				if(player == localPlayer)then
					if(getElementDimension(player) == getElementDimension(source))then
						setElementData(localPlayer,"Pizza.oldDim",getElementDimension(localPlayer));
						Pizza.object = createObject(2881,0,0,0,0,-70,-90);
						setElementDimension(Pizza.object,getElementDimension(localPlayer));
						setElementInterior(Pizza.object,5);
						destroyElement(source);
						triggerServerEvent("Pizza.sitdown",localPlayer);
						addEventHandler("onClientRender",root,Pizza.movePizzaobject);
						Pizza.tableObject = createObject(Pizza["Menues"][Pizza.id][3],379.08999633789,-124.99669647217,1001.3853759766,334.56683349609,23.213165283203,252.36730957031);
						setElementInterior(Pizza.tableObject,5);
						setElementDimension(Pizza.tableObject,getElementDimension(localPlayer));
						setTimer(function()
							if(isElement(Pizza.object))then destroyElement(Pizza.object)end
							if(isElement(Pizza.tableObject))then destroyElement(Pizza.tableObject)end
							removeEventHandler("onClientRender",root,Pizza.movePizzaobject);
							triggerServerEvent("Pizza.finish",localPlayer,Pizza["Menues"][Pizza.id][4]);
						end,10000,1)
					end
				end
			end)
		else infobox("Du hast nicht genug Geld dabei!",120,0,0)end
	end
end

-- [[ OBJEKT BEWEGEN ]] --

function Pizza.movePizzaobject()
	if(isElement(Pizza.object))then
		local bx,by,bz = getPedBonePosition(localPlayer,25);
		setElementPosition(Pizza.object,bx-0.05,by,bz-0.15);
	end
end

-- [[ ANZEIGE ]] --

function Pizza.dxDrawWindow()
	dxDrawImage(34,40,425,137,"Files/Images/PizzaBackground.png");
	dxDrawImage(34,239,425,130,"Files/Images/PizzaBackground.png");
	dxDrawText(Pizza["Menues"][Pizza.id][1].."€",346,312,420,349,tocolor(255,255,255,255),2.0,"default-bold","left","top",false,false,false);
	dxDrawText(Pizza["Menues"][Pizza.id][2],43,310,320,351,tocolor(255,255,255,255),2.0,"default-bold","left","top",false,false,false);
	dxDrawText("Preis",346,269,420,306,tocolor(255,255,255,255),2.0,"default-bold","left","top",false,false,false)
	dxDrawText("Menü",44,269,118,306,tocolor(255,255,255,255),2.0,"default-bold","left","top",false,false,false)
	dxDrawText("Essen",38,203,233,256,tocolor(0,0,0,255),2.0,"bankgothic","left","top",false,false,false)
	dxDrawText("Essen",44,208,238,264,tocolor(255,255,255,255),1.9,"bankgothic","left","top",false,false,false)
	dxDrawText("Benutze LINKS oder RECHTS um \nein Menü auszuwählen.\nLEERTASTE        KAUFEN\nRÜCKTASTE       Schließen",46,49,453,176,tocolor(255,255,255,255),2.0,"default-bold","left","top",false,false,false)
end