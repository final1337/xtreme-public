

Jobcenter = {
	["Positionen"] = {
		["Arzt"] = {-2539.3830566406,582.01397705078,14.453125},
		["Betonmischerfahrer"] = {2519.9880371094,-2121.2326660156,13.546875},
		["Busfahrer"] = {-2265.7641601563,177.65914916992,35.3125},
		["Fischer"] = {-1726.2938232422,1431.3934326172,1.4067287445068},
		["Landwirt"] = {-1061.5953369141,-1195.4946289063,129.828125},
		["Pilot"] = {-1421.1649169922,-286.99438476563,14.1484375},
		["Pizzalieferant"] = {2105.4865722656,-1806.5010986328,13.5546875},
		["Rasenmäherfahrer"] = {1996.2210693359,-1283.4855957031,23.965635299683},
		["Straßenreiniger"] = {-2102.1162109375,-12.345714569092,35.3203125},
		["Taxifahrer"] = {-2172.4597167969,252.05914306641,35.339382171631},
		["Trucker"] = {-1830.2769775391,109.02180480957,15.1171875},
		["Muellmann"] = {-1897.7041015625,-1681.4636230469,23.015625},
		["Bergarbeiter"] = {-1096.4846191406,-1614.7548828125,76.37393951416},
	},
};

Jobcenter.ped = createPed(17,1714.4162597656,-1673.1314697266,20.218799591064,0);
setElementInterior(Jobcenter.ped,18);
addEventHandler("onClientPedDamage",Jobcenter.ped,function() cancelEvent() end)

Jobcenter.marker = createMarker(1714.4085693359,-1671.1037597656,19.200199127197,"cylinder",1,0,0,255);
setElementInterior(Jobcenter.marker,18);

addEventHandler("onClientMarkerHit", Jobcenter.marker, function(player)
	if(player == localPlayer)then
		if(getElementDimension(localPlayer) == getElementDimension(source))then
			Elements.window[1] = Window:create(785, 327, 351, 426,"Jobcenter",1920,1080);
			Elements.gridlist[1] = Gridlist:create(795, 397, 331, 296,{"Jobs",{"Arzt","Betonmischerfahrer","Busfahrer","Fischer","Landwirt","Pilot","Pizzalieferant","Rasenmäherfahrer","Straßenreiniger","Taxifahrer","Trucker","Muellmann","Bergarbeiter"}},1920,1080);
			Elements.button[1] = Button:create(795, 703, 331, 40,loc"JOB_ANZEIGEN","Jobcenter.showPos",1920,1080);
			setWindowDatas();
		end
	end
end)

function Jobcenter.showPos()
	local job = Elements.gridlist[1]:getClicked();
	local x,y,z = Jobcenter["Positionen"][job][1],Jobcenter["Positionen"][job][2],Jobcenter["Positionen"][job][3];
	if(isElement(Jobcenter.blip))then destroyElement(Jobcenter.blip)end
	if(isTimer(Jobcenter.timer))then killTimer(Jobcenter.timer)end
	Jobcenter.blip = createBlip(x,y,z,0,2,255,0,0);
	infobox(loc"JOBCENTER_BLIP",0,120,0);
	Jobcenter.timer = setTimer(function()
		destroyElement(Jobcenter.blip);
	end,300000,1)
end
addEvent("Jobcenter.showPos",true)
addEventHandler("Jobcenter.showPos",root,Jobcenter.showPos)