GUILine = inherit(GUIBlankControl)
inherit(GUIColourable, GUILine)

function GUILine:constructor(posX, posY, width, height, thickness, parent)
    GUIColourable.constructor(self)
    GUIBlankControl.constructor(self, posX, posY, width, height, parent)
    
    self.m_Thickness = thickness
end

function GUILine:setThickness(thickness)
    self.m_Thickness = thickness
    self:sthChanged()
end

function GUILine:drawThis()
	dxDrawLine(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_Color, self.m_Thickness)
end