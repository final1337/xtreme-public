
Jobs = {
	["Pickups"] = {
		{-2265.7641601563,177.65914916992,35.3125,"Busfahrer"};
		{2519.9880371094,-2121.2326660156,13.546875,"Betonmischerfahrer"},
		{2105.4865722656,-1806.5010986328,13.5546875,"Pizzalieferant"},
		{1996.2210693359,-1283.4855957031,23.965635299683,"Rasenmaeherfahrer"},
		{-2102.1162109375,-12.345714569092,35.3203125,"Strassenreiniger"},
		{-1830.2769775391,109.02180480957,15.1171875,"Trucker"},
		{-2539.3830566406,582.01397705078,14.453125,"Arzt"},
		{-1726.2938232422,1431.3934326172,1.4067287445068,"Fischer"},
		{-1061.5953369141,-1195.4946289063,129.828125,"Landwirt"},
		{-1421.1649169922,-286.99438476563,14.1484375,"Pilot"},
		{-2172.4597167969,252.05914306641,35.339382171631,"Taxifahrer"},
		{-1897.7041015625,-1681.4636230469,23.015625,"Muellmann"},
		{-1968.6829833984,109.94599151611,27.6875,"Zugfuehrer"},
		{-1096.4846191406,-1614.7548828125,76.37393951416,"Bergarbeiter"},
	},
};

function createJobPickup(x,y,z,job)
	local pickup = createPickup(x,y,z,3,1274,50);
	addEventHandler("onPickupHit",pickup,function(player)
		if(not(isPedInVehicle(player)))then
			if job ~= "Pilot" then
				triggerClientEvent(player,"Jobs.openWindow",player,job);
			else
				PilotJob:getSingleton():checkRequirements(player, true)
			end			
		end
	end)
end

for _,v in pairs(Jobs["Pickups"])do createJobPickup(v[1],v[2],v[3],v[4])end