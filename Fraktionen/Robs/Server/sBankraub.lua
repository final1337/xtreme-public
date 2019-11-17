Bankraub = {};

Bankraub.inDenTresor = createMarker(345.63119506836,156.39869689941,1013.0465087891,"cylinder",2,0,0,255);
Bankraub.ausDemTresor = createMarker(350.54849243164,130,993.27978515625,"cylinder",2,0,0,255);
Bankraub.robMarker = createMarker(346.98968505859,161.2993927002,980.96221923828,"cylinder",16,0,0,0,0);
setElementInterior(Bankraub.inDenTresor,3);
setElementInterior(Bankraub.ausDemTresor,3);
setElementInterior(Bankraub.robMarker,3);

addEventHandler("onMarkerHit",Bankraub.inDenTresor,function(player)
	setElementPosition(player,350.59420776367,127.4753036499,994.30377197266);
	setPedRotation(player,180);
end)

addEventHandler("onMarkerHit",Bankraub.ausDemTresor,function(player)
	setElementPosition(player,345.56170654297,154.29069519043,1014.1875);
	setPedRotation(player,180);
end)

function Bankraub.createPed()
	if(isElement(Bankraub.robPed))then destroyElement(Bankraub.robPed)end
	Bankraub.robPed = createPed(224,359.62881469727,173.55909729004,1008.3828125,270);
	setElementInterior(Bankraub.robPed,3);
	
	addEventHandler("onPedWasted",Bankraub.robPed,function(ammo,killer,weapon,bodypart)
		if(isRifa(killer) or isDNB(killer) or isMafia(killer) or isNordic(killer) or isTerrorist(killer) or isBallas(killer))then
			local keycard = createObject(1581,361.00930786133,172.99099731445,1008.412109375,0,0,126);
			setElementInterior(keycard,3);
			
			addEventHandler("onElementClicked",keycard,function(button,state,player)
				if(button == "left" and state == "down")then
					local x,y,z = getElementPosition(source);
					if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)))then
						if(isRifa(player) or isDNB(player) or isMafia(player) or isNordic(player) or isTerrorist(player) or isBallas(player))then
							destroyElement(source);
							setElementData(player,"HasBankraubKeycard",true);
							infobox(player,"Du hast die Keycard aufgehoben, mache nun die Tür auf!",0,120,0);
							
							setTimer(function()
								Bankraub.createPed();
								Bankraub.createDoor();
							end,4000000,1)
						end
					end
				end
			end)
		else Bankraub.createPed() end
	end)
end
Bankraub.createPed();

function Bankraub.createDoor()
	if(isElement(Bankraub.door))then destroyElement(Bankraub.door)end
	Bankraub.door = createObject(2634,372.01190185547,166.48890686035,1008.8386230469,0,0,0);
	setElementInterior(Bankraub.door,3);
	
	addEventHandler("onElementClicked",Bankraub.door,function(button,state,player)
		if(button == "left" and state == "down")then
			local x,y,z = getElementPosition(source);
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)))then
				if(getElementData(player,"HasBankraubKeycard") == true)then
					if(isRifa(player) or isDNB(player) or isMafia(player) or isNordic(player) or isTerrorist(player) or isBallas(player))then
						local x,y,z = getElementPosition(Bankraub.door);
						setElementData(player,"HasBankraubKeycard",false);
						outputChatBox("[#ff0000ROB#ffffff] Die Bank wird ausgeraubt!",root,255,255,255,true);
						moveObject(Bankraub.door,4000,x,y,z-15);
						
						Bankraub.robTimer = setTimer(function()
							for _,v in pairs(getElementsByType("player"))do
								if(isElementWithinMarker(v,Bankraub.robMarker))then
									if(getElementDimension(v) == getElementDimension(Bankraub.robMarker))then
										if(isRifa(v) or isDNB(v) or isMafia(v) or isNordic(v) or isTerrorist(v) or isBallas(v))then
											setElementData(v,"Geld",getElementData(v,"Geld")+math.random(50,100));
										end
									end
								end
							end
						end,5000,120)
					end
				end
			end
		end
	end)
end
Bankraub.createDoor();

addEventHandler("onPlayerWasted",root,function()
	setElementData(source,"HasBankraubKeycard",false);
end)