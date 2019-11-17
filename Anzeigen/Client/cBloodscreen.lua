

--[[
local bloodAlpha = 0

function showBloodFlash()
	bloodAlpha = 255
end
addEvent("showBloodFlash",true)
addEventHandler("showBloodFlash",root,showBloodFlash)

addEventHandler("onClientRender", root,
	function ()
		if bloodAlpha > 0 then
			dxDrawImage(0, 0, screenWidth, screenHeight, "Files/Images/Bloodscreen.png", 0, 0, 0, tocolor(255,255,255,bloodAlpha))
			bloodAlpha = math.max(0, 255)
		end
	end
)

addEventHandler("onClientPlayerDamage",root,function(attacker,weapon,bodypart,loss)
	if(source == localPlayer)then
		showBloodFlash();
	end
end) --]]