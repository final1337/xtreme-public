GUIComboboxEntry = inherit(GUIBlankControl)
inherit(GUIColourable, GUIComboboxEntry)

function GUIComboboxEntry:constructor(text, posX, posY, width, height, parentElement)
    GUIBlankControl.constructor(self, posX, posY, width, height, parentElement)
    GUIColourable.constructor(self)

    local k = math.random(255)

    self.m_Text = text

    self:setColor(k, k, k, 240)

    self.m_PermColour = {255, 255, 255, 255}

end

function GUIComboboxEntry:setPermColor(r, g, b, a)
    self.m_PermColour = {r,g,b,a}
end

function GUIComboboxEntry:onInternHoverStart()
	self:setColor(XTREAM_ORANGE[1], XTREAM_ORANGE[2], XTREAM_ORANGE[3])
end

function GUIComboboxEntry:onInternHoverStop()
	self:setColor(unpack(self.m_PermColour))
end

function GUIComboboxEntry:onInternLeftUp()
    if GUICombobox.globalActive then
        GUICombobox.globalActive:setText(self.m_Text)
    end
end

function GUIComboboxEntry:drawThis()
    dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height - 2, self.m_Color)
    dxDrawBorderedTextExt(1, self.m_Text, self.m_AltX, self.m_AltY, self.m_AltX + self.m_Width, self.m_AltY + self.m_Height,
                            tocolor(255, 255, 255), 1, "default-bold", "center", "center", true)
end

function GUIComboboxEntry:onInternWheelUp()
    self.m_ParentElement:onInternWheelUp()
end

function GUIComboboxEntry:onInternWheelDown()  
    self.m_ParentElement:onInternWheelDown()
end