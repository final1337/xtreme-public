GUIRectangle = inherit(GUIBlankControl)
inherit(GUIColourable, GUIRectangle)

function GUIRectangle:constructor(posX, posY, width, height, parent)
	GUIColourable.constructor(self)
	GUIBlankControl.constructor(self, posX, posY, width, height, parent)

	self.m_Frame = false

end

function GUIRectangle:setFrame(bool)
	self.m_Frame = bool
	return self
end

function GUIRectangle:drawThis()
	if self.m_Frame then
		dxDrawLine(self.m_AltX, self.m_AltY, self.m_AltX + self.m_Width, self.m_AltY, self.m_Color)
		dxDrawLine(self.m_AltX, self.m_AltY, self.m_AltX, self.m_AltY + self.m_Height, self.m_Color)
		dxDrawLine(self.m_AltX + self.m_Width, self.m_AltY + self.m_Height, self.m_AltX + self.m_Width, self.m_AltY, self.m_Color)
		dxDrawLine(self.m_AltX + self.m_Width, self.m_AltY + self.m_Height, self.m_AltX, self.m_AltY + self.m_Height, self.m_Color)
	else
		dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_Color)
	end
end