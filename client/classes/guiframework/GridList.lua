GUIGridList = inherit(GUIBlankControl)

GUIGridList.DescriptionHeight = 16
GUIGridList.EntryHeight = 24

--// SELECTIONMODES:
--// ROW: Whole row
--// COL: column specific entry

function GUIGridList:constructor(posX, posY, width, height, parentElement)
    GUIBlankControl.constructor(self, posX, posY, width, height, parentElement)

    self.m_Columns = {}
    self.m_Entrys  = {}
    self.m_Selected = {}

    self.m_EntryHeight = GUIGridList.EntryHeight 

    self.m_ScrollArea = GUIScrollArea:new(0, GUIGridList.DescriptionHeight, width, height - GUIGridList.DescriptionHeight, width, 3000, self)

    self.m_InteractionMode = "ROW"

    self.m_MultiSelection = false
    self.m_MaxSelection = math.huge
	
	self.m_ActiveRows = {}
	
    self.onGridSelect = false
    
    self.m_ShowColumns = true
end

function GUIGridList:getEntrys() return self.m_Entrys end
function GUIGridList:setMultiSelection(bool) self.m_MultiSelection = bool end
function GUIGridList:getMultiSelection() return self.m_MultiSelection end
function GUIGridList:setMaxSelection(int) self.m_MaxSelection = int end
function GUIGridList:getMaxSelection() return self.m_MaxSelection end
function GUIGridList:setColumnsVisible(bool) self.m_ShowColumns = bool end

function GUIGridList:getActiveRow()
	return self.m_ActiveRows[1]
end

function GUIGridList:getActiveRows()
    return self.m_ActiveRows
end

function GUIGridList:flush()
   local currentVisibleStatus = self.m_Visible
    self:setVisible(false)
    for key, value in ipairs(self.m_Entrys) do
        delete(value)
    end
    self.m_Entrys = {}
    self.m_ActiveRows = {}
    self.m_ScrollArea:flush()
    self:setVisible(currentVisibleStatus)
end

function GUIGridList:isRowSelected(row)
    for key, value in ipairs(self.m_ActiveRows) do
        if row == value then
            return key
        end
    end
    return false
end

function GUIGridList:setActiveRow(row, force, noaction)

    if self:getMultiSelection() and ( getKeyState("lctrl") or force ) then
        local selected = self:isRowSelected(row)
        if selected then
            row:deselect()
            table.remove(self.m_ActiveRows, selected)
        else
            row:select()
            table.insert(self.m_ActiveRows, row)
        end
    else
        if self:getMultiSelection() and #self.m_ActiveRows > 1 then
            for key, value in ipairs(self.m_ActiveRows) do
                value:deselect()
            end
            self.m_ActiveRows = {}
        end

        if #self.m_ActiveRows > 0 and row ~= self.m_ActiveRows[1] then
            self.m_ActiveRows[1]:deselect()
            self.m_ActiveRows[1] = row
            row:select()
        elseif #self.m_ActiveRows > 0 and row == self.m_ActiveRows[1] then
            row:deselect()
            self.m_ActiveRows = {}
        elseif #self.m_ActiveRows == 0 then
            self.m_ActiveRows[1] = row
            row:select() 
        end
    end

	if self.onGridSelect and not noaction then
		self.onGridSelect()
	end
	
	self:sthChanged()
end

function GUIGridList:setEntryHeight(height)
    self.m_EntryHeight = height
end

function GUIGridList:getScrollArea()
    return self.m_ScrollArea
end

function GUIGridList:getEntryHeight() return self.m_EntryHeight end

function GUIGridList:addRow()
    local row = GUIGridListEntry:new(0, 0 + #self.m_Entrys*self:getEntryHeight(), self.m_ScrollArea.m_Width, self:getEntryHeight(), self.m_ScrollArea)
    table.insert(self.m_Entrys, row)
    if #self.m_Entrys % 2 ~= 0 then
        row:setColor(200, 200, 200, 200)
    else
        row:setColor(50, 50, 50, 200)
    end
    return row
end

function GUIGridList:getColumns() return self.m_Columns end

function GUIGridList:drawThis()
    dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, tocolor(0, 0, 0, 180))
    if not self.m_ShowColumns then return end
    local currentRelative = 0
    for key, value in ipairs(self.m_Columns) do
        dxDrawText(value.Name, self.m_AltX + currentRelative*self.m_Width, self.m_AltY, self.m_AltX + (currentRelative + value.RelativeWidth)*self.m_Width, self.m_AltY + GUIGridList.DescriptionHeight,
                    "0xFFFFFFFF", 1, "default", "left", "center", true)
        currentRelative = currentRelative + value.RelativeWidth
    end
end

function GUIGridList:addColumn(columnName, relativeWidth)
    table.insert(self.m_Columns, {Name = columnName, RelativeWidth = relativeWidth})
end