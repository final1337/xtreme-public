
Busfahrer = {
	["Marker"] = {
		{-2254.7983398438,123.20426177979,35.199821472168},
		{-2261.4553222656,-172.77207946777,35.2065544128423},
		{-2062.7348632813,-72.789703369141,35.204555511475},
		{-1999.6901855469,315.02249145508,35.048553466797},
		{-1999.9079589844,874.73107910156,45.322906494141},
		{-2117.0480957031,1081.4117431641,55.610855102539},
		{-2390.7258300781,789.80609130859,35.057151794434},
		{-2581.3566894531,569.47955322266,14.49614906311},
		{-2721.2270507813,417.86877441406,4.1763968467712},
		{-2707.9926757813,246.97055053711,4.209388256073},
		{-2708.3513183594,-194.7924041748,4.2119159698486},
		{-2418.8212890625,-148.07200622559,35.205486297607},
		{-2413.4958496094,243.36074829102,35.050060272217},
		{-2298.3642578125,404.92617797852,35.052619934082},
		{-2254.1999511719,185.93374633789,35.197608947754},
	},
};

function Busfahrer.createMarker(type,var)
	if(isElement(Busfahrer.marker))then destroyElement(Busfahrer.marker)end
	if(isElement(Busfahrer.blip))then destroyElement(Busfahrer.blip)end
	if(type)then
		if(var and var == "start")then Busfahrer.points = 1 end
		local tbl = Busfahrer["Marker"][Busfahrer.points];
		local x,y,z = tbl[1],tbl[2],tbl[3];
		Busfahrer.marker = createMarker(x,y,z,"checkpoint",3,255,0,0);
		Busfahrer.blip = createBlip(x,y,z,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Busfahrer.marker,function(player)
			if(player == localPlayer)then
				Busfahrer.points = Busfahrer.points + 1;
				if(Busfahrer.points > #Busfahrer["Marker"])then
					triggerServerEvent("Busfahrer.abgabe",localPlayer);
				else
					Busfahrer.createMarker("create");
				end
			end
		end)
	end
end
addEvent("Busfahrer.createMarker",true)
addEventHandler("Busfahrer.createMarker",root,Busfahrer.createMarker)