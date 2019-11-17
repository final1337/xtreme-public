

Strassenreiniger = {
	["Marker"] = {
		{-2084.7866210938,0.24575898051262,35.145133972168},
		{-2025.7467041016,27.011745452881,33.785701751709},
		{-2004.2357177734,144.22271728516,27.510242462158},
		{-2000.4443359375,317.99133300781,34.988395690918},
		{-2000.0875244141,469.10693359375,34.98766708374},
		{-2111.7854003906,506.17922973633,34.986885070801},
		{-2203.076171875,510.31716918945,34.987319946289},
		{-2257.7358398438,421.74926757813,34.986907958984},
		{-2254.4758300781,223.22605895996,35.134613037109},
		{-2259.5036621094,9.5591402053833,35.143047332764},
		{-2175.984375,-72.366943359375,35.143863677979},
		{-2110.5793457031,-72.541557312012,35.143943786621},
		{-2085.2258300781,-30.908422470093,35.178955078125},
	},
};

function Strassenreiniger.createMarker(type,var)
	if(isElement(Strassenreiniger.marker))then destroyElement(Strassenreiniger.marker)end
	if(isElement(Strassenreiniger.blip))then destroyElement(Strassenreiniger.blip)end
	if(type)then
		if(var and var == "start")then Strassenreiniger.points = 1 end
		local tbl = Strassenreiniger["Marker"][Strassenreiniger.points];
		local x,y,z = tbl[1],tbl[2],tbl[3];
		Strassenreiniger.marker = createMarker(x,y,z,"checkpoint",1.5,255,0,0);
		Strassenreiniger.blip = createBlip(x,y,z,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Strassenreiniger.marker,function(player)
			if(player == localPlayer)then
				Strassenreiniger.points = Strassenreiniger.points + 1;
				if(Strassenreiniger.points > #Strassenreiniger["Marker"])then
					triggerServerEvent("Strassenreiniger.abgabe",localPlayer);
				else
					Strassenreiniger.createMarker("create");
				end
			end
		end)
	end
end
addEvent("Strassenreiniger.createMarker",true)
addEventHandler("Strassenreiniger.createMarker",root,Strassenreiniger.createMarker)