--

-- [[ STELLEN PICKUP ]] --

local StellenPickup = createPickup(240.45231628418,112.76331329346,1003.21875,3,1247,50);
setElementInterior(StellenPickup,10);

addEventHandler("onPickupHit",StellenPickup,function(player)
	if(not(isPedInVehicle(player)))then
		if(getElementDimension(player) == getElementDimension(source))then
			if(getElementData(player,"Wanteds") >= 1)then
				triggerClientEvent(player,"Stellen.openWindow",player);
			else infobox(player,"Hier kannst du dich stellen, wenn du Wanteds hast.",0,120,0)end
		end
	end
end)

-- [[ STELLEN ]] --

addEvent("Stellen.server",true)
addEventHandler("Stellen.server",root,function()
	if(getElementData(client,"Wanteds") >= 1)then
		local jailtime = math.floor(getElementData(client,"Wanteds")*1.5);
		setElementData(client,"Knastzeit",jailtime);
		putPlayerInJail(client);
		infobox(client,"Du hast dich gestellt und wurdest für "..jailtime.." Minuten eingesperrt.",0,120,0);
		setElementData(client,"Wanteds",0);
		triggerClientEvent(client,"dxClassClose",client);
	else infobox(client,"Du hast keine Wanteds!",120,0,0)end
end)

--[[ MUNITION]]

MunitonVehicles = {
	LegitOptions = {
		[433] = true,
		[427] = true,	
	},
	AvailableFaction = {
		[1] = true,
		[2] = true,
		[3] = true,
	}
}

addCommandHandler("munition",
	function(player, cmd, target)
		if getElementData(player, "Fraktion") and MunitonVehicles.AvailableFaction[getElementData(player, "Fraktion")] then
			local fraktion = getElementData(player, "Fraktion")
			local veh = getPedOccupiedVehicle(player)
			if veh and MunitonVehicles.LegitOptions[veh:getModel()] and MunitonVehicles.AvailableFaction[getElementData(veh,"Fraktion")] then
				setPedArmor(player, 100)
				player:sendNotification("Du bist neu ausgerüstet worden!", 0, 255, 0)
			else
				player:sendNotification("Du sitzt in keinem gültigen Fahrzeug!", 125, 0, 0)
			end
		end
	end
)

-- [[ BAILEN ]] --

addCommandHandler("bail",function(player,cmd,target)
	if(getElementData(player,"loggedin") == 1)then
		if(target)then
			local target = getPlayerFromName(target);
			if(isElement(target) and getElementData(target,"loggedin") == 1)then
				local knastzeit = getElementData(target,"Knastzeit");
				if(knastzeit > 0)then
					if(knastzeit <= 15)then
						local costs = knastzeit*250;
						if(getElementData(player,"Geld") >= costs)then
							setElementData(player,"Geld",getElementData(player,"Geld")-costs);
							setElementData(target,"Knastzeit",0);
							freeFromJail(target);
						else infobox(player,"Du hast nicht genug Geld dabei! ("..costs.."€)",120,0,0)end
					else infobox(player,"Spieler können erst ab 15 Minuten gebailt werden!",120,0,0)end
				else infobox(player,"Der Spieler ist nicht im Gefängnis!",120,0,0)end
			else infobox(player,"Der Spieler ist nicht online!",120,0,0)end
		else infobox(player,"Gib einen Spieler an!",120,0,0)end
	end
end)

-- [[ MEGAPHON ]] --

addCommandHandler("m",function(player,cmd,...)
	if(getElementData(player,"loggedin") == 1 and isDuty(player))then
		if(isCop(player) or isFBI(player) or isArmy(player) or isFeuerwehr(player))then
			if(isPedInVehicle(player))then
				local veh = getPedOccupiedVehicle(player);
				local vehFaction = getElementData(veh,"Fraktion");
				if(vehFaction == 1 or vehFaction == 2 or vehFaction == 3 or vehFaction == 9)then
					local text = table.concat({...}," ");
					local nearbyPlayersNames = {};
					for _,v in pairs(getElementsByType("player"))do
						local x,y,z = getElementPosition(v);
						if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 30)then
							table.insert(nearbyPlayersNames, getPlayerName(v));
							if isFeuerwehr(player) then
								outputChatBox("[Feuerwehr "..getPlayerName(player).."] "..text,v,250,250,0);
							else
								outputChatBox("[Staatsbeamter "..getPlayerName(player).."] "..text,v,250,250,0);
							end
						end
					end
					outputConsole("Megafone empfangen von: "..table.concat(nearbyPlayersNames, ", "), player);
				end
			end
		end
	end
end)

--[[ TAZER ]]

function Event_TazerPlayer(attacker, weapon, bodypart, target)
	if not client then return end
	tazerPlayer(client, target)
end
addEvent("RP:Server:Fraktionssystem:Tazer", true)
addEventHandler("RP:Server:Fraktionssystem:Tazer", root, Event_TazerPlayer)

function tazerPlayer(cop, target)
	if getElementData(cop, "Fraktion") == 1 or getElementData(cop, "Fraktion") == 2 or getElementData(cop, "Fraktion") == 3 then
		if not getElementData(cop, "Duty") then
			return
		end

		if (cop:getPosition()-target:getPosition()):getLength() < 5 then
			if not getElementData(target, "getazert") then
				setElementData(target,"damageproof",true)
				setTimer(untazerPlayer,10000,1,target)
				setTimer(setPedAnimation,100,1,target,"CRACK","crckidle2",10000,false,false,false)
				toggleAllControls(target,false)
				toggleControl(target,"chatbox",false)
				setElementFrozen(target,true)
				setElementData(target,"getazert",true,true)
				setElementData(target,"handsup",false,true)
				for all,user in ipairs (getElementsByType("player")) do
					if (cop:getPosition()-user:getPosition()):getLength() < 5 then
						if getElementData(user,"loggedin") == 1 then
							outputChatBox(getPlayerName(cop).." hat "..getPlayerName(target).." getazert!",user,128,128,128)
						end
					end
				end			
			end
		end
	end
end

function untazerPlayer(player)
	if isElement(player) then
		if not getElementData(player,"grabbed") then
			toggleAllControls(player,true)
			setElementFrozen(player,false)
			setPedAnimation(player)
			setTimer(setElementData,1000,1,player,"getazert",false,true)
			if getElementData(player, "Knastzeit") > 0 then
				toggleControl(player,"fire",false)
				-- toggleControl(player,"next_weapon",false)
				-- toggleControl(player,"previous_weapon",false)
				toggleControl(player,"jump",false)
				toggleControl(player,"action",false)
				toggleControl(player,"enter_exit",false)
				toggleControl(player,"enter_passenger",false)
			end
		end
		setElementData(player,"damageproof",false)
	end
end

function Event_GrabPlayer(mouseButton, buttonState, elementClicked)
	if elementClicked and isElement(elementClicked) and getElementType(elementClicked) == "player" then
		grabPlayer(elementClicked, source)
	end
end
addEventHandler("onPlayerClick", root, Event_GrabPlayer)

function grabPlayer(clickedElement, cop)
	local veh = getPedOccupiedVehicle(cop)

	if veh and getVehicleOccupant(veh) == cop then
		local clickposX,clickposY,clickposZ = getElementPosition(veh)
		local posX, posY, posZ = getElementPosition(clickedElement)
		local frak = getElementData(cop,"Fraktion")
		if (frak == 1 or frak == 2 or frak == 3) and getElementData(cop,"Duty") then
			local frak = getElementData(veh,"Fraktion")
			if frak == 1 or frak == 2 or frak == 3 then
				if getElementData(clickedElement,"getazert") or getElementData(clickedElement,"handsup") then
					for i = 0, getVehicleMaxPassengers(veh) do
						local seat = getVehicleMaxPassengers(veh)-i
						if not getVehicleOccupant(veh,seat) then
							if getDistanceBetweenPoints3D(clickposX, clickposY, clickposZ, posX, posY, posZ) <= 5 then
								setPedAnimation(clickedElement)
								toggleAllControls(clickedElement,false)
								toggleControl(clickedElement,"chatbox",false)
								setElementFrozen(clickedElement,true)
								warpPedIntoVehicle(clickedElement,veh,seat)
								setElementData(clickedElement,"grabbed",true,true)
								setElementData(clickedElement,"getazert",false,true)
								break
							end
						end
					end
				end
			end
		end
	end	
end

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

function unleash_pd (player,_,target)
	if target and getPlayerFromPartialName(target) then
		local tg = getPlayerFromPartialName(target)
		local frak = getElementData(player,"Fraktion")
		if (frak == 1 or frak == 2 or frak == 3) and getElementData(player,"Duty") then
			local plX, plY, plZ = getElementPosition(player)
			local targetX, targetY, targetZ = getElementPosition(tg)
			if getElementData(tg,"grabbed") then
				if getDistanceBetweenPoints3D(plX,plY,plZ,targetX,targetY,targetZ) <= 5 then
					setElementData(tg,"grabbed",false,true)
					setElementData(tg,"getazert",false,true)
					setElementData(tg,"handsup",false,true)
					toggleAllControls(tg,true)
					setElementFrozen(tg,false)
					player:sendNotification("Du hast "..getPlayerName(tg).." entfesselt!",0,120,0)
					tg:sendNotification("Du wurdest von "..getPlayerName(player).." entfesselt!",120,120,0)
				else
					player:sendNotification("Du bist zu weit entfernt!",120,0,0)
				end
			else
				player:sendNotification("Spieler ist nicht gefesselt!",120,0,0)
			end
		end
	else
		player:sendNotification("/unleash <Spieler>!",120,0,0)
	end
end
addCommandHandler("unleash",unleash_pd)

function leash_func (player,_,target)
	local frak = getElementData(player,"Fraktion")
	if (frak == 1 or frak == 2 or frak == 3) and getElementData(player,"Duty") then
		if isPedInVehicle(player) and getPedOccupiedVehicleSeat ( player ) == 0 then
			local tg = getPlayerFromPartialName(target)
			if tg and tg ~= player then
				if isPedInVehicle(tg) and getPedOccupiedVehicle(tg) == getPedOccupiedVehicle(player) then
					if not getElementData(tg,"grabbed") then
						toggleAllControls(tg,false)
						setElementFrozen(tg,true)
						setElementData(tg,"grabbed",true,true)
						setElementData(tg,"getazert",false,true)
						player:sendNotification("Du hast "..getPlayerName(tg).." gefesselt!",0,120,0)
						tg:sendNotification("Du wurdest von "..getPlayerName(player).." gefesselt!",120,120,0)
					end
				end
			end
		end
	end
end
addCommandHandler("leash",leash_func)