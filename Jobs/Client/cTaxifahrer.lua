

Taxifahrer = {
	["Peds"] = {
		{94,-2265.8061523438,-100.32969665527,35.320301055908,270,-2264.4916992188,-100.32239532471,35.171875},
		{94,-2426.4155273438,-9.9920997619629,35.320301055908,270,-2425.5129394531,-10.089014053345,35.171875},
		{94,-2651.5302734375,259.92269897461,4.3281002044678,270,-2650.6799316406,259.80221557617,4.1796875},
		{94,-2711.1467285156,-100.09649658203,4.3281002044678,270,-2710.3608398438,-100.09321594238,4.1796875},
		{94,-2214.7602539063,-208.03089904785,35.480098724365,270,-2213.7585449219,-208.0813293457,35.3203125},
		{94,-1804.6085205078,-21.519100189209,15.109399795532,270,-1803.7099609375,-21.523788452148,14.9609375},
		{94,-2012.1296386719,580.642578125,35.171901702881,270,-2010.9428710938,580.47705078125,35.015625},
		{94,-2151.736328125,222.61239624023,35.320301055908,270,-2150.7873535156,222.47329711914,35.171875},
		{94,-2608.6247558594,-90.438003540039,4.3358998298645,270,-2607.5666503906,-90.426689147949,4.1796875},
		{94,-2274.41796875,887.93347167969,66.648399353027,270,-2273.4006347656,887.84002685547,66.492492675781},
	},
	["Ziele"] = {
		{-2806.6926269531,16.642374038696,7.0712022781372},
		{-2748.6459960938,784.27874755859,54.041259765625},
		{-2286.2526855469,806.45745849609,49.330883026123},
		{-1968.8715820313,1099.0108642578,55.620571136475},
		{-1739.7850341797,916.63928222656,24.785694122314},
		{-1562.7563476563,762.26879882813,7.0914874076843},
		{-1880.4471435547,1071.0784912109,45.349475860596},
		{-2609.0300292969,978.93182373047,78.179779052734},
		{-2753.3259277344,773.42504882813,54.286666870117},
		{-2682.2385253906,285.99462890625,4.2386589050293},
	},
};

function Taxifahrer.createMarker(type,var)
	if(isElement(Taxifahrer.marker))then destroyElement(Taxifahrer.marker)end
	if(isElement(Taxifahrer.blip))then destroyElement(Taxifahrer.blip)end
	if(isElement(Taxifahrer.ped))then destroyElement(Taxifahrer.ped)end
	if(type)then
		if(var == "createPed")then
			local rnd = math.random(1,#Taxifahrer["Peds"]);
			local tbl = Taxifahrer["Peds"][rnd];
			Taxifahrer.ped = createPed(tbl[1],tbl[2],tbl[3],tbl[4],tbl[5]);
			Taxifahrer.marker = createMarker(tbl[6],tbl[7],tbl[8],"checkpoint",2,255,0,0);
			Taxifahrer.blip = createBlip(tbl[6],tbl[7],tbl[8],0,2,255,0,0);
			setElementFrozen(Taxifahrer.ped,true);
			if(getElementData(localPlayer,"Language") == "DE")then
				infobox("Hole den Gast ab.",0,120,0);
			else
				infobox("Get the guest.",0,120,0);
			end
			
			addEventHandler("onClientMarkerHit",Taxifahrer.marker,function(player)
				if(player == localPlayer)then
					Taxifahrer.createMarker("create","createZiel");
					if(getElementData(localPlayer,"Language") == "DE")then
						infobox("Bringe den Gast nun zu seinem Wunschziel. Es wurde mit einem roten Blip markiert.",0,120,0);
					else
						infobox("Take the guest to his desired destination. It is marked with a red blip.",0,120,0);
					end
				end
			end)
			
			addEventHandler("onClientPedDamage",Taxifahrer.ped,function() cancelEvent() end)
		elseif(var == "createZiel")then
			local rnd = math.random(1,#Taxifahrer["Ziele"]);
			local tbl = Taxifahrer["Ziele"][rnd];
			Taxifahrer.marker = createMarker(tbl[1],tbl[2],tbl[3],"checkpoint",2,255,0,0);
			Taxifahrer.blip = createBlip(tbl[1],tbl[2],tbl[3],0,2,255,0,0);
			
			addEventHandler("onClientMarkerHit",Taxifahrer.marker,function(player)
				if(player == localPlayer)then
					if(getElementData(localPlayer,"Language") == "DE")then
						infobox("Du hast den Gast zu seinem Wunschziel gebracht, du erhältst 550€.",0,120,0);
					else
						infobox("You have brought the guest to his desired destination, you will receive 550 €.",0,120,0);
					end
					Taxifahrer.createMarker("create","createPed");
				end
			end)
		end
	end
end
addEvent("Taxifahrer.createMarker",true)
addEventHandler("Taxifahrer.createMarker",root,Taxifahrer.createMarker)