Tooltip = inherit(Singleton)

function Tooltip:constructor()
	self.m_Visible = false
	self.m_Text = ""
	self.m_Anchor = false
	self.m_DrawHandler = bind(self.draw, self)
end

function Tooltip:show(text)
	if not self.m_Visible then
		addEventHandler("onClientRender", root, self.m_DrawHandler)
	end
	self.m_Anchor = false
	self.m_Visible = true

	self.m_Text = text
end

function Tooltip:setAnchor(guiElement)
	self.m_Anchor = guiElement
end

function Tooltip:getAnchor() return self.m_Anchor end

function Tooltip:hide()
	if self.m_Visible then
		removeEventHandler("onClientRender", root, self.m_DrawHandler)
	end
	self.m_Visible = false
end

function Tooltip:draw()

	if not isCursorShowing() then
		self:hide()
		return
	end

	local cX, cY = getCursorPosition()
	cX, cY = cX*screenWidth+12, cY*screenHeight+12


	local width = dxGetTextWidth(self.m_Text)
	local height = math.max(#split(self.m_Text,"\n"), 1) * dxGetFontHeight(1, "default-bold")
	dxDrawRectangle(cX - 8, cY - 8, width + 16, height + 16, tocolor(0,0,0))	

	dxDrawText(self.m_Text, cX, cY, 0, 0, tocolor(255,255,255), 1, "default-bold", "left", "top", false, false, false, true)

end