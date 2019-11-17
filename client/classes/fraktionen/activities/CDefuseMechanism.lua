DefuseMechanism = inherit(Singleton)

addEvent("Defuse:startDefuse", true)
addEvent("Defuse:stopDefuse", true)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

DefuseMechanism.MAX_ROWS = 9

DefuseMechanism.PositionX = screenWidth/2 - (64*DefuseMechanism.MAX_ROWS/2)
DefuseMechanism.PositionY = screenHeight/2 - (64*5/2)

function DefuseMechanism:constructor()
	self.m_Active = false
	self.m_RenderTargets = {}
	self.m_CurrentField = 1
	
	self.PositionX = DefuseMechanism.PositionX
	self.PositionY = DefuseMechanism.PositionY
	self.MAX_ROWS  = DefuseMechanism.MAX_ROWS
	
	self.m_Password = {}
	self.m_PasswordString = ""
	self.m_Fields = {}
	self.m_Offset = {}
	
	addEventHandler("Defuse:startDefuse", root, bind(self.M_startDefuse, self))
	addEventHandler("Defuse:stopDefuse", root, bind(self.M_stopDefuse, self))
	bindKey("space", "down", bind(self.registerField, self))
	addEventHandler("onClientRender", root, bind(self.draw, self))
	addEventHandler("onClientClick", root, bind(self.onClick, self))	
end

function DefuseMechanism:M_startDefuse(maxRows)
	self:setMaxRows(maxRows)
	toggleAllControls(false, true, false)
	self:start()
end

function DefuseMechanism:M_stopDefuse()
	toggleAllControls(true, true, false)
	self.m_Active = false
end

function DefuseMechanism:setMaxRows(maxrows)
	self.MAX_ROWS = maxrows
	self.PositionX = screenWidth/2 - (64*self.MAX_ROWS/2)
end

function DefuseMechanism:start()
	self.m_Active = true
	self.m_Fields = {}
	self.m_Password = {}
	self.m_Fails = 0
	self.m_PasswordString = ""
	self.m_CurrentField = 1
	
	for field = 1, self.MAX_ROWS, 1 do
		self.m_Fields[field] = {}
		self.m_Offset[field] = {amount = 0, typ = "up", speed = 1, status = "continue"}
		self.m_RenderTargets[field] = dxCreateRenderTarget(64, 1920, true)
		dxSetRenderTarget(self.m_RenderTargets[field], true)
		for i = 1, 30, 1 do
			table.insert(self.m_Fields[field], math.round(math.random(0,900000) / 100000))
			dxDrawText(self.m_Fields[field][i], 0, (i-1)*64, 64, (i-1)*64+64, tocolor(255,255,255), 3.5, "diploma", "center", "center", true, false)
		end
	end
	dxSetRenderTarget()
	
	local count = 1
	
	for i = 1, self.MAX_ROWS, 1 do
		self.m_Password[i] = self.m_Fields[i][math.random(1,30)]
		self.m_PasswordString = self.m_PasswordString .. self.m_Password[i]
	end
	
	setTimer ( function () 
		self.m_Offset[count] = {amount = 0, typ = math.random(2) == 1 and "up" or "down", speed = math.random(2,3), canChange = math.random(2) == 1 and true or false, status = "continue"}
		count = count + 1
	end, 250, self.MAX_ROWS)
	

end

function DefuseMechanism:registerField()
	if not self.m_Active then return end
	local amount = self.m_Offset[self.m_CurrentField].amount
	
	short = amount - math.floor(amount/1920)*1920
	short = self.m_Fields[self.m_CurrentField][math.floor(short/64)+3]	
	
	if short == self.m_Password[self.m_CurrentField] then
		self.m_Offset[self.m_CurrentField].status = "pause"
		self.m_Offset[self.m_CurrentField].amount = math.floor(amount/64)*64
		self.m_CurrentField = self.m_CurrentField + 1
		if self.m_CurrentField-1 >= #self.m_Fields then
			triggerServerEvent("Defuse:success", resourceRoot)
		end
	else
		self.m_Fails = self.m_Fails + 1
		if self.m_Fails >= 10 then
			triggerServerEvent("Defuse:failure", resourceRoot, "fails")
		end
		self.m_CurrentField = math.max( 1, self.m_CurrentField - 1)
		self.m_Offset[self.m_CurrentField].status = "continue"
	end

end

function DefuseMechanism:onClick(button, state)
	if not self.m_Active  then return end
	if not isCursorShowing() then return end
	local cx, cy = getCursorPosition()
	cx, cy = cx*screenWidth, cy*screenHeight
	if button == "left" and state == "up" then
		if cx >= self.PositionX + (self.MAX_ROWS-1) * 64 and cx <= self.PositionX + (self.MAX_ROWS) * 64 and cy >= self.PositionY-50 and cy <= self.PositionY then
			triggerServerEvent("Defuse:failure", resourceRoot, "close")
		end
	end
end

function DefuseMechanism:draw()
	if not self.m_Active then return end
	dxDrawRectangle(self.PositionX, self.PositionY-50, 64*self.MAX_ROWS, 50, tocolor(0,0,0))
	dxDrawText(self.m_PasswordString,self.PositionX, self.PositionY-50, self.PositionX + 64*self.MAX_ROWS, self.PositionY, tocolor(255,255,255), 1.5, "diploma", "center", "center", true, false)
	dxDrawRectangle(self.PositionX, self.PositionY, 64*self.MAX_ROWS, 4*64, tocolor(0,0,0))
	for i = 0, self.MAX_ROWS-1, 1 do
		dxDrawImageSection(self.PositionX + i*64, self.PositionY, 64, 4*64, 0, self.m_Offset[i+1].amount, 64, 4*64, self.m_RenderTargets[i+1])
		if self.m_Offset[i+1].status == "continue" then
			self.m_Offset[i+1].amount = self.m_Offset[i+1].amount + (self.m_Offset[i+1].typ == "down" and - self.m_Offset[i+1].speed or self.m_Offset[i+1].speed)
		end
		--if self.m_Offset[i+1].canChange then
		--	if math.random(1,50) == 1 then
		--		self.m_Offset[i+1].typ = self.m_Offset[i+1].typ == "up" and "down" or "up"
		--	end
		--end
	end
	dxDrawLine(self.PositionX, self.PositionY, 64*self.MAX_ROWS + self.PositionX, self.PositionY, tocolor(255,255, 255), 2.5)
	dxDrawLine(self.PositionX, self.PositionY+64*2, 64*self.MAX_ROWS + self.PositionX, self.PositionY+64*2, tocolor(0,255,0), 2.5)
	dxDrawLine(self.PositionX, self.PositionY+64*3, 64*self.MAX_ROWS + self.PositionX, self.PositionY+64*3, tocolor(0,255,0), 2.5)
	dxDrawText("[X]",self.PositionX + (self.MAX_ROWS-1) * 64, self.PositionY-50, self.PositionX + (self.MAX_ROWS) * 64, self.PositionY, tocolor(255,255,255), 2.5, "default-bold", "center", "center", true, false)
	dxDrawText("Fehler: ".. self.m_Fails,self.PositionX + 5, self.PositionY-50, self.PositionX + 64*self.MAX_ROWS, self.PositionY, tocolor(255,255,255), 1.5, "diploma", "left", "center", true, false)
end