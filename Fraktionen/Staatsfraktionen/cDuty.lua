--

-- [[ TABLES ]] --

Duty = {};

-- [[ DUTY WINDOW ]] --

addEvent("Duty.openWindow",true)
addEventHandler("Duty.openWindow",root,function()
	if(isWindowOpen())then
		if(getElementData(localPlayer,"Duty") == true)then text = "Dienst verlassen" else text = "Dienst betreten" end
		Elements.window[1] = Window:create(1140, 781, 290, 109,"Duty",1440,900);
		if(getElementData(localPlayer,"Fraktion") == 9 or getElementData(localPlayer,"Fraktion") == 4 or getElementData(localPlayer,"Fraktion") == 3)then
			Elements.button[1] = Button:create(1149, 851, 271, 29,text,"Duty.server",1440,900);
		else
			Elements.button[1] = Button:create(1149, 851, 131, 29,text,"Duty.server",1440,900);
			if(getElementData(localPlayer,"Duty") ~= true)then
				Elements.button[2] = Button:create(1290, 851, 131, 29,"Swat Dienst","Duty.swat",1440,900);
			end
		end
		setWindowDatas();
	end
end)

-- [[ DUTY GEHEN ]] --

function Duty.server()
	triggerServerEvent("Duty.server",localPlayer);
end
addEvent("Duty.server",true)
addEventHandler("Duty.server",root,Duty.server)

function Duty.swat()
	triggerServerEvent("Duty.swat",localPlayer);
end
addEvent("Duty.swat",true)
addEventHandler("Duty.swat",root,Duty.swat)