--[[

	Xtreme Reallife
	2019

]]--

-- [[ VARIABLEN ]] --

local PosX,PosY,PosZ = getElementPosition(localPlayer);
local Shape = createColSphere(PosX,PosY,PosZ,25);
local Font = dxCreateFont("Files/Fonts/Nametag.ttf",25);

-- [[ NAMETAG ]] --

addEventHandler("onClientRender",root,function()
	local sx,sy = x/2,y/2;
	local nx,ny,nz = getWorldFromScreenPosition(sx,sy,10);
	if(getCameraTarget() and getElementType(getCameraTarget()) == "player")then tg = getCameraTarget() else tg = localPlayer end
	setPedLookAt(tg,nx,ny,nz,3000);
	local NewPosX,NewPosY,NewPosZ = getElementPosition(tg);
	setElementPosition(Shape,NewPosX,NewPosY,NewPosZ);

	if getPedTarget ( localPlayer ) then
		local target = getPedTarget(localPlayer)
		if getPedWeapon ( localPlayer ) == 34 then
			if getElementType( target ) == "player" then
			local x, y, z = getElementPosition( localPlayer )
			local x1, y1, z1 = getElementPosition( target )
				if getDistanceBetweenPoints3D ( x, y, z, x1, y1, z1 ) > 20 then
					x, y, z = getElementPosition( target )
					local X, Y = getScreenFromWorldPosition( x, y, z+1 )
					local tag = ""
					local frak = getElementData(localPlayer,"Fraktion")
					if (frak == 1) or (frak == 2) or (frak == 3) then
						tag = ("(%s)"):format(getElementData(target,"Wanteds"))
					end
					dxDrawText( target:getName()..tag,  X, Y , X, Y, tocolor( 150, 150, 150, 255 ), 1.02, "default-bold", "center", "center") 
				end
			end	
		end
	end

	for i,v in ipairs(getElementsWithinColShape(Shape,"player"))do
		setPlayerNametagShowing(v,false);
		local vx,vy,vz = getPedBonePosition(v,8);
		local vx1,vy1,vz1 = getElementPosition(tg);
		local vanish = getElementData(v, "vanish") or false;
		if(vanish ~= 2 and getElementDimension(v) == getElementDimension(tg) and getElementInterior(v) == getElementInterior(tg) and isElementOnScreen(v) and isLineOfSightClear(vx1,vy1,vz1,vx,vy,vz,true,false,false,true,false,false,false) and v ~= tg)then
			local wx,wy = getScreenFromWorldPosition(vx,vy,vz);
			if(wx)then
				local health = getElementHealth(v);
				if(health < 50)then red = 200; green = (health/50)*((health/100)*200*2); else green = 200; red = 200-((health-50)/50)*200 end
				local colour = tocolor(red,green,0,200);
				if(health == 0)then colour = tocolor(0,0,0,200) elseif(health >= 95)then red = 200-((100-50)/50)*200; green = 200; color = tocolor(red,green,0,255)end

				if(health > 0.5)then
					dxDrawRectangle(wx-40,wy-75,80,12,tocolor(0,0,0,150));
					dxDrawRectangle(wx-38,wy-73,health/100*76,4,colour);
					if(getPedArmor(v) > 0)then dxDrawRectangle(wx-38,wy-73+4,getPedArmor(v)/100*76,4,tocolor(120,120,120,255))end
					dxDrawRectangle(wx-38,wy-73+3,76,2,tocolor(0,0,0,150));
				end

				local c1,c2,c3 = 255,120,0;
				if(getElementData(v,"Wanteds") > 0)then
					dxDrawImage(wx-15,wy-115,30,30,"Files/Images/Nametag/Wanted"..getElementData(v,"Wanteds")..".png");
				elseif(getElementData(v,"ZivischutzAktiv") == true)then
					dxDrawImage(wx-15,wy-115,30,30,"FIles/Images/Nametag/Zivischutz.png");
				end
				if(getElementData(v,"Adminlevel") >= 1 and vanish ~= 1)then
					dxDrawText("[Xtm]"..getPlayerName(v),wx-35,wy-135,wx+30,wy+50,tocolor(0,0,0,255),1.02,1.02,Font,"center","center",false,false,false,true,true);
					dxDrawText("#ff7800[#323232Xtm#ff7800]"..getPlayerName(v),wx-35,wy-135,wx+30,wy+50,tocolor(c1,c2,c3,255),1,Font,"center","center",false,false,false,true,true);
				else
					dxDrawText(getPlayerName(v),wx-35,wy-135,wx+30,wy+50,tocolor(0,0,0,255),1.02,1.02,Font,"center","center",false,false,false,true,true);
					dxDrawText(getPlayerName(v),wx-35,wy-135,wx+30,wy+50,tocolor(c1,c2,c3,255),1,Font,"center","center",false,false,false,true,true);
				end
			end
		end
	end
end)