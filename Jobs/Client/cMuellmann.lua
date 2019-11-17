
Muellmann = {objects = {}, blips = {},
	["Tonnen"] = {
		{1334, -1567.5999755859, 647.5, 7.3000001907349, 0, 0, 270},
		{1334, -2676.5, 223.39999389648, 4.4000000953674, 0, 0, 180},
		{1334, -2731.8825683594, 421.74884033203, 4.440972328186, 0, 0, 0},
		{1334, -2012.763671875, 124.65234375, 27.800333023071, 0, 0, 90},
		{1334, -2608.4343261719, 213.37637329102, 6.1895151138306, 0, 0, 4},
		{1334, -2395.6303710938, 335.14956665039, 35.284706115723, 0, 0, 57.9990234375},
		{1334, -2247.3999023438, 767.90002441406, 49.599998474121, 0, 0, 89.494506835938},
		{1334, -2012.8510742188, 456.09957885742, 35.284706115723, 0, 0, 87.996826171875},
		{1334, -2325.19921875, -184.69921875, 35.400001525879, 0, 0, 179.99450683594},
		{1334, -2490.8000488281, 85.199996948242, 25.60000038147, 0, 0, 180.99493408203},
		{1334, -2012.685546875, 893.95611572266, 45.558143615723, 0, 0, 87.994995117188},
		{1334, -2420.3505859375, 497.89117431641, 30.183145523071, 0, 0, 17.994995117188},
		{1334, -1640.2492675781, 722.75964355469, 14.722207069397, 0, 0, 359.99011230469},
		{1334, -1814.9809570312, 148.3385925293, 15.222207069397, 0, 0, 91.989013671875},
		{1334, -1521.2099609375, 891.72265625, 7.300332069397, 0, 0, 87.994995117188},
		{1334, -2034.6195068359, -76.269340515137, 35.433143615723, 0, 0, 181.98852539062},
		{1334, -2700.892578125, -16.168428421021, 4.440957069397, 0, 0, 269.98303222656},
		{1334, -2689.099609375, 329.7998046875, 4.5, 0, 0, 359.99450683594},
		{1334, -2665.9233398438, -216.15899658203, 4.448769569397, 0, 0, 177.97802734375},
		{1334, -2152.5461425781, 270.55517578125, 35.433143615723, 0, 0, 87.973022460938},
	},
};

function Muellmann.createObjects(type)
	for i = 1,20 do
		if(isElement(Muellmann.objects[i]))then destroyElement(Muellmann.objects[i]) end
		if(isElement(Muellmann.blips[i]))then destroyElement(Muellmann.blips[i]) end
	end
	if(isElement(Muellmann.abgabeMarker))then destroyElement(Muellmann.abgabeMarker)end
	if(isElement(Muellmann.abgabeBlip))then destroyElement(Muellmann.abgabeBlip)end
	if(type)then
		for i,v in ipairs(Muellmann["Tonnen"])do
			Muellmann.objects[i] = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7]);
			Muellmann.blips[i] = createBlip(v[2],v[3],v[4],0,2,255,0,0);
			setElementData(Muellmann.objects[i],"TonnenID",i);
			setElementData(Muellmann.objects[i],"Muelltonne",getPlayerName(localPlayer));
		end
		Muellmann.abgabeMarker = createMarker(-1893.7521972656,-1701.8176269531,20.719999313354,"cylinder",5,0,0,255);
		Muellmann.abgabeBlip = createBlip(-1893.7521972656,-1701.8176269531,20.719999313354,0,1,0,0,255);
		
		addEventHandler("onClientMarkerHit",Muellmann.abgabeMarker,function(player)
			if(player == localPlayer)then
				local state = false;
				for i = 1,20 do if(isElement(Muellmann.objects[i]))then state = true end end
				if(state == false)then
					triggerServerEvent("Muellmann.finish",localPlayer);
				end
			end
		end)
	end
end
addEvent("Muellmann.createObjects",true)
addEventHandler("Muellmann.createObjects",root,Muellmann.createObjects)

function Muellmann.checkFinish()
	local state = false;
	for i = 1,20 do if(isElement(Muellmann.objects[i]))then state = true end end
	if(state == false)then
		if(getElementData(localPlayer,"Language") == "DE")then
			infobox("Fahre nun zur Mülldeponie und leere dein Fahrzeug.",0,120,0);
		else
			infobox("Now drive to the landfill and empty your vehicle.",0,120,0);
		end
	end
end

addEventHandler("onClientClick",root,function(mouseButton,buttonState,absoluteX,absoluteY,worldX,worldY,worldZ,clickedElement)
	if(clickedElement)then
		local clickposX,clickposY,clickposZ = getElementPosition(clickedElement);
		local posx,posy,posz = getElementPosition(localPlayer);
		if(getDistanceBetweenPoints3D(clickposX,clickposY,clickposZ,posx,posy,posz) <= 10)then
			if(isElement(clickedElement) and getElementData(clickedElement,"TonnenID") and getElementData(clickedElement,"Muelltonne") == getPlayerName(localPlayer))then
				destroyElement(Muellmann.blips[getElementData(clickedElement,"TonnenID")]);
				destroyElement(clickedElement);
				Muellmann.checkFinish();
			end
		end
	end
end)