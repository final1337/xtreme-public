--

Tutorial = {id = 0, text = nil, nextStep = false,
	["Kamerafahrten"] = {
		{-2480.8120117188,122.86228942871,83.998252868652,-2545.6081542969,197.73815917969,70.031715393066,-2597.2163085938,257.37646484375,58.907600402832,-2662.0124511719,332.25231933594,44.941059112549,7000},
		{-2597.2163085938,257.37646484375,58.907600402832,-2662.0124511719,332.25231933594,44.941059112549,-2664.3203125,369.80227661133,31.944118499756,-2761.2810058594,378.85845947266,9.2152099609375,4000},
		{-2664.3203125,369.80227661133,31.944118499756,-2761.2810058594,378.85845947266,9.2152099609375,-2093.5107421875,-59.833885192871,56.655406951904,-2016.9388427734,-117.9002456665,28.996105194092,5000},
		{-2093.5107421875,-59.833885192871,56.655406951904,-2016.9388427734,-117.9002456665,28.996105194092,-1561.9383544922,834.13671875,39.949691772461,-1504.0128173828,911.93182373047,15.607172012329,2000},
		{-1561.9383544922,834.13671875,39.949691772461,-1504.0128173828,911.93182373047,15.607172012329,-1596.5415039063,1188.3468017578,25.988212585449,-1686.9063720703,1229.5098876953,14.164861679077,2000},
		{-1596.5415039063,1188.3468017578,25.988212585449,-1686.9063720703,1229.5098876953,14.164861679077,-2545.3381347656,1333.8232421875,39.332145690918,-2632.0148925781,1373.3063964844,8.86549949646,5000},
		{-2545.3381347656,1333.8232421875,39.332145690918,-2632.0148925781,1373.3063964844,8.86549949646,-2773.5573730469,995.80798339844,104.07620239258,-2797.3447265625,898.73907470703,107.51065826416,7000},
		{-2773.5573730469,995.80798339844,104.07620239258,-2797.3447265625,898.73907470703,107.51065826416,-2066.5314941406,216.17338562012,62.575187683105,-1992.3110351563,151.65199279785,44.455513000488,6000},
		{-2066.5314941406,216.17338562012,62.575187683105,-1992.3110351563,151.65199279785,44.455513000488,-2254.8571777344,12.866701126099,90.895149230957,-2322.6833496094,-59.960330963135,100.68383026123,3000},
	},
	["Texte"] = {
		"Herzlich willkommen auf Xtreme Reallife! Nun folgt ein kleines Tutorial, in welchem dir die Grundlagen unseres Servers erläutert werden. Sobald die Kamera stehen bleibt, kannst du die Leertaste drücken, um fortzufahren.",
		"Dies ist der Noobspawn, an welchem du spawnst, wenn du Zivilist bist. Zu besonderen Anlässen wie Weihnachten, wird hier umdekoriert.",
		"An der Fahrschule kannst du alle Lizenzen beantragen, welche benötigt werden, um Jobs ausführen und einer Fraktion beitreten zu können. Die Prüfungen bestehen immer aus einem Theorie- und einem Praxisteil.",
		"Im Jobcenter erhältst du einen Überblick aller vorhandenen Jobs.",
		"In ganz San Andreas findest du Autohäuser für Boden-, Flug- und Wasserfahrzeuge.",
		"Bereits mit wenigen Stunden kannst du einer Fraktion beitreten, wodurch du die Möglichkeit hast, viele neue Funktionen zu nutzen. Schreibe dazu einfach eine Bewerbung in unserem Forum (www.xtreme-rl.de).",
		"Unser Inventar, welches du mit der Taste 'i' öffnen und schließen kannst, beinhaltet ein Craftingsystem. Du kannst Rohstoffe wie z.B. Holz und Eisen sammeln und mit diesen gewisse Items herstellen.",
		"Mit F1 öffnest du das Hilfemenü, in welchem du ausführliche Texte zu all unseren Systemen findest. Mit F3 öffnest du das Ticketsystem, mit welchem du bei Fragen oder Problemen Kontakt mit den Teammitgliedern aufnehmen kannst.",
		"Um dir deinen Start etwas zu erleichtern, erhältst du 5000€ Startgeld von uns. Nun wünschen wir die viel Spaß beim Spielen!",
	},
};

function Tutorial.start()
	if(Tutorial.id == 0)then
		bindKey("space","down",Tutorial.nextStepFunction);
		setCameraMatrix(-2480.8120117188,122.86228942871,83.998252868652,-2545.6081542969,197.73815917969,70.031715393066);
		addEventHandler("onClientRender",root,Tutorial.dxDraw);
		setElementData(localPlayer,"elementClicked",true);
		setPlayerHudComponentVisible("radar",false);
		setPlayerHudComponentVisible("area_name",false);
		setElementData(localPlayer,"isInTutorial",true);
		showChat(false);
	end
	Tutorial.id = Tutorial.id + 1;
	if(Tutorial.id > #Tutorial["Texte"])then
		removeEventHandler("onClientRender",root,Tutorial.dxDraw);
		triggerServerEvent("newSpawnPlayer",localPlayer,localPlayer);
		setElementData(localPlayer,"elementClicked",false);
		setPlayerHudComponentVisible("radar",true);
		setPlayerHudComponentVisible("area_name",true);
		setElementData(localPlayer,"isInTutorial",false);
		showChat(true);
	else
		local m1,m2,m3,m4,m5,m6 = Tutorial["Kamerafahrten"][Tutorial.id][1],Tutorial["Kamerafahrten"][Tutorial.id][2],Tutorial["Kamerafahrten"][Tutorial.id][3],Tutorial["Kamerafahrten"][Tutorial.id][4],Tutorial["Kamerafahrten"][Tutorial.id][5],Tutorial["Kamerafahrten"][Tutorial.id][6];
		local m7,m8,m9,m10,m11,m12 = Tutorial["Kamerafahrten"][Tutorial.id][7],Tutorial["Kamerafahrten"][Tutorial.id][8],Tutorial["Kamerafahrten"][Tutorial.id][9],Tutorial["Kamerafahrten"][Tutorial.id][10],Tutorial["Kamerafahrten"][Tutorial.id][11],Tutorial["Kamerafahrten"][Tutorial.id][12];
		smoothMoveCamera(m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,Tutorial["Kamerafahrten"][Tutorial.id][13]);
		Tutorial.text = Tutorial["Texte"][Tutorial.id];
		setTimer(function()
			Tutorial.nextStep = true;
		end,Tutorial["Kamerafahrten"][Tutorial.id][13],1)
	end
end
addEvent("Tutorial.start",true)
addEventHandler("Tutorial.start",root,Tutorial.start)

function Tutorial.dxDraw()
	if(Tutorial.text ~= nil)then
        dxDrawRectangle(0*(x/1280), 0*(y/1024), 1280*(x/1280), 73*(y/1024), tocolor(0, 0, 0, 255), false)
        dxDrawRectangle(0*(x/1280), 951*(y/1024), 1280*(x/1280), 73*(y/1024), tocolor(0, 0, 0, 255), false)
		dxDrawRectangle(482*(x/1280), 83*(y/1024), 317*(x/1280), 137*(y/1024), tocolor(28, 28, 28, 213), false)
		dxDrawRectangle(482*(x/1280), 83*(y/1024), 317*(x/1280), 16*(y/1024), tocolor(255, 110, 0, 255), false)
		dxDrawText("Xtreme Reallife - Tutorial ("..Tutorial.id.."/"..#Tutorial["Texte"]..")", 482*(x/1280), 83*(y/1024), 799*(x/1280), 99*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText(Tutorial["Texte"][Tutorial.id], 492*(x/1280), 109*(y/1024), 789*(x/1280), 210*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "default-bold", "left", "top", false, true, false, false, false)
		if(Tutorial.nextStep == true)then
			dxDrawText("- Leertaste zum Fortfahren -", 482*(x/1280), 225*(y/1024), 799*(x/1280), 241*(y/1024), tocolor(255, 255, 255, 255), 1.00*(y/1024), "clear", "center", "center", false, false, false, false, false)
		end
	end
end

function Tutorial.nextStepFunction()
	if(Tutorial.nextStep == true)then
		Tutorial.nextStep = false;
		Tutorial.start();
	end
end