

Pizzalieferant = {
	["Marker"] = {
		{2073.6242675781,-1731.9841308594,13.580310821533},
		{2073.7722167969,-1704.4002685547,13.582773208618},
		{2074.0363769531,-1655.2552490234,13.566186904907},
		{2074.1711425781,-1631.8941650391,13.587842941284},
		{2009.4984130859,-1629.732421875,13.582030296326},
		{2009.0295410156,-1655.0932617188,13.581575393677},
		{2009.1768798828,-1702.8986816406,13.590987205505},
		{2009.2674560547,-1730.6783447266,13.575466156006},
		{2095.5671386719,-1806.3120117188,13.590565681458},
	},
};

function Pizzalieferant.createMarker(type,var)
	if(isElement(Pizzalieferant.marker))then destroyElement(Pizzalieferant.marker)end
	if(isElement(Pizzalieferant.blip))then destroyElement(Pizzalieferant.blip)end
	if(type)then
		if(var and var == "start")then Pizzalieferant.points = 1 end
		local tbl = Pizzalieferant["Marker"][Pizzalieferant.points];
		local x,y,z = tbl[1],tbl[2],tbl[3];
		Pizzalieferant.marker = createMarker(x,y,z,"checkpoint",1.5,255,0,0);
		Pizzalieferant.blip = createBlip(x,y,z,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Pizzalieferant.marker,function(player)
			if(player == localPlayer)then
				Pizzalieferant.points = Pizzalieferant.points + 1;
				if(Pizzalieferant.points > #Pizzalieferant["Marker"])then
					triggerServerEvent("Pizzalieferant.abgabe",localPlayer);
				else
					Pizzalieferant.createMarker("create");
				end
			end
		end)
	end
end
addEvent("Pizzalieferant.createMarker",true)
addEventHandler("Pizzalieferant.createMarker",root,Pizzalieferant.createMarker)