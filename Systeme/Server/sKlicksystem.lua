--

-- [[ TABLES ]] --

WasserspenderTimer = {};

-- [[ KLICKSYSTEM ]] --

addEventHandler("onPlayerClick",root,function(button,state,clickedElement)
	if(state == "down" and button == "left" and clickedElement)then
		if(getElementData(source,"elementClicked") == false)then
			local x,y,z = getElementPosition(source);
			local ox,oy,oz = getElementPosition(clickedElement);
			if x and ox and (getDistanceBetweenPoints3D(ox,oy,oz,x,y,z) <= 3.5)then
				--// SPIELERINTERAKTION
				if(getElementType(clickedElement) == "player")then
					if(getElementData(source,"AmKlauen") == true)then
						Klauen.start(source,clickedElement);
					end
				--// FAHRZEUGINTERAKTION
				elseif(getElementType(clickedElement) == "vehicle")then
					if(getElementData(clickedElement,"Besitzer"))then
						if(isVehicleLocked(clickedElement))then lockstate = "Aufschließen" else lockstate = "Abschließen" end
						if(getElementData(clickedElement,"Handbremse") == 0) then breakstate = "Handbremse anziehen" else breakstate = "Handbremse lösen" end
						setElementData(source,"clickedElement",clickedElement);
						triggerClientEvent(source,"openVehicleWindow",source,lockstate,breakstate);
						infobox(source,"Besitzer: "..getElementData(clickedElement,"Besitzer").." (Slot: "..getElementData(clickedElement,"Slot")..")",0,120,0);
					end
				else
					local model = getElementModel(clickedElement);
					--// GETRÄNKEAUTOMAT
					if(model == 955)then
						if(getElementData(source,"Geld") >= 150)then
							setElementData(source,"Geld",getElementData(source,"Geld")-150);
							local item = itemmanager:add(47,source:getId(),source:getId(),source:getId(),1,0,0,100,0,"none",source.m_Storages[1]);
							source.m_Storages[1]:addItem(item);
							infobox(source,"Du hast dir einen Energy-Drink gekauft.",0,120,0);
						else infobox(source,"Du hast nicht genug Geld dabei!",120,0,0)end
					--// WASSERSPENDER
					elseif(model == 1808)then
						if(not(isTimer(WasserspenderTimer[source])))then
							if(getElementHealth(source) < 100)then
								local money = (100-getElementHealth(source))*3;
								if(getElementData(source,"Geld") >= money)then
									setElementFrozen(source,true);
									setPedAnimation(source,"vending","vend_drink2_p",-1);
									WasserspenderTimer[source] = setTimer(function(source,money)
										if(isElement(source))then
											setElementFrozen(source,false);
											setPedAnimation(source);
											setElementHealth(source,100);
											setElementData(source,"Geld",getElementData(source,"Geld")-money);
										end
									end,5000,1,source,money)
								else infobox(source,"Du benötigst mindestens "..money.."€ auf der Hand!",120,0,0)end
							else infobox(source,"Du hast bereits volles Leben!",120,0,0)end
						end
					--// WAFFENBOX
					elseif(model == 3578)then
						if getElementData(clickedElement, "ReporterBarricade") then
							if getElementData(source,"Fraktion") == 4 or getElementData(source,"Adminlevel") >= 1 then
								destroyElement(clickedElement)
							end
						end
					end
				end
			end
		end
	end
end)