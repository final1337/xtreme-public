

-- [[ TABLES ]] --

Tacho = {};

-- [[ TACHO ]] --

function Tacho.dxDraw()
	local veh = getPedOccupiedVehicle(localPlayer);
	if(veh)then
		local vehModel = getElementModel(veh);
		local coords = {x-270-50,y-237-50,270,237};
		if(vehModel == 509 or vehModel == 510 or vehModel == 481)then
			dxDrawImage(coords[1],coords[2],coords[3],coords[4],"Files/Images/Tacho/BGFahrrad.png");
		else
			local Benzin = getElementData(veh,"Fuel") or 100;
			local Kilometerstand = getElementData(veh,"Kilometer") or 0;
			dxDrawImage(coords[1],coords[2],coords[3],coords[4],"Files/Images/Tacho/BG.png");
			dxDrawImage(coords[1]+203,coords[2]+92,75,75,"Files/Images/Tacho/Nadeltank.png",-110*1.7-Benzin*1.7);

			if(getVehicleNitroCount(veh) and getVehicleNitroCount(veh) >= 1 or isVehicleNitroActivated(veh))then
				local nitro = getVehicleNitroLevel(veh);
				dxDrawText("x"..getVehicleNitroCount(veh),coords[1]+134,coords[2]+122,coords[1]+144,coords[2]+132,tocolor(96,96,96,255),0.7,"default-bold","left","bottom");
				if(isVehicleNitroRecharging(veh))then
					dxDrawImage(coords[1]+74,coords[2]+137,97*nitro,7,"Files/Images/Tacho/1pxAufladen.png");
				else
					dxDrawImage(coords[1]+74,coords[2]+137,97*nitro,7,"Files/Images/Tacho/1pxNos.png");
				end
			end
			if(getElementData(veh,"Verschleiß") and getElementData(veh,"Verschleiß") == true)then dxDrawImage(x-320.88,y-237,20,20,"Files/Images/Tacho/Achtung.png")end
			
			dxDrawText(math.floor(Kilometerstand/1000).."." .. math.floor(Kilometerstand%1000/100) .. "KM",coords[1]+70,coords[2]+154,coords[1]+165,coords[2]+170,tocolor(255,255,255,255),1,"default-bold","right","center");
			if(getVehicleEngineState(veh))then dxDrawImage(coords[1]+136.39,coords[2]+83.60,50.49,25.30,"Files/Images/Tacho/Batterie.png") end
			if(getVehicleOverrideLights(veh) == 2)then dxDrawImage(coords[1]+62.80,coords[2]+83.50,47.24,23.62,"Files/Images/Tacho/Licht.png") end

			local speedX,speedY,speedZ = getElementVelocity(veh);
			dxDrawImage(x-270+15-50,y-237+11-50,218,218,"Files/Images/Tacho/Tachonadel.png",46+(speedX^2+speedY^2+speedZ^2)^(0.5)*180);
		end
	else
		removeEventHandler("onClientRender",root,Tacho.dxDraw);
	end
end

-- [[ SPIELER STEIGT EIN / STIRBT ]] --

addEventHandler("onClientVehicleEnter",root,function(player,seat)
	if(player == localPlayer and seat == 0)then
		addEventHandler("onClientRender",root,Tacho.dxDraw);
	end
end)

addEventHandler("onClientPlayerWasted",root,function(player)
	if(player == localPlayer)then
		removeEventHandler("onClientRender",root,Tacho.dxDraw);
	end
end)

-- [[ TEMPOMAT ]] --

local maxSpeed = 300;

addCommandHandler("limit",function(player,tempo)
	if(tempo)then
		local tempo = tonumber(tempo);
		if(tempo >= 80 and tempo <= 300)then
			maxSpeed = tempo;
			limitTimer = setTimer(function()
				local veh = getPedOccupiedVehicle(localPlayer);
				if(veh)then
					if(isVehicleOnGround(veh) and getVehicleOccupant(veh) == localPlayer)then
						local vx,vy,vz = getElementVelocity(veh);
						local speed = (vx^2+vy^2+vz^2)^(0.5)*180;
						if(speed > maxSpeed)then
							setElementVelocity(veh,vx*0.97,vy*0.97,vz*0.97);
						end
					end
				end
			end,50,0)
			infobox("Limit gesetzt auf: "..tempo.." - Tippe /limit, um es wieder zu entfernen.",0,120,0);
		else infobox("Du hast keinen Betrag angegeben!",120,0,0)end
	else
		if(isTimer(limitTimer))then
			killTimer(limitTimer);
			maxSpeed = 300;
			infobox("Das Limit wurde entfernt.",0,120,0);
		end
	end
end)