function dxDrawBorderedTextExt (outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    for oX = (outline * -1), outline do
        for oY = (outline * -1), outline do
            dxDrawText (text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end
    dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end



Infobox = {}
Infobox.boxes = {}

local x, y = guiGetScreenSize()

Infobox.START_POSX = 25*(x/1920)
Infobox.START_POSY = 725*(y/1080)
Infobox.OFFSET_PER_ENTRY = 50
Infobox.HEIGHT = 32

Infobox.DEFAULT_EXPIRE_TIME = 6500
Infobox.FADE_OFFSET_BACK = 1500 -- ms
Infobox.FADE_OFFSET_IN  = 1000 -- ms

function Infobox.new(text, r, g, b, expire)
	table.insert(Infobox.boxes,
		{
			Text = text,
			Time = getTickCount(),
			Expire = expire or Infobox.DEFAULT_EXPIRE_TIME,
			ExpireTime = getTickCount() + (expire or Infobox.DEFAULT_EXPIRE_TIME),
			Red = r,
			Green = g,
			Blue = b,
			CurrentOffset = Infobox.OFFSET_PER_ENTRY*(#Infobox.boxes),
			CurrentFade = 1
		}

	)

	if ( r == 120 and g == 0 and b == 0 ) then
		playSoundFrontEnd(13) 
	else 
		playSoundFrontEnd(11)
	end
end
addEvent("notification",true)
addEventHandler("notification",root,Infobox.new)

function Infobox.render()
	for key, value in ipairs(Infobox.boxes) do


		local totalWidth = dxGetTextWidth(value.Text, 1, "default-bold") + 70

		if getTickCount() >= value.ExpireTime - Infobox.FADE_OFFSET_BACK then
			local easingValue = (getTickCount() - (value.ExpireTime - Infobox.FADE_OFFSET_BACK)) / Infobox.FADE_OFFSET_BACK

			easingValue = getEasingValue(easingValue, "InBack")

			
			dxDrawRectangle( Infobox.START_POSX, Infobox.START_POSY - value.CurrentOffset, totalWidth - (totalWidth * easingValue), Infobox.HEIGHT, tocolor (0, 0, 0, 200))
			dxDrawImage(Infobox.START_POSX, Infobox.START_POSY - value.CurrentOffset, math.min( Infobox.HEIGHT, totalWidth - (totalWidth * easingValue)), Infobox.HEIGHT, "Files/Images/XtremeLogo.png")
			
			dxDrawText ( value.Text,
						Infobox.START_POSX + Infobox.HEIGHT + 10,
						Infobox.START_POSY - value.CurrentOffset,
						Infobox.START_POSX + totalWidth - (totalWidth * easingValue) ,
						Infobox.START_POSY - value.CurrentOffset + Infobox.HEIGHT,
						tocolor(value.Red, value.Green, value.Blue),
						1,
						"default-bold",
						"left",
						"center",
						true)				
		else
			local easingValue = math.min(1, (getTickCount() - (value.Time)) / Infobox.FADE_OFFSET_IN)

			easingValue = getEasingValue(easingValue, "OutBack")

			
			dxDrawRectangle( Infobox.START_POSX, Infobox.START_POSY - value.CurrentOffset, easingValue * totalWidth, Infobox.HEIGHT, tocolor (0, 0, 0, 200))
			dxDrawImage(Infobox.START_POSX, Infobox.START_POSY - value.CurrentOffset, math.min ( Infobox.HEIGHT, easingValue * totalWidth ), Infobox.HEIGHT, "Files/Images/XtremeLogo.png")


			dxDrawText ( value.Text,
						Infobox.START_POSX + Infobox.HEIGHT + 10,
						Infobox.START_POSY - value.CurrentOffset,
						Infobox.START_POSX + easingValue * totalWidth,
						Infobox.START_POSY - value.CurrentOffset + Infobox.HEIGHT,
						tocolor(value.Red, value.Green, value.Blue),
						1,
						"default-bold",
						"left",
						"center",
						true)		
		end
		



		local shouldOffset = Infobox.OFFSET_PER_ENTRY*(key-1)

		if value.CurrentOffset > shouldOffset then
			value.CurrentOffset = math.max ( shouldOffset, value.CurrentOffset - 10 )
		end

		if getTickCount() >= value.ExpireTime then
			table.remove(Infobox.boxes, key)
		end
	end
end
addEventHandler("onClientRender", root, Infobox.render)
