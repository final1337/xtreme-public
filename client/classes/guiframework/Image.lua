GUIImage = inherit(GUIBlankControl)
inherit(GUIColourable, GUIImage)

function GUIImage:constructor(posX, posY, width, height, imagePath, parent)
	GUIColourable.constructor(self)
	GUIBlankControl.constructor(self, posX, posY, width, height, parent)

	self.m_ImagePath = imagePath
end

function GUIImage:drawThis()
	dxDrawImage(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_ImagePath)
	-- dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_Color)
end