--

-- [[ TABLES ]] --

Burgershot = {peds = {}, timer = {},
	["Preise"] = {
		["Bleeder Meal"] = {3,25,"Bleeder Meal"},
		["Money Shot Meal"] = {5,60,"Money Shot Meal"},
		["Torpedo Meal"] = {8,100,"Torpedo Meal"},
	},
};

-- [[ PED ]] --

function Burgershot.createPed(id)
	if(isElement(Burgershot.peds[id]))then destroyElement(Burgershot.peds[id])end
	Burgershot.peds[id] = createPed(205,376.51058959961,-65.849426269531,1001.5078125,180);
	setElementInterior(Burgershot.peds[id],10)
	setElementDimension(Burgershot.peds[id],id);
	setElementData(Burgershot.peds[id],"BurgershotID",id);
	
	addEventHandler("onPedWasted",Burgershot.peds[id],function(ammo,killer,weapon,bodypart)
		local x,y,z = getElementPosition(source);
		local pickup = createPickup(x,y,z,3,1212,50);
		setElementInterior(pickup,getElementInterior(source));
		setElementDimension(pickup,getElementDimension(source));
		setElementData(pickup,"BurgershotID",getElementData(source,"BurgershotID"));
		if(math.random(1,3) == 2)then
			setElementData(killer,"Wanteds",getElementData(client,"Wanteds")+1);
			if(getElementData(killer,"Wanteds") > 12)then
				setElementData(killer,"Wanteds",12);
			end
			infobox(killer,"Die Kameras haben dich bei der Tat gefilmt!",120,0,0);
		end
		
		addEventHandler("onPickupHit",pickup,function(player)
			if(not(isPedInVehicle(player)))then
				if(getElementDimension(player) == getElementDimension(source))then
					local money = math.random(500,750);
					destroyElement(Burgershot.peds[getElementData(source,"BurgershotID")]);
					setTimer(function(id)
						Burgershot.createPed(id);
					end,720000,1,getElementData(source,"BurgershotID"))
					destroyElement(source);
					setElementData(player,"Geld",getElementData(player,"Geld")+money);
					infobox(player,"Du konntest "..money.."€ erbeuten.",0,120,0);
				end
			end
		end)
	end)
	
	addEventHandler("onElementClicked",Burgershot.peds[id],function(button,state,player)
		if(button == "left" and state == "down")then
			local x,y,z = getElementPosition(source);
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 5)then
				triggerClientEvent(player,"Burgershot.openWindow",player);
			end
		end
	end)
end
for i = 0,9 do Burgershot.createPed(i)end

-- [[ BURGER BAUEN ]] --

addEvent("Burgershot.buy",true)
addEventHandler("Burgershot.buy",root,function(type)
	if(not(isTimer(Burgershot.timer[client])))then
		local preis = Burgershot["Preise"][type][1];
		if(getElementData(client,"Geld") >= preis)then
			local health = getElementHealth(client);
			if(health < 100)then
				setElementData(client,"Geld",getElementData(client,"Geld")-preis);
				setElementHealth(client,health+Burgershot["Preise"][type][2]);
				setPedAnimation(client,"FOOD","EAT_Burger",-1,true,false,false,true);
				Burgershot.timer[client] = setTimer(function(client)
					setPedAnimation(client);
				end,5000,1,client)
				infobox(client,"Du hast ein "..Burgershot["Preise"][type][3].." bestellt.",0,120,0);
			else infobox(client,"Du hast bereits volles Leben!",120,0,0)end
		else infobox(client,"Du hast nicht genug Geld dabei!",120,0,0)end
	else infobox(client,"Warte, bis du aufgegessen hast!",120,0,0)end
end)