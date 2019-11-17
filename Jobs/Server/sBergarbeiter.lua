

Bergarbeiter = {timer = {}};
Bergarbeiter.rock = createObject(899,-1046.7626953125,-1684.5704345703,73.659698486328,4.6163635253906,352.20922851563,335.00659179688);
dbExec(handler,"UPDATE bergarbeiter SET Ticked1 = '0', Ticked2 = '0', Ticked3 = '0'");

function Bergarbeiter.setDatas(player)
	local result = dbPoll(dbQuery(handler,"SELECT * FROM bergarbeiter WHERE Username = '"..getPlayerName(player).."'"),-1);
	if(#result == 0)then
		dbExec(handler,"INSERT INTO bergarbeiter (Username) VALUES ('"..getPlayerName(player).."')");
	end
	local Ticked1,Ticked2,Ticked3 = getPlayerData("bergarbeiter","Username",getPlayerName(player),"Ticked1"),getPlayerData("bergarbeiter","Username",getPlayerName(player),"Ticked2"),getPlayerData("bergarbeiter","Username",getPlayerName(player),"Ticked3");
	setElementData(player,"Bergarbeiter_Ticked1",Ticked1);
	setElementData(player,"Bergarbeiter_Ticked2",Ticked2);
	setElementData(player,"Bergarbeiter_Ticked3",Ticked3);
end

addEvent("Bergarbeiter.start",true)
addEventHandler("Bergarbeiter.start",root,function()
	triggerClientEvent(client,"Bergarbeiter.createStuff",client,"create");
	infobox(client,loc("JOB_BERGARBEITER_START",client),0,120,0);
	local item = client:addItem(Weapon_To_Database[5], 1, "Feinste Spitzhacke", true)
	item:merge()
	triggerClientEvent(client,"dxClassClose",client);
end)

addCommandHandler("stopbergarbeiter",function(player)
	triggerClientEvent(player,"Bergarbeiter.createStuff",player);
	if(isTimer(Bergarbeiter.timer[player]))then killTimer(Bergarbeiter.timer[player])end
	setElementFrozen(player);
	setPedAnimation(player);
end)

addEvent("Bergarbeiter.click",true)
addEventHandler("Bergarbeiter.click",root,function()
	if(getPedWeapon(client) == 5)then
		if(not(isTimer(Bergarbeiter.timer[client])))then
			if(not(isPedInVehicle(client)))then
				setElementFrozen(client,true);
				toggleAllControls(client,false);
				setPedAnimation(client,"BASEBALL","Bat_1");
				Bergarbeiter.timer[client] = setTimer(function(client)
					setPedAnimation(client);
					setElementFrozen(client,false);
					local bm = getElementData(client,"BergarbeiterMarker");
					if(bm and bm ~= false)then
						if(bm == 1)then
							if(getElementData(client,"Bergarbeiter_Ticked1") < 250)then
								setElementData(client,"Bergarbeiter_Ticked1",getElementData(client,"Bergarbeiter_Ticked1")+1);
								if(getElementData(client,"Bergarbeiter_Ticked1") < 249)then
									infobox(client,loc("JOB_BERGARBEITER_EISENERZ1",client),0,120,0);
								else
									infobox(client,loc("JOB_BERGARBEITER_EISENERZ2",client),0,120,0);
								end
								local item = client:addItem(53, 1, "none", false)
								item:merge()
								if math.random(1, 20) == 5 then
									local item = client:addItem(84, 1, "none", false)
									client:sendNotification("ITEM_FOUND", 255, 255, 0, "Silizium")
									item:merge()									
								end	
								if math.random(1, 20) == 4 then
									local item = client:addItem(85, 1, "none", false)
									client:sendNotification("ITEM_FOUND", 255, 255, 0, "Aluminium")
									item:merge()		
								end	
							else infobox(client,loc("JOB_BERGARBEITER_EMPTY",client),120,0,0)end
						elseif(bm == 2)then
							if(getElementData(client,"Bergarbeiter_Ticked2") < 250)then
								setElementData(client,"Bergarbeiter_Ticked2",getElementData(client,"Bergarbeiter_Ticked2")+1);
								if(getElementData(client,"Bergarbeiter_Ticked2") < 249)then
									infobox(client,loc("JOB_BERGARBEITER_EISENERZ1",client),0,120,0);
								else
									infobox(client,loc("JOB_BERGARBEITER_EISENERZ2",client),0,120,0);
								end
								local item = client:addItem(53, 1, "none", false)
								item:merge()
								if math.random(1, 20) == 5 then
									local item = client:addItem(84, 1, "none", false)
									client:sendNotification("ITEM_FOUND", 255, 255, 0, "Silizium")
									item:merge()									
								end	
								if math.random(1, 20) == 4 then
									local item = client:addItem(85, 1, "none", false)
									client:sendNotification("ITEM_FOUND", 255, 255, 0, "Aluminium")
									item:merge()		
								end															
							else infobox(client,loc("JOB_BERGARBEITER_EMPTY",client),120,0,0)end
						elseif(bm == 3)then
							if(getElementData(client,"Bergarbeiter_Ticked3") < 250)then
								setElementData(client,"Bergarbeiter_Ticked3",getElementData(client,"Bergarbeiter_Ticked3")+1);
								if(getElementData(client,"Bergarbeiter_Ticked3") < 249)then
									infobox(client,loc("JOB_BERGARBEITER_EISENERZ1",client),0,120,0);
								else
									infobox(client,loc("JOB_BERGARBEITER_EISENERZ2",client),0,120,0);
								end
								local item = client:addItem(53, 1, "none", false)
								item:merge()
								if math.random(1, 20) == 5 then
									local item = client:addItem(84, 1, "none", false)
									client:sendNotification("ITEM_FOUND", 255, 255, 0, "Silizium")
									item:merge()									
								end	
								if math.random(1, 20) == 4 then
									local item = client:addItem(85, 1, "none", false)
									client:sendNotification("ITEM_FOUND", 255, 255, 0, "Aluminium")
									item:merge()		
								end															
							else infobox(client,loc("JOB_BERGARBEITER_EMPTY",client),120,0,0)end
						end
					end
					toggleAllControls(client,true);
				end,7500,1,client)
			end
		end
	else infobox(client,loc("JOB_BERGARBEITER_SPITZHACKE",client),120,0,0)end
end)