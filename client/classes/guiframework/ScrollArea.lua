GUIScrollArea = inherit(GUIBlankControl)


function GUIScrollArea:constructor(posX, posY, width, height, maxWidth, maxHeight, parentElement)
    GUIBlankControl.constructor(self, posX, posY, width, height, parentElement)

    self.m_MaxWidth = maxWidth
    self.m_MaxHeight = maxHeight
    self.m_ScrollRenderTarget = dxCreateRenderTarget(maxWidth, maxHeight, true)

    self.m_XScrollVelocity = 4
    self.m_YScrollVelocity = 4

    self.m_DiffX = 0
    self.m_DiffY = 0
end

function GUIScrollArea:onInternWheelUp()
    local preY = self.m_DiffY
    self.m_DiffY = math.max(0, self.m_DiffY - self.m_YScrollVelocity)
    if self.m_DiffY ~= 0 or ( preY ~= 0 and self.m_DiffY == 0 ) then
        self:adjustFramesOnYAxis(self, "up", specificAmount)
    end
    self:sthChanged()
end

function GUIScrollArea:onInternWheelDown()
    local preY = self.m_DiffY
    self.m_DiffY = math.min(self.m_MaxHeight - self.m_Height, self.m_DiffY + self.m_YScrollVelocity)
    if self.m_DiffY ~= ( self.m_MaxHeight - self.m_Height ) or (preY ~= (self.m_MaxHeight - self.m_Height) and self.m_DiffY == (self.m_MaxHeight - self.m_Height)) then
    self:adjustFramesOnYAxis(self, "down", specificAmount)
    end
    self:sthChanged()
end

function GUIScrollArea:flush()
    destroyElement(self.m_ScrollRenderTarget)
    self.m_ScrollRenderTarget = dxCreateRenderTarget(self.m_MaxWidth, self.m_MaxHeight, true)
	self.m_DiffY = 0
	self.m_DiffX = 0
end

function GUIScrollArea:adjustFramesOnYAxis(parentElement, typ, specificAmount)
    local amount = specificAmount and specificAmount or self.m_YScrollVelocity
    if parentElement.m_Children and #parentElement.m_Children > 0 then
        for key, value in ipairs(parentElement.m_Children) do
            value.m_PosY = value.m_PosY + ( typ == "up" and amount or -amount)
            self:adjustFramesOnYAxis(value, typ, specificAmount)
        end
    end
end

function GUIScrollArea:changeScrollSpeedOnXAxis(speed)
    self.m_XScrollVelocity = speed
end

function GUIScrollArea:changeScrollSpeedOnYAxis(speed)
    self.m_YScrollVelocity = speed
end

function GUIScrollArea:reset()
    self.m_DiffX = 0
    self.m_DiffY = 0
end

function GUIScrollArea:isItemWithinInArea(parent, child)
    if child.m_AltY + child.m_Height >= parent.m_DiffY and child.m_AltY <= parent.m_DiffY + parent.m_Height then
        child:setInteractable(true)
        return true
    end
    child:setInteractable(false)
    return false
end

function GUIScrollArea:updateChildren(parentElement)
    if parentElement.drawThis then
        parentElement:drawThis()
    end 
    for key, value in ipairs(parentElement.m_Children) do
        value.m_AltX = value.m_AltX - parentElement.m_AltX
        value.m_AltY = value.m_AltY - parentElement.m_AltY
        if value.m_Visible then
            self:updateChildren(value)
        end
        value.m_AltX = value.m_AltX + parentElement.m_AltX
        value.m_AltY = value.m_AltY + parentElement.m_AltY        
    end
end

function GUIScrollArea:drawThis()

    dxSetRenderTarget(self.m_ScrollRenderTarget, true)

    for key, value in ipairs(self.m_Children) do
        value.m_AltX = value.m_AltX - self.m_AltX
        value.m_AltY = value.m_AltY - self.m_AltY
        if value.m_Visible and self:isItemWithinInArea(self, value) then 
            self:updateChildren(value)
        end
        value.m_AltX = value.m_AltX + self.m_AltX
        value.m_AltY = value.m_AltY + self.m_AltY        
    end

    dxSetRenderTarget(self.m_RenderArea.m_RenderArea)

    dxDrawImageSection(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_DiffX, self.m_DiffY, self.m_Width, self.m_Height, self.m_ScrollRenderTarget)
end

function GUIScrollArea:destructor(...)
    destroyElement(self.m_ScrollRenderTarget)
    GUIBlank.destructor(self, ...)
end