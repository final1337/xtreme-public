AlertMessage = inherit(Singleton)

AlertMessage.MESSAGE_DURATION = 1000*25

addEvent("XTM:AlertMessage", true)

function AlertMessage:constructor()
	self.m_Message = ""
	self.m_Progress = 0
	self.m_KillTimer = false
	self.m_RenderHandler = bind(self.draw, self)
	
	addEventHandler("onClientRender", root, self.m_RenderHandler)
	addEventHandler("XTM:AlertMessage", root, bind(self.message, self))
end

function AlertMessage:message(msg, noSound)
	self.m_Message = msg
	self.m_Progress = 0.000001
	self.m_KillTimer = Timer( function () end, AlertMessage.MESSAGE_DURATION, 1)
	if not noSound then
		setTimer(playSoundFrontEnd, 350, 25, 101)
	end
	setWindowFlashing(true)
end

function AlertMessage:draw()
	if self.m_Progress > 0 then
		if isTimer(self.m_KillTimer) then
			self.m_Progress = math.min( 1, self.m_Progress + 0.02)
		else
			self.m_Progress = math.max( 0, self.m_Progress - 0.02)
		end
		local r,g,b = unpack(XTREAM_ORANGE)
		dxDrawRectangle(screenWidth - screenWidth*0.15*self.m_Progress - 1, screenHeight*0.5 - 1, screenWidth*0.15 + 2, screenHeight*0.1 + 2, tocolor(r,g,b))
		dxDrawRectangle(screenWidth - screenWidth*0.15*self.m_Progress, screenHeight*0.5, screenWidth*0.15, screenHeight*0.1, tocolor(25,25,25))
		dxDrawText(self.m_Message, screenWidth - screenWidth*0.15*self.m_Progress + 5, screenHeight*0.5,  ( screenWidth - screenWidth*0.15*self.m_Progress ) + screenWidth*0.15, screenHeight*0.6, tocolor(255,255,255), 1.2, "default-bold", "left",
		"center", true, true, true, true, true, 0, 0, 0)
	elseif not isTimer(self.m_KillTimer) and self.m_Progress == 0 then
		-- Todo
	end
end

AlertMessage:new()