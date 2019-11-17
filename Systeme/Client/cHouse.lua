--

Haussystem = {};

addEvent("Haussystem.openWindow",true)
addEventHandler("Haussystem.openWindow",root,function(datas)
	if(isWindowOpen())then
		Elements.window[1] = Window:create(459, 428, 363, 169,"Haus (ID: "..datas[4]..")",1280,1024);
		Elements.image[1] = Image:create(469, 498, 93, 89,"Files/Images/House/building.png",1280,1024);
		Elements.text[1] = Text:create(572, 498, 812, 533,"Besitzer: "..datas[2].." - Preis: "..datas[1].."€\nMindestspielzeit: "..datas[3].." Stunden - Miete: "..datas[4].."€",1280,1024);
		Elements.button[1] = Button:create(572, 543, 116, 18,"Kaufen","Haussystem.buySell",1280,1024);
		Elements.button[2] = Button:create(572, 569, 116, 18,"Auf-/Abschließen","Haussystem.lock",1280,1024);
		Elements.button[3] = Button:create(696, 569, 116, 18,"Einmieten","Haussystem.mieten",1280,1024);
		Elements.button[4] = Button:create(696, 543, 116, 18,"Betreten","Haussystem.betreten",1280,1024);
		setWindowDatas();
		
		if(datas[2] ~= "Niemand")then
			if(datas[2] == getPlayerName(localPlayer))then
				Elements.button[1]:setText("Verkaufen");
			else
				Elements.button[1]:setText("-");
			end
		end
    end
end)

function Haussystem.buySell()
	triggerServerEvent("Haussystem.server",localPlayer,Elements.button[1]:getText());
end

function Haussystem.lock()
	triggerServerEvent("Haussystem.lock",localPlayer);
end

function Haussystem.mieten()
	triggerServerEvent("Haussystem.mieten",localPlayer);
end

function Haussystem.betreten()
	triggerServerEvent("Haussystem.in",localPlayer);
end

addEvent("Haussystem.verwaltung",true)
addEventHandler("Haussystem.verwaltung",root,function(datas,mieter)
	if(isWindowOpen())then
		setElementData(localPlayer,"inHouseWindow",true);
        GUIEditor.window[1] = guiCreateWindow(505, 179, 692, 286, "Hausverwaltung", false)

        GUIEditor.label[1] = guiCreateLabel(10, 27, 189, 23, "Mieter:", false, GUIEditor.window[1])
        GUIEditor.gridlist[1] = guiCreateGridList(10, 60, 189, 216, false, GUIEditor.window[1])
        spieler = guiGridListAddColumn(GUIEditor.gridlist[1], "Spieler", 0.9)

        GUIEditor.label[2] = guiCreateLabel(209, 27, 220, 23, "Mietpreis: "..datas[1].."€", false, GUIEditor.window[1])
        GUIEditor.label[3] = guiCreateLabel(209, 60, 97, 31, "Miete:", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(209, 101, 220, 27, "Miete ändern", false, GUIEditor.window[1])
        GUIEditor.edit[1] = guiCreateEdit(316, 60, 113, 31, "", false, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(209, 138, 220, 27, "-", false, GUIEditor.window[1])
        GUIEditor.button[3] = guiCreateButton(209, 175, 220, 27, "Mieter rausschmeißen", false, GUIEditor.window[1])
        GUIEditor.button[4] = guiCreateButton(209, 249, 220, 27, "-", false, GUIEditor.window[1])
        GUIEditor.button[5] = guiCreateButton(209, 212, 220, 27, "-", false, GUIEditor.window[1])
        GUIEditor.memo[1] = guiCreateMemo(439, 60, 243, 179, datas[2], false, GUIEditor.window[1])
        guiMemoSetReadOnly(GUIEditor.memo[1], true)
        GUIEditor.label[4] = guiCreateLabel(439, 27, 243, 23, "Haushaltsregeln:", false, GUIEditor.window[1])
        GUIEditor.button[6] = guiCreateButton(439, 249, 243, 27, "Haushaltsregeln bearbeiten", false, GUIEditor.window[1])
		
		setWindowDatas();
		
		if(#mieter >= 1)then
			for i,v in pairs(mieter)do
				local row = guiGridListAddRow(GUIEditor.gridlist[1]);
				guiGridListSetItemText(GUIEditor.gridlist[1],row,spieler,v,false,false);
			end
		end
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
			local miete = guiGetText(GUIEditor.edit[1]);
			if(#miete >= 1 and tonumber(miete))then
				triggerServerEvent("Haussystem.changeMiete",localPlayer,miete);
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[3],function()
			local clicked = guiGridListGetItemText(GUIEditor.gridlist[1],guiGridListGetSelectedItem(GUIEditor.gridlist[1]),1);
			if(clicked ~= "")then
				triggerServerEvent("Haussystem.kickMieter",localPlayer,clicked);
			end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[6],function()
			if(datas[3] == getPlayerName(localPlayer))then
				if(guiGetText(GUIEditor.button[6]) == "Haushaltsregeln bearbeiten")then
					guiMemoSetReadOnly(GUIEditor.memo[1],false);
					guiSetText(GUIEditor.button[6],"Speichern");
				else
					guiMemoSetReadOnly(GUIEditor.memo[1],true);
					guiSetText(GUIEditor.button[6],"Haushaltsregeln bearbeiten");
					triggerServerEvent("Haussystem.saveText",localPlayer,guiGetText(GUIEditor.memo[1]));
				end
			else infobox("Du bist nicht befugt, die Haushaltsregeln zu bearbeiten!",120,0,0)end
		end,false)
	else
		if(getElementData(localPlayer,"inHouseWindow") == true)then
			destroyElement(GUIEditor.window[1]);
			dxClassClose();
			setElementData(localPlayer,"inHouseWindow",false);
		end
	end
end)

addEvent("refreshHouseMiete",true)
addEventHandler("refreshHouseMiete",root,function(miete)
	guiSetText(GUIEditor.label[2],"Mietpreis: "..miete.."€");
end)

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		setElementData(localPlayer,"inHouseWindow",false);
	end
end)