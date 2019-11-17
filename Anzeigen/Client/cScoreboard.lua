

-- [[ TABLES ]] --

Scoreboard = {open = false, scroll = 0};

-- [[ ÖFFNEN / SCHLIESSEN ]] --

bindKey("tab","down",function()
	if(Scoreboard.open == false)then
		Scoreboard.open = true;
		Scoreboard.update();
		addEventHandler("onClientRender",root,Scoreboard.dxDraw);
		Scoreboard.updateTimer = setTimer(Scoreboard.update,10000,0);
		bindKey("mouse_wheel_down","down",Scoreboard.scrollDown);
		bindKey("mouse_wheel_up","down",Scoreboard.scrollUp);
		--toggleControl("next_weapon",false);
		--toggleControl("previous_weapon",false);
		toggleControl("fire",false);
		toggleControl("action",false);
		bindKey("mouse2","up",Scoreboard.showCursor);	
	end
end)

bindKey("tab","up",function()
	if(Scoreboard.open == true)then
		Scoreboard.open = false;
		removeEventHandler("onClientRender",root,Scoreboard.dxDraw);
		unbindKey("mouse_wheel_down","down",Scoreboard.scrollDown);
		unbindKey("mouse_wheel_up","down",Scoreboard.scrollUp);
		if(isTimer(Scoreboard.updateTimer))then killTimer(Scoreboard.updateTimer)end
		unbindKey("mouse2","up",Scoreboard.showCursor);
		--toggleControl("next_weapon",true);
		--toggleControl("previous_weapon",true);
		if getElementData(localPlayer,"Knastzeit") == 0 then
			toggleControl("fire",true);
			toggleControl("action",true);
		end
		showCursor(false);
	end
end)

-- [[ CURSOR ANZEIGEN ]] --

function Scoreboard.showCursor()
	showCursor(not(isCursorShowing()));
end

-- [[ NACH UNTEN SCROLLEN / NACH OBEN SCROLLEN ]] --

function Scoreboard.scrollDown()
	if(Scoreboard.open == true)then
		if(Scoreboard.scroll <= #getElementsByType("player")-14)then
			Scoreboard.scroll = Scoreboard.scroll + 2;
		end
	end
end

function Scoreboard.scrollUp()
	if(Scoreboard.open == true)then
		if(Scoreboard.scroll <= 2)then
			Scoreboard.scroll = 0;
		else
			Scoreboard.scroll = Scoreboard.scroll - 2;
		end
	end
end

-- [[ FORM STRING SPIELZEIT ]] --

function Scoreboard.formString(text)
	if(string.len(text) == 1)then
		text = "0"..text;
	end
	return text;
end

-- [[ UPDATE DATAS ]] --

function Scoreboard.update()
	pl = {};
	local i = 1;
	
	for id = -1,11 do
		for _,v in pairs(getElementsByType("player"))do
			if(getElementData(v,"loggedin") == 1)then
				if(getElementData(v,"Fraktion") == id)then
					local vanish = getElementData(v, "vanish") or false;
					if (vanish ~= 2) then
						local spielstunden = getElementData(v,"Spielstunden");
						local hour = math.floor(spielstunden/60);
						local minute = spielstunden-hour*60;
						local fac = getElementData(v,"Fraktion");
					
						pl[i] = {};
						pl[i].name = getPlayerName(v);

						pl[i].level = getElementData(v,"Level");
						pl[i].playtime = Scoreboard.formString(hour)..":"..Scoreboard.formString(minute);
						pl[i].fraktion = Fraktionen["Namen"][fac];
						if(getElementData(v,"Adminlevel") == 0 or vanish == 1)then
							pl[i].information = "User";
							if(getElementData(v,"Rang") == 4)then
								pl[i].information = "Co-Leader";
							elseif(getElementData(v,"Rang") == 5)then
								pl[i].information = "Leader";
							end
						elseif (vanish ~= 1) then
							pl[i].information = Adminsystem["Namen"][getElementData(v,"Adminlevel")];
						end
						pl[i].color = {Fraktionen["Farben"][fac][1],Fraktionen["Farben"][fac][2],Fraktionen["Farben"][fac][3]};
						pl[i].fraktionsrang = getElementData(v,"Rang");
						pl[i].job = getElementData(v,"Job");
						pl[i].ping = getPlayerPing(v);
						pl[i].telefonnummer = getElementData(v,"Telefonnummer");
						if getElementData(v,"Adminlevel") > 0 and vanish ~= 1 then
							-- pl[i].name = "#ff7800[#323232Xtm#ff7800]"..RGBToHex(pl[i].color[1],pl[i].color[2],pl[i].color[3])..""..getPlayerName(v)
							pl[i].name = "[Xtm]"..getPlayerName(v)
						end
						if getElementData(v,"AFK") then
							pl[i].name = pl[i].name .. "[AFK]"
						end
						i = i + 1;
					end
				end
			elseif (id == -1) then
				pl[i] = {};
				pl[i].name = getPlayerName(v);
				pl[i].level = "-"
				pl[i].playtime = "-"
				pl[i].fraktion = "-"
				pl[i].color = {255, 255, 255}
				pl[i].fraktionsrang = "-"
				pl[i].job = "-"
				pl[i].ping = getPlayerPing(v);
				pl[i].telefonnummer = "-"
				pl[i].information = "Verbinde.."
				i = i + 1;
			end
		end
	end
end

function RGBToHex(red, green, blue, alpha)
	
	-- Make sure RGB values passed to this function are correct
	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end

	-- Alpha check
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end

end

-- [[ SCOREBOARD ]] --

function Scoreboard.dxDraw()
   	    dxDrawRectangle(621*(x/1920), 368*(y/1080), 677*(x/1920), 33*(y/1080), tocolor(246, 80, 6, 255), false)
        dxDrawRectangle(621*(x/1920), 385*(y/1080), 677*(x/1920), 16*(y/1080), tocolor(233, 75, 5, 255), false)
        dxDrawRectangle(621*(x/1920), 401*(y/1080), 677*(x/1920), 344*(y/1080), tocolor(28, 28, 28, 213), false)
        dxDrawImage(621*(x/1920), 276*(y/1080), 677*(x/1920), 92*(y/1080), "Files/Images/header.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawImage(566*(x/1920), 258*(y/1080), 292*(x/1920), 95*(y/1080), "Files/Images/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawLine(811*(x/1920), 409*(y/1080), 811*(x/1920), 735*(y/1080), tocolor(0, 0, 0, 100), 1, false)
        dxDrawLine(882*(x/1920), 409*(y/1080), 882*(x/1920), 735*(y/1080), tocolor(0, 0, 0, 100), 1, false)
        dxDrawLine(1007*(x/1920), 409*(y/1080), 1007*(x/1920), 735*(y/1080), tocolor(0, 0, 0, 100), 1, false)
        dxDrawLine(1133*(x/1920), 411*(y/1080), 1133*(x/1920), 737*(y/1080), tocolor(0, 0, 0, 100), 1, false)
        dxDrawRectangle(621*(x/1920), 745*(y/1080), 677*(x/1920), 40*(y/1080), tocolor(4, 4, 4, 213), false)
        dxDrawText("Username", 621*(x/1920), 368*(y/1080), 811*(x/1920), 401*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Information", 1133*(x/1920), 368*(y/1080), 1298*(x/1920), 401*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Level", 811*(x/1920), 368*(y/1080), 882*(x/1920), 401*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Spielzeit", 882*(x/1920), 368*(y/1080), 1007*(x/1920), 401*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Fraktion", 1007*(x/1920), 368*(y/1080), 1133*(x/1920), 401*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("© 2019 Xtreme Reallife", 1115*(x/1920), 745*(y/1080), 1288*(x/1920), 785*(y/1080), tocolor(255, 255, 255, 255), 1.20, "default-bold", "right", "center", false, false, false, false, false)

	local id = 0;
	for i = 1 + Scoreboard.scroll,17 + Scoreboard.scroll do
		if(pl[i])then
			if(isCursorOnElement(626*(x/1920), (411+(id*19))*(y/1080), 682*(x/1920), 19*(y/1080))) then
				dxDrawRectangle(621*(x/1920), (411+(id*19))*(y/1080), 677*(x/1920), 19*(y/1080), tocolor(98, 98, 98, 139), false)
				dxDrawRectangle(438*(x/1920), 505*(y/1080), 173*(x/1920), 25*(y/1080), tocolor(246, 80, 6, 255), false)
       		    dxDrawRectangle(438*(x/1920), 530*(y/1080), 173*(x/1920), 92*(y/1080), tocolor(28, 28, 28, 213), false)
				dxDrawRectangle(438*(x/1920), 517*(y/1080), 173*(x/1920), 13*(y/1080), tocolor(233, 75, 5, 255), false)
				dxDrawText(pl[i].name.." - Info", 438*(x/1920), 505*(y/1080), 611*(x/1920), 530*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
				dxDrawText("Job: "..pl[i].job, 448*(x/1920), 540*(y/1080), 601*(x/1920), 556*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, false, false, false, false)
     		    dxDrawText("Telefon: "..pl[i].telefonnummer, 448*(x/1920), 556*(y/1080), 601*(x/1920), 570*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, false, false, false, false)
     		    dxDrawText("Rang: "..pl[i].fraktionsrang, 448*(x/1920), 570*(y/1080), 601*(x/1920), 584*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, false, false, false, false)
     		    dxDrawText(pl[i].information, 448*(x/1920), 584*(y/1080), 601*(x/1920), 598*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, false, false, false, false)
     		    dxDrawText("Ping: "..pl[i].ping, 448*(x/1920), 598*(y/1080), 601*(x/1920), 612*(y/1080), tocolor(29, 255, 5, 152), 1.00, "default-bold", "left", "center", false, false, false, false, false)
			end
		
			dxDrawText(pl[i].name, 631*(x/1920), (411+(id*19))*(y/1080), 803*(x/1920), (430+(id*19))*(y/1080), tocolor(pl[i].color[1],pl[i].color[2],pl[i].color[3], 255), 1.00*(y/1080), "default-bold", "left", "center", false, false, false, true, false)
			dxDrawText(pl[i].level, 813*(x/1920), (411+(id*19))*(y/1080), 882*(x/1920), (430+(id*19))*(y/1080), tocolor(pl[i].color[1],pl[i].color[2],pl[i].color[3], 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText(pl[i].playtime, 882*(x/1920), (411+(id*19))*(y/1080), 1007*(x/1920), (430+(id*19))*(y/1080), tocolor(pl[i].color[1],pl[i].color[2],pl[i].color[3], 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText(pl[i].fraktion, 1007*(x/1920), (411+(id*19))*(y/1080), 1133*(x/1920), (430+(id*19))*(y/1080), tocolor(pl[i].color[1],pl[i].color[2],pl[i].color[3], 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText(pl[i].information, 1133*(x/1920), (411+(id*19))*(y/1080), 1298*(x/1920), (430+(id*19))*(y/1080), tocolor(pl[i].color[1],pl[i].color[2],pl[i].color[3], 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
			
			id = id + 1;
		end
	end

    dxDrawText(#getElementsByType("player").."/200", 621*(x/1920), 745*(y/1080), 696*(x/1920), 785*(y/1080), tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
end