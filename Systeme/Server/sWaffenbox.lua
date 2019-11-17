--

Waffenbox = {};

function Waffenbox.loadDatas(player,state)
	local tbl = {};
	for i = 1,3 do
		table.insert(tbl,{getPlayerData("waffenbox","Username",getPlayerName(player),"Slot"..i.."Gun"),getPlayerData("waffenbox","Username",getPlayerName(player),"Slot"..i.."Ammo")});
	end
	triggerClientEvent(player,"Waffenbox.createWindow",player,tbl,state);
end

addEvent("Waffenbox.server",true)
addEventHandler("Waffenbox.server",root,function(slot,ammo)
	local waffe,munition = getPedWeapon(client),getPedTotalAmmo(client);
	local gun = getPlayerData("waffenbox","Username",getPlayerName(client),"Slot"..slot.."Gun");
	if(gun == 1337)then
		if(waffe >= 1)then
			if(#ammo == 0 or ammo == "")then
				dbExec(handler,"UPDATE waffenbox SET Slot"..slot.."Gun = '"..waffe.."', Slot"..slot.."Ammo = '"..munition.."' WHERE Username = '"..getPlayerName(client).."'");
				takeWeapon(client,waffe);
			else
				local ammo = tonumber(ammo);
				if(munition >= ammo)then
					takeWeapon(client,waffe);
					dbExec(handler,"UPDATE waffenbox SET Slot"..slot.."Gun = '"..waffe.."', Slot"..slot.."Ammo = '"..ammo.."' WHERE Username = '"..getPlayerName(client).."'");
					if(munition-ammo >= 1)then
						giveWeapon(client,waffe,munition-ammo,true);
					end
				end
			end
		else infobox(client,"Du hast keine Waffe in der Hand!",120,0,0)end
	else
		if(#ammo == 0 or ammo == "")then
			giveWeapon(client,gun,getPlayerData("waffenbox","Username",getPlayerName(client),"Slot"..slot.."Ammo"),true);
			dbExec(handler,"UPDATE waffenbox SET Slot"..slot.."Gun = '1337', Slot"..slot.."Ammo = '0' WHERE Username = '"..getPlayerName(client).."'");
		else
			local ammo = tonumber(ammo);
			local munition = getPlayerData("waffenbox","Username",getPlayerName(client),"Slot"..slot.."Ammo");
			if(munition >= ammo)then
				giveWeapon(client,gun,ammo,true);
				dbExec(handler,"UPDATE waffenbox SET Slot"..slot.."Ammo = '"..munition-ammo.."' WHERE Username = '"..getPlayerName(client).."'");
				if(munition-ammo == 0)then
					dbExec(handler,"UPDATE waffenbox SET Slot"..slot.."Gun = '1337', Slot"..slot.."Ammo = '0' WHERE Username = '"..getPlayerName(client).."'");
				end
			else infobox(client,"So viel Munition hast du nicht in der Waffenbox!",120,0,0)end
		end
	end
	Waffenbox.loadDatas(client,true);
end)