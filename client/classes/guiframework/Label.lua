GUILabel = inherit(GUIBlankControl)
inherit(GUIColourable,GUILabel)

function GUILabel:constructor(text, posX, posY, right, bottom, parent)
  GUIColourable.constructor(self)
  GUIBlankControl.constructor(self, posX, posY, right, bottom, parent)

  self.m_Text = text
  self.m_Scale = 1
  self.m_Font = "default"
  self.m_AlignX = "left"
  self.m_AlignY = "center"
  self.m_Clip = false
  self.m_WordBreak = false
  self.m_PostGUI = false
  self.m_ColorCoded = false
  self.m_SPP = false
  self.m_FRotation = 0
  self.m_FRotationCX = 0
  self.m_FRotationCY = 0

  self:setColor(255,255,255)

end

function GUILabel:setText(text) self.m_Text = text self:sthChanged() return self end
function GUILabel:setFont(font) self.m_Font = font self:sthChanged()  return self end
function GUILabel:setScale (scale) self.m_Scale = scale self:sthChanged()   return self end
function GUILabel:setAlignX(align) self.m_AlignX = align self:sthChanged()  return self  end
function GUILabel:setAlignY(align) self.m_AlignY = align self:sthChanged()  return self  end
function GUILabel:setClip(boolean) self.m_Clip = boolean self:sthChanged()  return self  end
function GUILabel:setWordBreak(boolean) self.m_WordBreak = boolean self:sthChanged()  return self  end
function GUILabel:setPostGUI(boolean) self.m_PostGUI = boolean self:sthChanged()  return self  end
function GUILabel:setColorCoded(boolean) self.m_ColorCoded = boolean self:sthChanged()  return self  end
function GUILabel:setSPP(boolean) self.m_SPP = boolean self:sthChanged()   return self end
function GUILabel:setRotation(rotation) self.m_FRotation = rotation self:sthChanged()   return self end
function GUILabel:setRotationCX(rotation) self.m_FRotationCX = rotation  self:sthChanged() return self  end
function GUILabel:setRotationCY(rotation) self.m_FRotationCY = rotation  self:sthChanged() return self  end

function GUILabel:getText() return self.m_Text end
function GUILabel:getFont() return self.m_Font end
function GUILabel:getScale () return self.m_Scale  end
function GUILabel:getAlignX() return self.m_AlignX  end
function GUILabel:getAlignY() return self.m_AlignY  end
function GUILabel:getClip() return self.m_Clip  end
function GUILabel:getWordBreak() return self.m_WordBreak  end
function GUILabel:getPostGUI() return self.m_PostGUI  end
function GUILabel:getColorCoded() return self.m_ColorCoded  end
function GUILabel:getSPP() return self.m_SPP  end
function GUILabel:getRotation() return self.m_FRotation  end
function GUILabel:getRotationCX() return self.m_FRotationCX  end
function GUILabel:getRotationCY()return  self.m_FRotationCY end

function GUILabel:drawThis()
  dxDrawText(self.m_Text, self.m_AltX, self.m_AltY, self.m_AltX + self.m_Width, self.m_AltY + self.m_Height, self.m_Color, self.m_Scale, self.m_Font, self.m_AlignX, self.m_AlignY, self.m_Clip, self.m_WordBreak,
  self.m_PostGUI, self.m_ColorCoded, self.m_SPP, self.m_FRotation, self.m_FRotationCX, self.m_FRotationCY)
end
