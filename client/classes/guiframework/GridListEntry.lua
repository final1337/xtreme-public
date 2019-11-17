GUIGridListEntry = inherit(GUIBlankControl)
inherit(GUIColourable, GUIGridListEntry)

function GUIGridListEntry:constructor(posX, posY, width, height, parentElement)
    GUIBlankControl.constructor(self, posX, posY, width, height, parentElement)
    GUIColourable.constructor(self)

    local k = math.random(255)

    self:setColor(k, k, k, 200)

    self.m_Values = {}
    self.m_Data = {}

    self.m_LabelColour = tocolor(255, 255, 255)
	
	self.m_Active = false
end

function GUIGridListEntry:setLabelColour(r,g,b)
    self.m_LabelColour = tocolor(r,g,b)
end
GUIGridListEntry.setLabelColor = GUIGridListEntry.setLabelColour

function GUIGridListEntry:select()
	self.m_Active = true
end

function GUIGridListEntry:deselect()
	self.m_Active = false
end

function GUIGridListEntry:onInternLeftUp()
    -- Calculates the affected column
    local cx, cy = getCursorPosition()
    cx = cx*screenWidth 
    local activeColumn = false   
    local currentRelative = 0
    for key, value in ipairs(self:getGridList():getColumns()) do
        if cx >= self.m_PosX + self.m_Width * (currentRelative) then
            activeColumn = key
        end
        currentRelative = currentRelative + value.RelativeWidth
    end
	-- Allow interaction
	self:getGridList():setActiveRow(self)
end

function GUIGridListEntry:setData(key, value)
    self.m_Data[key] = data
end

function GUIGridListEntry:getData(key) return self.m_Data[key] end

function GUIGridListEntry:setValue(column, value)
    self.m_Values[column] = value
end

function GUIGridListEntry:getValues() return self.m_Values end

function GUIGridListEntry:getColumnValue(column)
	return self.m_Values[column] or ""
end

function GUIGridListEntry:drawThis()
    local columnsToRender = self:getGridList():getColumns()

    dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_Color)
	
	if self.m_Active then
		dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, tocolor(XTREAM_ORANGE[1], XTREAM_ORANGE[2], XTREAM_ORANGE[3], 230))
	end
	
    local currentRelative, text = 0, ""
    for key, value in ipairs(columnsToRender) do
        text = self:getColumnValue(value.Name)
       dxDrawText(text, self.m_AltX + currentRelative * self.m_Width, self.m_AltY, self.m_AltX + (currentRelative + value.RelativeWidth) * self.m_Width, self.m_AltY + GUIGridList.EntryHeight,
                self.m_LabelColour, 1, "default", "left", "center", true)
        currentRelative = currentRelative + value.RelativeWidth
    end
end

function GUIGridListEntry:onInternWheelUp()
    self.m_ParentElement:onInternWheelUp()
end

function GUIGridListEntry:onInternWheelDown()  
    self.m_ParentElement:onInternWheelDown()
end

function GUIGridListEntry:getGridList()
    return self.m_ParentElement.m_ParentElement
end