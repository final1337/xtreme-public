

Bombe = {plant = {}, wirdDefused = false, lastPlaced = 0};

Bombe.Cooldown = 0

function Bombe.place(player)
	if(getElementInterior(player) == 0 and getElementDimension(player) == 0)then
		local x,y,z = getElementPosition(player);
		setElementFrozen(player,true);
		setPedAnimation(player,"BOMBER","BOM_Plant_Loop");
		Bombe.plant[player] = setTimer(function(player)
			if(isElement(player))then
				if(not(isElement(Bombe.object)))then
					Bombe.object = createObject(1654,x-0.5,y,z-0.85,-90,0,0);
					Bombe.zone = createRadarArea(x-75,y-75,150,150,150,0,0,175,root);
					setRadarAreaFlashing(Bombe.zone,true);
					setElementCollisionsEnabled(Bombe.object,false);
					Bombe.legerFraktion = getElementData(player,"Fraktion");
					setPedAnimation(player);
					Bombe.wirdDefused = false
					Bombe.defuser = false
					setElementFrozen(player,false);
					outputChatBox("[#ff0000BOMBE#ffffff] Bombenwarnung!",root,255,255,255,true);
					Bombe.explodeTimer = setTimer(function()
						Bombe.createExplosion();
					end,600000*2,1)
				else infobox(player,"Es liegt bereits eine Bombe!",120,0,0)end
			end
		end,7500,1,player)
	else infobox(player,"Hier kannst du keine Bombe legen!",120,0,0)end
end
addEvent("Bombe.place",true)
addEventHandler("Bombe.place",root,Bombe.place)

function Bombe.createExplosion()
	local x,y,z = getElementPosition(Bombe.object);
	createExplosion(x,y,z+1,10);
	for i = -3, 3, 1 do
		for j = -3, 3, 1 do
			createExplosion(x + (i*3),y +(j*3),z+1,10);
		end
	end
	if(isElement(Bombe.object))then destroyElement(Bombe.object)end
	if(isElement(Bombe.zone))then destroyElement(Bombe.zone)end
	if Bombe.defuser and getPlayerFromName(Bombe.defuser) then
		local defuser = getPlayerFromName(Bombe.defuser)
		Bombe.defuser = false
		triggerClientEvent(source,"Bombe.destroyDefuseWindow",source);
	end
	outputChatBox("[#ff0000BOMBE#ffffff] Die Bombe ist explodiert!",root,255,255,255,true);
	--dbExec(handler,"UPDATE fraktionskasse SET Betrag = Betrag + 20000 WHERE Fraktion = '"..Bombe.legerFraktion.."'");
end
addEvent("Bombe.createExplosion",true)
addEventHandler("Bombe.createExplosion",root,Bombe.createExplosion)

addCommandHandler("delbomb",function(player)
	if(isCop(player) or isFBI(player) or isArmy(player))then
		if(isElement(Bombe.object))then
			local x,y,z = getElementPosition(Bombe.object);
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 5)then
				if(Bombe.defuser == false)then
					Bombe.defuser = getPlayerName(player);
					setElementFrozen(player,true);
					setPedAnimation(player,"BOMBER","BOM_Plant_Loop");
					triggerClientEvent(player,"Bombe.defuseWindow",player);
				else infobox(player,"Die Bombe wird bereits entschärft!",255,0,0)end
			end
		end
	end
end)

addEventHandler("onPlayerWasted", root,
	function ()
		if Bombe.defuser == source:getName() then
			triggerClientEvent(source,"Bombe.destroyDefuseWindow",source);
			Bombe.defuser = false
		end
	end
)

addEvent("Bombe.defused",true)
addEventHandler("Bombe.defused",root,function()
	outputChatBox("[#00ff00BOMBE#ffffff] Die Bombe wurde entschärft!",root,255,255,255,true);
	--dbExec(handler,"UPDATE fraktionskasse SET Betrag = Betrag + 20000 WHERE Fraktion = '"..getElementData(getPlayerFromName(Bombe.defuser), "Fraktion").."'");
	if(isTimer(Bombe.explodeTimer))then killTimer(Bombe.explodeTimer)end
	if(isElement(Bombe.object))then destroyElement(Bombe.object)end
	if(isElement(Bombe.zone))then destroyElement(Bombe.zone)end
	setElementFrozen(client, false)
	setPedAnimation(client)
end)

function Bombe.destroyStuff(player)
	if(isTimer(Bombe.place[player]))then killTimer(Bombe.place[player])end
	if(getPlayerName(player) == Bombe.defuser)then
		triggerClientEvent(player,"Bombe.destroyDefuseWindow",player);
	end
end