FireFighterDisplay = inherit(Singleton)

function FireFighterDisplay:constructor()
	self.m_CurrentProgress = 0
	self.m_OverviewActive = false

	addEventHandler("onClientRender", root, bind(self.draw, self))
end

function FireFighterDisplay:draw()
	-- Draw the waterlevel
	if getPedOccupiedVehicle(localPlayer) and getElementData(getPedOccupiedVehicle(localPlayer), "Firefighter") and getVehicleOccupant(getPedOccupiedVehicle(localPlayer), 0) == localPlayer then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if getElementData(vehicle,"Tank") then
			dxDrawRectangle(screenWidth/2 - screenWidth/16 - 2, 0, screenWidth/8 + 4, screenHeight/32 + 2, tocolor(0,0,0))
			dxDrawRectangle(screenWidth/2 - screenWidth/16, 0, screenWidth/8*getElementData(vehicle,"Tank")/getElementData(vehicle,"TankMaximum"), screenHeight/32, tocolor(0,0,125))
			dxDrawText(getElementData(vehicle,"Tank").."l", screenWidth/2 - screenWidth/16, 0, screenWidth/2 - screenWidth/16 + screenWidth/8 , screenHeight/32,
						tocolor(255,255,255), 1.2, "default-bold", "center", "center")
		end
	end
	-- Draw mission success
end