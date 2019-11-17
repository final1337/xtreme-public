

local HUD = true;
local Components = {"armour","breath","clock","health","money","wanted","ammo","weapon"};
for _,v in pairs(Components)do setPlayerHudComponentVisible(v,false) end
setElementData(localPlayer,"ShowHUD",true);
local myFont = dxCreateFont( "Anzeigen/Client/HUD/pixel.ttf", 8.5 )
local Alpha = 0;

addEventHandler("onClientRender", root,
    function()
		if(getElementData(localPlayer,"loggedin") == 1 and getElementData(localPlayer,"ShowHUD") == true and getElementData(localPlayer,"isInTutorial") ~= true)then
			if(not(isPlayerMapVisible(localPlayer)) and HUD == true)then
				if(Alpha < 255)then Alpha = Alpha + 5 end
				local time = getRealTime();
				local hour,minute = time.hour,time.minute;
				if(hour < 10)then hour = "0"..hour end
				if(minute < 10)then minute = "0"..minute end
				local health,armor,oxygen = getElementHealth(localPlayer),getPedArmor(localPlayer),getPedOxygenLevel(localPlayer);
				local money,level = getElementData(localPlayer,"Geld"),getElementData(localPlayer,"Level");
				local ammo,totalAmmo = getPedAmmoInClip(localPlayer),getPedTotalAmmo(localPlayer)-getPedAmmoInClip(localPlayer);
				for _,v in pairs(Components)do setPlayerHudComponentVisible(v,false) end
				
				dxDrawImage(1552*(x/1920), 0*(y/1080), 368*(x/1920), 276*(y/1080), "Anzeigen/Client/HUD/HUD.png", 0, 0, 0, tocolor(255, 255, 255, Alpha), false)
				dxDrawImage(1690*(x/1920), 126*(y/1080), 199*(x/1920), 16*(y/1080), "Anzeigen/Client/HUD/LuftBalken.png", 0, 0, 0, tocolor(255, 255, 255, Alpha), false)
				if(isElementInWater(localPlayer))then
					dxDrawText(math.floor(oxygen/1000*100).."%", 1690*(x/1920), 126*(y/1080), 1889*(x/1920), 142*(y/1080), tocolor(1, 0, 0, Alpha), 1.00*(y/1080), myFont, "center", "center", false, false, false, false, false)
				end
				dxDrawImage(1690*(x/1920), 96*(y/1080), 199*(x/1920) , 16*(y/1080), "Anzeigen/Client/HUD/LuftBalken.png", 0, 0, 0, tocolor(255, 255, 255, Alpha), false)
				dxDrawImage(1690*(x/1920), 96*(y/1080), 199*(x/1920) * getElementHealth(localPlayer)/100, 16*(y/1080), "Anzeigen/Client/HUD/Leben.png", 0, 0, 0, tocolor(255, 255, 255, Alpha), false)
				dxDrawImage(1690*(x/1920), 66*(y/1080), 199*(x/1920) , 16*(y/1080), "Anzeigen/Client/HUD/LuftBalken.png", 0, 0, 0, tocolor(255, 255, 255, Alpha), false)
				dxDrawImage(1690*(x/1920), 66*(y/1080), 199*(x/1920) * getPedArmor(localPlayer)/100, 16*(y/1080), "Anzeigen/Client/HUD/Schutzweste.png", 0, 0, 0, tocolor(255, 255, 255, Alpha), false)
				dxDrawText(math.floor(health).."%", 1690*(x/1920), 96*(y/1080), 1889*(x/1920), 112*(y/1080), tocolor(1, 0, 0, Alpha), 1.00*(y/1080), myFont, "center", "center", false, false, false, false, false)
				dxDrawText(math.floor(armor).."%", 1690*(x/1920), 66*(y/1080), 1889*(x/1920), 82*(y/1080), tocolor(1, 0, 0, Alpha), 1.00*(y/1080), myFont, "center", "center", false, false, false, false, false)
				dxDrawText(money, 1776*(x/1920), 152*(y/1080), 1879*(x/1920), 170*(y/1080), tocolor(254, 254, 254, Alpha), 1.80*(y/1080), myFont, "right", "center", false, false, false, false, false)
				dxDrawText("Level "..level, 1851*(x/1920), 184*(y/1080), 1910*(x/1920), 196*(y/1080), tocolor(255, 255, 255, Alpha), 0.80*(y/1080), myFont, "center", "center", false, false, false, false, false)
				dxDrawText(ammo.." - "..totalAmmo, 1776*(x/1920), 184*(y/1080), 1835*(x/1920), 196*(y/1080), tocolor(255, 255, 255, Alpha), 0.80*(y/1080), myFont, "center", "center", false, false, false, false, false)
				dxDrawText(time.monthday.. "." ..time.month+1 .. "." ..time.year+1900, 1690*(x/1920), 46*(y/1080), 1889*(x/1920), 62*(y/1080), tocolor(254, 254, 254, Alpha), 1.00*(y/1080), myFont, "left", "center", false, false, false, false, false)
				dxDrawText(hour, 1839*(x/1920), 43*(y/1080), 1867*(x/1920), 66*(y/1080), tocolor(255, 255, 255, Alpha), 1.60*(y/1080), myFont, "center", "center", false, false, false, false, false)
				dxDrawText(minute, 1882*(x/1920), 43*(y/1080), 1910*(x/1920), 66*(y/1080), tocolor(255, 255, 255, Alpha), 1.60*(y/1080), myFont, "center", "center", false, false, false, false, false)

				if localPlayer:getData("SelectedItem") and itemmanager:getItemTemplate(localPlayer:getData("SelectedItem").ItemId) then
					local selItem = itemmanager:getItemTemplate(localPlayer:getData("SelectedItem").ItemId):getDisplayPicture()
					dxDrawImage(1694*(x/1920), 146*(y/1080), 78*(x/1920), 78*(y/1080), "files/".. selItem, 0, 0, 0, tocolor(255, 255, 255, Alpha), false)
				else
					dxDrawImage(1694*(x/1920), 146*(y/1080), 78*(x/1920), 78*(y/1080), "Files/Images/HUD/Weapons/0.png", 0, 0, 0, tocolor(255, 255, 255, Alpha), false)
				end

				if(getElementData(localPlayer,"Wanteds") >= 1)then
					dxDrawImage(1597*x/1920, 30*y/1080, 37*x/1920, 32*y/1080, "Files/Images/HUD/Wanted.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
					dxDrawText(getElementData(localPlayer,"Wanteds"), 1601*x/1920, 30*y/1080, 1633*x/1920, 61*y/1080, tocolor(0, 0, 0, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
				end
				if getElementData(localPlayer,"Knastzeit")  > 0 then
					dxDrawText(("noch %d Minuten Gefängnis"):format(math.ceil(getElementData(localPlayer,"Knastzeit"))), 1585*(x/1920), 250*(y/1080), 1843*(x/1920), 228*(y/1080), tocolor(255, 255, 255, 255), 2.00, "default-bold", "left", "top", false, false, false, false, false)
				end				
				
				--dxDrawImage(1679, 296, 231, 55, ":Bilder/GangwarLol.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				--dxDrawImage(1679, 239, 231, 57, ":Bilder/DNBRIFA.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				--dxDrawText("5/5", 1679, 266, 1772, 291, tocolor(254, 254, 254, 255), 1.80, "default-bold", "center", "center", false, false, false, false, false)
				--dxDrawText("5/5", 1817, 266, 1910, 291, tocolor(254, 254, 254, 255), 1.80, "default-bold", "center", "center", false, false, false, false, false)
				--dxDrawText("5", 1684, 301, 1712, 323, tocolor(254, 254, 254, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
				--dxDrawText("5000", 1866, 301, 1905, 324, tocolor(254, 254, 254, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
				--dxDrawText("12:04", 1772, 324, 1811, 347, tocolor(254, 254, 254, 255), 1.00, "default-bold", "center", "center", false, false, false, false, false)
			end
		end
    end
)