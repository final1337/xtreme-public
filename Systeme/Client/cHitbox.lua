--

-- [[ TABLES ]] --

local Hitglocke,Hitmarker;
weaponDamage = {[8] = 35,[22] = 10,[23] = 0,[24] = 40,[25] = 20,[28] = 5,[29] = 8,[30] = 6,[31] = 8,[32] = 5,[33] = 15,[34] = 50,[51] = 40};

-- [[ BLOODSCREEN ]] --

local bloodAlpha = 0;

function showBloodFlash()
	bloodAlpha = 255;
end
addEvent("showBloodFlash",true)
addEventHandler("showBloodFlash",root,showBloodFlash)

addEventHandler("onClientRender",root,function()
	if(bloodAlpha > 0)then
		dxDrawImage(0,0,x,y,"Files/Images/Bloodscreen.png",0,0,0,tocolor(255,255,255,bloodAlpha));
		bloodAlpha = math.max(0,bloodAlpha-3);
	end
end)

-- [[ PLAYER DAMAGE ]] --

addEventHandler("onClientPlayerDamage",root,function(attacker,weapon,bodypart,loss)
	if source == localPlayer then
		showBloodFlash()
	end
	if(attacker == localPlayer)then
		if getElementData(localPlayer, "Hitmarker") == 1 then
			if source ~= localPlayer then
				local sound = playSound("Files/Sounds/Hitglocke.mp3");
				setSoundVolume(sound,0.2);
			end
		end
		if(weaponDamage[weapon])then
			triggerServerEvent("damageCalcServer",localPlayer,attacker,weapon,bodypart,loss,source);
		end
	end
	if(source == localPlayer)then
		if(not(isPedDead(localPlayer)))then
			showBloodFlash();
		end
		if(weaponDamage[weapon])then cancelEvent()end
	end
end)

function cancelTearGasChoking(weaponID, responsiblePed)
	if ( ( getElementData(localPlayer,"Duty") and getElementData(localPlayer,"Rang") == 3 ) or getElementModel(localPlayer) == 285) and weaponID == 17 then
		cancelEvent(true)
	end
end
addEventHandler("onClientPlayerChoke", getLocalPlayer(), cancelTearGasChoking)

-- [[ HITMARKER ]] --

addCommandHandler("hitglocke",function()
	if(getElementData(localPlayer,"Hitmarker") == 0)then
		setElementData(localPlayer,"Hitmarker",1);
		infobox("Hitglocke aktiviert!",0,120,0);
	else
		setElementData(localPlayer,"Hitmarker",0);
		infobox("Hitglocke deaktiviert!",120,0,0);
	end
end)

-- [[ REDDOT ]] --

local reddot = 0;

function reddot_func()
	if(reddot == 0)then
		reddot = 1;
		addEventHandler("onClientRender",root,reddot_render);
		infobox("Rotpunkt-Visir aktiviert.",0,120,0);
	else
		reddot = 0;
		removeEventHandler("onClientRender",root,reddot_render);
		infobox("Rotpunkt-Visir deaktiviert.",120,0,0);
	end
end
addCommandHandler("reddot",reddot_func)

function reddot_render()
	local weaponslot = getPedWeaponSlot(localPlayer);
	if(weaponslot and weaponslot <= 7 and weaponslot >= 2)then
		if(getPedControlState(localPlayer,"aim_weapon"))then
			local x1,y1,z1 = getPedWeaponMuzzlePosition(localPlayer);
			x1 = x1 + 0.01;
			y1 = y1 + 0.01;
			z1 = z1 + 0.01;
			local x2,y2,z2 = getPedTargetEnd(localPlayer);
			local x3,y3,z3 = getPedTargetCollision(localPlayer);
			if(x3)then
				dxDrawLine3D(x1,y1,z1,x3,y3,z3,tocolor(255,0,0,150),4,false);
			else
				dxDrawLine3D(x1,y1,z1,x2,y2,z2,tocolor(255,0,0,150),4,false);
			end
		end
	end
end

-- [[ DAMAGE ANZEIGE (GANGWAR) ]] --

local DMGAnzeigeText;

addEvent("showDMGAnzeige",true)
addEventHandler("showDMGAnzeige",root,function(player,damage,koerperteil)
	DMGAnzeigeText = player..", "..damage.." Schaden, "..koerperteil;
	if(not(isTimer(DMGAnzeigeTimer)))then
		addEventHandler("onClientRender",root,dxDrawDMGAnzeige)
	end
	if(isTimer(DMGAnzeigeTimer))then killTimer(DMGAnzeigeTimer)end
	DMGAnzeigeTimer = setTimer(function()
		removeEventHandler("onClientRender",root,dxDrawDMGAnzeige);
	end,3000,1)
end)

function dxDrawDMGAnzeige()
	if(isWindowOpen())then
		dxDrawText(DMGAnzeigeText, 594*(x/1440), 860*(y/900), 847*(x/1440), 890*(y/900), tocolor(255, 255, 255, 255), 1.00*(y/900), "default-bold", "center", "center", false, false, false, false, false)
	end
end

-- [[ TAZER ]] --

addEventHandler("onClientPlayerDamage",root,function(attacker, weapon, bodypart)
	if(attacker == localPlayer)then
		if(weapon == 23)then
			local fac = getElementData(attacker,"Fraktion");
			if(getElementData(attacker,"Duty") == true and fac == 1 or fac == 2 or fac == 3)then
				triggerServerEvent("RP:Server:Fraktionssystem:Tazer",root, attacker, weapon, bodypart, source);
				cancelEvent();
			end
		end
	end
end)