--

Waffenschein = {};
Waffenschein.pickup = createPickup(246.5146484375,118.3955078125,1003.21875,3,348,50);
setElementInterior(Waffenschein.pickup,10)

addEventHandler("onPickupHit",Waffenschein.pickup,function(player)
	if(not(isPedInVehicle(player)))then
		if(getElementDimension(player) == getElementDimension(source))then
			triggerClientEvent(player,"Waffenschein.openWindow",player);
		end
	end
end)