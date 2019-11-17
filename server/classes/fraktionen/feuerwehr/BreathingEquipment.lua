BreathingEquipment = inherit(Singleton)

function BreathingEquipment:constructor()
	
end

function BreathingEquipment:equip(player)
	if not getPedOccupiedVehicle(player) and player:getData("isAbleToWearBreathing") and not player:getData("isWearingBreathing") then
		player:sendMessage("Du trägst nun eine Atemmaske!")
		player:setData("isWearingBreathing", true)
		player:setAnimation("goggles", "goggles_put_on")
		Timer(setPedAnimation, 833, 1, player, false)
	elseif player:getData("isWearingBreathing") then
		player:sendMessage("Du trägst nun keine Atemmaske mehr!")
		player:setData("isWearingBreathing", false)
		player:setAnimation("goggles", "goggles_put_on")
		Timer(setPedAnimation, 833, 1, player, false)		
	end
end

function BreathingEquipment:destructor()

end