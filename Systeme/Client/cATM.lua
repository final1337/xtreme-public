--[[

	(c) FiNAL
	Xtreme Reallife
	2019

]]--

Bank = {}

local sX, sY = guiGetScreenSize()
local x, y = sX/2-500/2, sY/2-500/2

addEvent("ATM.createWindow", true)
addEventHandler("ATM.createWindow", root, function()
	if not getElementData(localPlayer, "Clicked") then
		showCursor(true)
		setElementData(localPlayer, "Clicked", true)
		drawWindow("Bank", "Window", "Bank of Xtreme", x, y, 500, 500, "Bank.close")
		drawImage("Bank", "Image", x+15, y+60, 150, 80, "Files/Images/ATM/atm")
		drawImage("Bank", "Header", x+15, y+150, 470, 100, "Files/Images/ATM/bank")
		drawRectangle("Bank", "Rectangle", x, y+55, 500, 465, tocolor(75, 75, 75, 200))
		drawRectangle("Bank", "Rectangle1", x+10, y+55, 480, 455, tocolor(50, 50, 50, 255))
		drawRectangle("Bank", "Line", x+10, y+255, 480, 25, tocolor(0, 100, 150, 50))
		drawRectangle("Bank","Background",x+10, y+55, 480, 90, tocolor(3, 64, 116, 255))
		Bank.main = function()
			drawText("Bank_1", "Text", "Bitte wählen Sie einen der folgenden Optionen aus:", x+110, y+260, 300, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawImage("Bank_1", "Info", x+140, y+305, 30, 30, "Files/Images/ATM/bankinfo")
			drawImage("Bank_1", "Abstract", x+330, y+305, 30, 30, "Files/Images/ATM/bankauszug")
			drawImage("Bank_1", "Transfer", x+140, y+405, 30, 30, "Files/Images/ATM/transfer")
			--drawImage("Bank_1", "PayIn", x+310, y+405, 70, 30, "Files/Images/ATM/payin")
			drawImage("Bank_1", "PayIn", x+325, y+405, 35, 35, "Files/Images/ATM/payin")
			drawButton("Bank_1", "Kontoinformationen", "Kontoinformationen", x+80, y+340, 150, 40, "Bank.info")
			drawButton("Bank_1", "Überweisen", "Überweisen", x+80, y+440, 150, 40, "Bank.transfer")
			drawButton("Bank_1", "Kontoauszüge", "Kontoauszüge", x+270, y+340, 150, 40, "Bank.xml")
			drawButton("Bank_1", "Geld einzahlen/auszahlen", "Geld einzahlen/auszahlen", x+270, y+440, 150, 40, "Bank.payIn")
		end
		Bank.main()
		Bank.info = function()
			destroyWindow("Bank_1")
			drawRectangle("Bank_Info", "Rectangle", x+50, y+320, 405, 20, tocolor(255, 255, 255, 50))
			drawRectangle("Bank_Info", "Rectangle_1", x+50, y+340, 405, 90, tocolor(255, 255, 255, 50))
			drawButton("Bank_Info", "Zurück", "Zurück", x+195, y+450, 100, 30, "Bank.back")
			drawText("Bank_Info", "Geld", getElementData(localPlayer, "Bankgeld").."€", x+50, y+335, 405, 100, tocolor(255, 255, 255, 255), 2, "default", "center", "center")
			drawText("Bank_Info", "Kontoinformationen", "Kontoinformationen:", x+185, y+260, 300, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawText("Bank_Info", "Kontostand", "Kontostand:", x+60, y+325, 300, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
		end
		Bank.close = function()
			setTimer(function() setElementData(localPlayer, "Clicked", false) end, 100, 1)
			destroyWindow("Bank")
			destroyWindow("Bank_1")
			destroyWindow("Bank_PayIn")
			destroyWindow("Bank_Abstract")
			destroyWindow("Bank_Transfer")
			destroyWindow("Bank_Info")
			showCursor(false)
		end
		Bank.back = function()
			setTimer(function() setElementData(localPlayer, "Clicked", false) Bank.main() end, 100, 1)
			destroyWindow("Bank_PayIn")
			destroyWindow("Bank_Abstract")
			destroyWindow("Bank_Transfer")
			destroyWindow("Bank_Info")
		end
		Bank.xml = function()
			destroyWindow("Bank_1")
			local xml = {}
			local file = fileOpen("XML/Abstract.xml")
			local size = fileGetSize(file)
			local input = fileRead(file, size)
			local split = split(input, " \n")
			for k, v in ipairs(split) do
				local n = split(v, "|")
				xml[#spl-i+1] = {s[1], s[2], s[3]}
			end
			drawButton("Bank_Abstract", "Zurück", "Zurück", x+195, y+450, 100, 30, "Bank.back")
			drawText("Bank_Abstract", "Kontoauszüge", "Kontoauszüge", x+205, y+260, 300, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawGridlist("Bank_Abstract", "Gridlist", x+15, 285, 470, 150, {{"Zeitpunkt", 75}, {"Verwendungszweck", 250}, {"Betrag", 100}}, xml)
		end
		Bank.payIn = function()
			destroyWindow("Bank_1")
			drawText("Bank_PayIn", "Text", "Einzahlen/Auszahlen", x+195, y+260, 300, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawText("Bank_PayIn", "Aktuelles Bargeld", "Aktueller Kontostand: "..getElementData(localPlayer, "Bankgeld").."€", x+54, y+308.5, 200, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawText("Bank_PayIn", "Wunschbetrag", "Wunschbetrag:", x+163, y+340.5, 200, 81, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawText("Bank_PayIn", "€", "€", x+430, y+340, 100, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawRectangle("Bank_PayIn", "Background", x+50, y+310, 220, 20, tocolor(255, 255, 255, 50))
			drawRectangle("Bank_PayIn", "Background_1", x+155, y+341, 120, 20, tocolor(255, 255, 255, 50))
			drawEdit("Bank_PayIn", "Betrag", "", x+290, y+340, 135)
			drawButton("Bank_PayIn", "Einzahlen", "Einzahlen", x+50, y+375, 190, 30, "Bank.payIn_Func")
			drawButton("Bank_PayIn", "Auszahlen", "Auszahlen", x+250, y+375, 190, 30, "Bank.payOut_Func")
			drawButton("Bank_PayIn", "Zurück", "Zurück", x+200, y+430, 100, 30, "Bank.back")
		end
		Bank.transfer = function()
			destroyWindow("Bank_1")
			drawRectangle("Bank_Transfer", "Background_1", x+50, y+300, 220, 20, tocolor(255, 255, 255, 50))
			drawRectangle("Bank_Transfer", "Background_2", x+50, y+330, 220, 20, tocolor(255, 255, 255, 50))
			drawRectangle("Bank_Transfer", "Background_3", x+50, y+360, 220, 20, tocolor(255, 255, 255, 50))
			drawButton("Bank_Transfer", "Überweisen_Button", "Überweisen", x+50, y+390, 390, 30, "Bank.transfer_Func")
			drawButton("Bank_Transfer", "Back", "Zurück", x+195, y+450, 100, 30, "Bank.back")
			drawText("Bank_Transfer", "Überweisen", "Überweisen", x+215, y+260, 300, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawText("Bank_Transfer", "Empfänger", "Empfänger", x+200, y+300, 100, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawText("Bank_Transfer", "Betrag", "Betrag", x+220, y+330, 100, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawText("Bank_Transfer", "€", "€", x+430, y+329, 100, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawText("Bank_Transfer", "Verwendungszweck", "Verwendungszweck", x+150, y+360, 160, 100, tocolor(255, 255, 255, 255), 1, "default", "left", "top")
			drawEdit("Bank_Transfer", "Betrag_Edit", "", x+290, y+330, 135)
			drawEdit("Bank_Transfer", "Empfänger_Edit", "", x+290, y+300, 150)
			drawEdit("Bank_Transfer", "Verwendungszweck_Edit", "", x+290, y+360, 150)
		end
	end
end)

Bank.transfer_Func = function()
	triggerServerEvent("Bank.transfer", localPlayer, getEditText("Bank_Transfer", "Empfänger_Edit"), getEditText("Bank_Transfer", "Betrag_Edit"), getEditText("Bank_Transfer", "Verwendungszweck_Edit"))
end

Bank.payIn_Func = function()
	triggerServerEvent("Bank.payIn", localPlayer, getEditText("Bank_PayIn", "Betrag"))
end

Bank.payOut_Func = function()
	triggerServerEvent("Bank.payOut", localPlayer, getEditText("Bank_PayIn", "Betrag"))
end

-- ATM = {};

-- addEvent("ATM.createWindow",true)
-- addEventHandler("ATM.createWindow",root,function(besitzer)
	-- if(isWindowOpen())then
		-- Elements.window[1] = Window:create(750, 300, 450, 475, "Bank of Xtreme", 1920, 1080)
		-- Elements.image[1] = Image:create(755, 450, 440, 92, "Files/Images/ATM/bank.png", 1920, 1080)
		-- Elements.text[1] = Text:create(750, 547, 1192, 580, "Bitte wählen Sie eine der folgenden Optionen aus:", 1920, 1080)
		-- Elements.image[2] = Image:create(842, 590, 38, 38, "Files/Images/ATM/bankinfo.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		-- Elements.image[3] = Image:create(1072, 590, 41, 38, "Files/Images/ATM/bankauszug.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		-- Elements.button[1] = Button:create(774, 633, 177, 34, "Kontoinformationen", "ATM.information", 1920, 1080)
		-- Elements.button[2] = Button:create(1001, 633, 177, 34, "Kontoauszüge", "ATM.auszug", 1920, 1080)
		-- Elements.button[3] = Button:create(774, 723, 177, 34, "Überweisen", "ATM.protocol", 1920, 1080)
		-- Elements.button[4] = Button:create(1001, 723, 177, 34, "Geld ein/auszahlen", "ATM.cash", 1920, 1080)
		-- -- if(besitzer == "Niemand")then Garagen.text = "Kaufen" else Garagen.text = "Verkaufen" end
		-- -- Elements.window[1] = Window:create(1143, 684, 287, 206,"Garage",1920,1080);
		-- -- Elements.image[1] = Image:create(1087, 754, 271, 129,"Files/Images/Garage.png",1440,900);
		-- -- Elements.text[1] = Text:create(1297, 754, 1420, 849,"Besitzer: "..besitzer.."\nPreis: 150000€",1440,900);
		-- -- Elements.button[1] = Button:create(1297, 856, 123, 27,Garagen.text,"Garagen.server",1440,900);
		-- setWindowDatas();
	-- end
-- end)
