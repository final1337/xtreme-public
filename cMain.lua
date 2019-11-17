

GUIEditor = {window = {}, staticimage = {}, gridlist = {}, label = {}, tab = {}, tabpanel = {}, button = {}, edit = {}, memo = {}};

bindKey("b","down",function()
	showCursor(not(isCursorShowing()));
end)

function convertMS(ms)
	local seconds = math.ceil(ms/1000);
	local minutes = math.floor(seconds/60);
	local seconds = seconds % 60;
	if(minutes < 10)then minutes = "0"..minutes end
	if(seconds < 10)then seconds = "0"..seconds end
	return minutes..":"..seconds;
end

function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    return guiSetPosition(center_window, x, y, false)
end

function isCursorOnElement( posX, posY, width, height )
	if isCursorShowing( ) then
		local mouseX, mouseY = getCursorPosition( )
		local clientW, clientH = guiGetScreenSize( )
		local mouseX, mouseY = mouseX * clientW, mouseY * clientH
		if ( mouseX > posX and mouseX < ( posX + width ) and mouseY > posY and mouseY < ( posY + height ) ) then
			return true
		end
	end
	return false
end

-- [[ SONDERZEICHEN/BUCHSTABEN CHECK ]] --

local OnlyNumbersTable = {"a","b","c","d","e","f","g","h","i","j","k","l","m","o","p","y","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","O","P","Q","R","S","T","U","V","W","X","Y","Z","ä","ü","ö","Ä","Ü","Ö"," ",",","#","'","+","*","~",":",";","=","}","?","\\","{","&","/","§","\"","!","°","@","|","`","´","-","+"};

function isOnlyNumbers(text)
	local counter = 0;
	for k,v in ipairs(OnlyNumbersTable)do
		if(string.find(text,v))then
			counter = counter + 1;
			break
		end
	end
	if(counter > 0)then
		infobox("Es sind nur Zahlen gestattet!",120,0,0);
		return false
	else
		return true;
	end
end

local loadingScreenAlpha = 0;

addEvent("loadingScreen",true)
addEventHandler("loadingScreen",root,function()
	loadingScreenAlpha = 255;
end)

function loadingScreenDxDraw()
	if(loadingScreenAlpha > 0) then loadingScreenAlpha = math.max(0, loadingScreenAlpha - 1.5) end

    dxDrawImage(x/2 - (446*(x/1920))/2, y/2 - (136*(y/1080))/2, 446*(x/1920), 136*(y/1080), "Files/Images/logo.png", 0, 0, 0, tocolor(255, 255, 255, loadingScreenAlpha), false)
    dxDrawText("Wird geladen..", x/2, y/2 + y/6 , 963*(x/1920), y/2 + y/6 , tocolor(255, 255, 255, loadingScreenAlpha), 1.50*(y/1080), "default-bold", "center", "bottom", false, false, false, false, false)
end
addEventHandler("onClientRender",root,loadingScreenDxDraw);