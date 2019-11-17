

Taxifahrer = {
	["Vehicles"] = {
		{420,-2231.3068847656,293.74920654297,34.96720123291,0,0,0},
		{420,-2227.1057128906,293.74920654297,34.96720123291,0,0,0},
		{420,-2222.6057128906,293.74920654297,34.96720123291,0,0,0},
		{420,-2218.5485839844,293.74920654297,34.96720123291,0,0,0},
		{420,-2214.1240234375,293.74920654297,34.96720123291,0,0,0},
		{420,-2209.9992675781,293.74920654297,34.96720123291,0,0,0},
	},
};

for _,v in pairs(Taxifahrer["Vehicles"])do
	local vehicle = createVehicle(v[1],v[2],v[3],v[4],v[5],v[6],v[7],"Xtreme");
	vehicle:setData("Taxi", true)
	
	addEventHandler("onVehicleEnter",vehicle,function(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			if(getElementData(player,"Job") ~= "Taxifahrer")then
				infobox(player,loc("JOB_TAXIFAHRER_EXIT"),player,120,0,0);
				ExitVehicle(player);
			else
				triggerClientEvent(player,"Taxifahrer.createMarker",player,"create","createPed");
			end
		end
	end)
	
	addEventHandler("onVehicleExit",vehicle,function(player,seat)
		if(seat == 0)then
			setElementPosition(player,-2220.8969726563,286.32055664063,35.3203125);
			setPedRotation(player,0);
			respawnVehicle(source);
			triggerClientEvent(player,"Taxifahrer.createMarker",player);
			infobox(player,loc("JOB_ABGEBROCHEN",player),120,0,0);
		end
	end)
end

addEvent("Taxifahrer.start",true)
addEventHandler("Taxifahrer.start",root,function()
	infobox(client,loc("JOB_TAXIFAHRER_START",client),0,120,0);
	triggerClientEvent(client,"dxClassClose",client);
	setElementData(client,"Job","Taxifahrer");
end)

addEvent("Taxifahrer.giveMoney",true)
addEventHandler("Taxifahrer.giveMoney",root,function()
	setElementData(client,"Bankgeld",getElementData(client,"Bankgeld")+550);
	Levelsystem.givePoints(client,550/50);
end)

function Taxifahrer.destroyStuff(player)
	local vehicle = getPedOccupiedVehicle(player);
	if vehicle then
		if vehicle:getData("Taxi") then
			respawnVehicle(vehicle);
		end
	end
	triggerClientEvent(player,"Taxifahrer.createMarker",player);
end
addEventHandler("onPlayerWasted",root,function() Taxifahrer.destroyStuff(source)end)
addEventHandler("onPlayerQuit",root,function() Taxifahrer.destroyStuff(source)end)