--

Klauen = {refreshTimer = {}};

addCommandHandler("klauen",function(player)
	if(getElementData(player,"elementClicked") ~= true)then
		if(getElementData(player,"AmKlauen") ~= true)then
			infobox(player,"Klicke nun den Spieler an, den du ausrauben möchtest. Tippe /klauen zum Abbrechen.",0,120,0);
			setElementData(player,"AmKlauen",true);
			showCursor(player,true);
		else
			setElementData(player,"AmKlauen",false);
			showCursor(player,false);
			infobox(player,"Klauen abgebrochen!",120,0,0);
		end
	end
end)

function Klauen.start(player,target)
	if(getElementData(target,"WurdeBeklaut") ~= true)then
		infobox(player,"Der Spieler wird beklaut...",0,120,0);
		infobox(target,"Du wirst beklaut, renne weg, um den Diebstahl zu verhindern.",120,0,0);
		setElementData(target,"WurdeBeklaut",true);
		Klauen.refreshTimer[target] = setTimer(function(target)
			if(isElement(target))then
				setElementData(target,"WurdeBeklaut",false);
			end
		end,7200000,1,target)
		setTimer(function(player,target)
			if(isElement(player) and isElement(target))then
				local x,y,z = getElementPosition(target);
				if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player)) <= 5)then
					local money = getElementData(target,"Geld");
					if(money > 0)then
						if(money > 1000)then money = 1000 end
						setElementData(target,"Geld",getElementData(target,"Geld")-money);
						setElementData(player,"Geld",getElementData(player,"Geld")+money);
						infobox(player,"Du konntest "..money.."€ erbeuten.",0,120,0);
					else infobox(player,"Der Spieler hat kein Geld dabei!",120,0,0)end
				else infobox(player,"Der Spieler ist entkommen!",120,0,0)end
			end
		end,6000,1,player,target)
		setElementData(player,"AmKlauen",false);
		showCursor(player,false);
	else infobox(player,"Der Spieler wurde vor kurzem bereits bestohlen!",120,0,0)end
end