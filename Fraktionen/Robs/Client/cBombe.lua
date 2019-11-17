Bombe = {};

function Bombe.entschaerfen()
	if(Bombe.code[Bombe.state][5] == Bombe.state)then
		guiLabelSetColor(GUIEditor.label[Bombe.state],0,255,0);
		if(Bombe.state == 9)then
			guiSetVisible(GUIEditor.window[1], false)
			showCursor(false)
			toggleControl("enter_exit",true);
			unbindKey("enter","down",Bombe.entschaerfen);			
			triggerServerEvent("Bombe.defused",localPlayer);
		else
			Bombe.state = Bombe.state + 1;
		end
	else
		for i = 1,9 do
			guiLabelSetColor(GUIEditor.label[i],255,255,255);
		end
		Bombe.state = 1;
	end
end

addEvent("Bombe.defuseWindow",true)
addEventHandler("Bombe.defuseWindow",root,function()
	if(isWindowOpen())then
		Bombe.code = {};
		for i = 1,9 do
			Bombe.code[i] = {};
			for v = 1,5 do
				Bombe.code[i][v] = math.random(1,9);
			end
		end
		Bombe.state =  1;
		Bombe.time = 120;

		--//WINDOW//--
		GUIEditor.window[1] = guiCreateWindow(727, 310, 415, 350, "Bombe entschärfen (Zeit: 120s)", false)
		GUIEditor.label[1] = guiCreateLabel(10, 32, 35, 295, "1\n2\n3\n4\n5", false, GUIEditor.window[1])
		GUIEditor.label[2] = guiCreateLabel(55, 32, 35, 295, "1\n2\n3\n4\n5", false, GUIEditor.window[1])
		GUIEditor.label[3] = guiCreateLabel(100, 32, 35, 295, "1\n2\n3\n4\n5", false, GUIEditor.window[1])
		GUIEditor.label[4] = guiCreateLabel(145, 32, 35, 295, "1\n2\n3\n4\n5", false, GUIEditor.window[1])
		GUIEditor.label[5] = guiCreateLabel(190, 32, 35, 295, "1\n2\n3\n4\n5", false, GUIEditor.window[1])
		GUIEditor.label[6] = guiCreateLabel(235, 32, 35, 295, "1\n2\n3\n4\n5", false, GUIEditor.window[1])
		GUIEditor.label[7] = guiCreateLabel(280, 32, 35, 295, "1\n2\n3\n4\n5", false, GUIEditor.window[1])
		GUIEditor.label[8] = guiCreateLabel(325, 32, 35, 295, "1\n2\n3\n4\n5", false, GUIEditor.window[1])
		GUIEditor.label[9] = guiCreateLabel(370, 32, 35, 295, "1\n2\n3\n4\n5", false, GUIEditor.window[1])
		
		for i = 1,#GUIEditor.label do guiSetFont(GUIEditor.label[i], "sa-header") end
		--//WINDOW//--

		Bombe.timer1 = setTimer(function()
			for id = Bombe.state, 9 do
				Bombe.code[id][5] = Bombe.code[id][4];
				Bombe.code[id][4] = Bombe.code[id][3];
				Bombe.code[id][3] = Bombe.code[id][2];
				Bombe.code[id][2] = Bombe.code[id][1];
				Bombe.code[id][1] = math.random(1,9);
				guiSetText(GUIEditor.label[id],Bombe.code[id][1].."\n"..Bombe.code[id][2].."\n"..Bombe.code[id][3].."\n"..Bombe.code[id][4].."\n"..Bombe.code[id][5]);
			end
		end,500,0)
		
		Bombe.timer2 = setTimer(function()
			Bombe.time = Bombe.time - 1;
			guiSetText(GUIEditor.window[1],"Bombe entschärfen (Zeit: "..Bombe.time.."s)");
			if(Bombe.time == 0)then
				guiSetVisible(GUIEditor.window[1], false)
				showCursor(false)
				toggleControl("enter_exit",true);
				unbindKey("enter","down",Bombe.entschaerfen);
				triggerServerEvent("Bombe.createExplosion",localPlayer);
			end
		end,1000,0)
		toggleControl("enter_exit",false);
		bindKey("enter","down",Bombe.entschaerfen);
	end
end)

addEvent("Bombe.destroyDefuseWindow",true)
addEventHandler("Bombe.destroyDefuseWindow",root,function()
	removeEventHandler("onClientRender",root,Bombe.dxDrawDefuse);
	unbindKey("space","down",Bombe.pressKey);
	if isTimer(Bombe.timer1) then
		killTimer(Bombe.timer1)
	end
	if isTimer(Bombe.timer2) then
		killTimer(Bombe.timer2)
	end	
end)