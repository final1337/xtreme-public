FireVehicleHelicopter = inherit(Singleton)

addEvent("XTM:FF:RaindanceCheck", true)

function FireVehicleHelicopter:constructor()

	addEventHandler("XTM:FF:RaindanceCheck", root, bind(self.checkGroundLevel, self))
end

function FireVehicleHelicopter:checkGroundLevel()
	local z = getGroundPosition(localPlayer:getPosition())
	local x,y = getElementPosition(localPlayer)

	if z ~= 0 then
		triggerServerEvent("XTM:FF:RaindanceCheckSuccess", getPedOccupiedVehicle(localPlayer), x,y,z)
	end
end
