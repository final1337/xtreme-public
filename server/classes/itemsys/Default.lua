function kek()
	for key, value in ipairs(getElementsByType("player")) do
		spawnKek(value)
	end
end

addEventHandler("onPlayerJoin", root,
	function ()
		spawnKek(source)
	end
)

function spawnKek(player)
	spawnPlayer(player, 0, 20, 3)
	setCameraTarget(player,player)
	fadeCamera(player,true)	
end