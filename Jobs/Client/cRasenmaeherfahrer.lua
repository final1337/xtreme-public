
Rasenmaeherfahrer = {
	["Marker"] = {
		{2017.0040283203,-1244.1518554688,23.077033996582},
		{2038.4763183594,-1241.8875732422,22.809827804565},
		{2053.4353027344,-1229.1174316406,23.615917205811},
		{2041.8796386719,-1221.3859863281,22.799911499023},
		{2005.9567871094,-1234.9493408203,21.198207855225},
		{1954.7452392578,-1242.6502685547,19.634433746338},
		{1929.6218261719,-1245.2813720703,17.659938812256},
		{1899.1184082031,-1243.9929199219,14.713828086853},
		{1877.1755371094,-1247.0782470703,13.705984115601},
		{1867.2797851563,-1228.6292724609,16.884742736816},
		{1877.9240722656,-1208.7818603516,19.152158737183},
		{1872.92578125,-1196.1136474609,22.024061203003},
		{1876.9753417969,-1180.3223876953,23.545936584473},
		{1881.5323486328,-1161.16015625,23.851804733276},
		{1893.4389648438,-1149.9014892578,24.180339813232},
		{1914.6528320313,-1149.5836181641,24.00926399231},
		{1915.0466308594,-1168.8852539063,23.126811981201},
		{1923.5003662109,-1181.4245605469,21.318340301514},
		{1940.5550537109,-1179.5086669922,20.016012191772},
		{1949.4025878906,-1164.9183349609,20.681812286377},
		{1987.5256347656,-1161.7119140625,20.754568099976},
		{2014.1341552734,-1152.3277587891,23.009637832642},
		{2035.5163574219,-1151.5130615234,23.443592071533},
		{2052.7375488281,-1169.2198486328,23.479581832886},
		{2053.1245117188,-1194.5357666016,23.544082641602},
		{2053.6408691406,-1217.2574462891,23.630823135376},
		{2051.4411621094,-1236.9788818359,23.477966308594},
		{2032.6752929688,-1203.5397949219,22.014064788818},
	},
};

function Rasenmaeherfahrer.createMarker(type)
	if(isElement(Rasenmaeherfahrer.marker))then destroyElement(Rasenmaeherfahrer.marker)end
	if(isElement(Rasenmaeherfahrer.blip))then destroyElement(Rasenmaeherfahrer.blip)end
	if(type)then
		local rnd = math.random(1,#Rasenmaeherfahrer["Marker"]);
		local tbl = Rasenmaeherfahrer["Marker"][rnd];
		local x,y,z = tbl[1],tbl[2],tbl[3];
		Rasenmaeherfahrer.marker = createMarker(x,y,z,"checkpoint",1.5,255,0,0);
		Rasenmaeherfahrer.blip = createBlip(x,y,z,0,2,255,0,0);
		
		addEventHandler("onClientMarkerHit",Rasenmaeherfahrer.marker,function(player)
			if(player == localPlayer)then
				triggerServerEvent("Rasenmaeherfahrer.abgabe",localPlayer);
				Rasenmaeherfahrer.createMarker("create");
			end
		end)
	end
end
addEvent("Rasenmaeherfahrer.createMarker",true)
addEventHandler("Rasenmaeherfahrer.createMarker",root,Rasenmaeherfahrer.createMarker)