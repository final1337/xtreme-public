GUICombobox = inherit(GUIBlankControl)

GUICombobox.globalActive = false


function GUICombobox:constructor(posX, posY, width, height, parentElement)
    GUIBlankControl.constructor(self, posX, posY, width, height, parentElement)

    self.m_Entrys = {}
    self.m_DropDown = false
    self.m_Text = false
    self.m_DropDownButton = GUIClassicButton:new(utf8.char(8681), width - 32, 0, 32, height, self)


    self.onComboSelect = false

    self.m_DropDownButton.onLeftUp = bind(self.Action_DropDown, self)

end

function GUICombobox:getText()
    return self.m_Text
end

function GUICombobox:setText(text)
    self.m_Text = text
    if GUICombobox.globalActive == self then
        GUICombobox.globalActive:destroyDropDown()
        GUICombobox.globalActive = false   
        
        if self.onComboSelect then
            self:onComboSelect(self)
        end
    end

    self:sthChanged()
end

function GUICombobox:addEntry(text)
    table.insert(self.m_Entrys, text)
end

function GUICombobox:addEntrys(entrys)
    for key, value in ipairs(entrys) do
        self:addEntry(value)
    end
end

function GUICombobox:destroyDropDown()
    if self.m_DropDown then
        delete(self.m_DropDown)
        self.m_DropDown = false
    end
end

function GUICombobox:Action_DropDown()
    if GUICombobox.globalActive and GUICombobox.globalActive ~= self then
        GUICombobox.globalActive:destroyDropDown()
        GUICombobox.globalActive = false
    elseif GUICombobox.globalActive and GUICombobox.globalActive == self then
        self:destroyDropDown()
        GUICombobox.globalActive = false
        return
    end

    if #self.m_Entrys == 0 then
        return
    end

    self.m_DropDown = GUIScrollArea:new(self.m_PosX, self.m_PosY+self.m_Height, self.m_Width, 300, self.m_Width, math.max (300,#self.m_Entrys*self.m_Height))

    self.m_DropDown:changeScrollSpeedOnYAxis(10)

    for key, value in ipairs(self.m_Entrys) do
        rKey = key - 1
        local row = GUIComboboxEntry:new(value, 0, rKey*self.m_Height, self.m_Width, self.m_Height, self.m_DropDown)
        if rKey % 2 == 0 then
            row:setColor(200, 200, 200, 250)
            row:setPermColor(200, 200, 200, 250)
        else
            row:setColor(50, 50, 50, 250)
            row:setPermColor(50, 50, 50, 250)
        end
    end

    self.m_DropDown:setVisible(true)

    GUICombobox.globalActive = self
end

function GUICombobox:drawThis()
    dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width - 32, self.m_Height, tocolor(50, 50, 50, 250))

    dxDrawBorderedTextExt(1, self.m_Text or "", self.m_AltX, self.m_AltY, self.m_AltX + self.m_Width - 32, self.m_AltY + self.m_Height,
                            tocolor(255, 255, 255), 1, "default-bold", "center", "center", true)
end

function GUICombobox:destructor(...)
    if GUICombobox.globalActive == self then
        delete(self.m_DropDown)
        self.m_DropDown = false
    end
    GUIBlank.destructor(self, ...)
end