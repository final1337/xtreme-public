CraftingFrame = inherit(ItemFrameTemplate)

function CraftingFrame:constructor(posX, posY, width, height, parentElement)
    ItemFrameTemplate.constructor(self, posX, posY, width, height, parentElement)


    self.m_CurrentAmount = 0
	self.m_RequiredAmount = 0
	self.m_Alpha = 255
end

function CraftingFrame:setAlpha(alpha)
	self.m_Alpha = alpha
end

function CraftingFrame:setCurrentAmount(int)
	self.m_CurrentAmount = int
end

function CraftingFrame:setRequiredAmount(int)
	self.m_RequiredAmount = int
end

function CraftingFrame:drawThis()
	--dxDrawRectangle(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, self.m_Color)
	local fulFilled = self.m_CurrentAmount >= self.m_RequiredAmount
	if self.m_TemplateItem and self.m_TemplateItem:getDisplayPicture() then
		if fileExists("Files/".. self.m_TemplateItem:getDisplayPicture()) then
			dxDrawImage(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, "Files/".. self.m_TemplateItem:getDisplayPicture(), 0, 0, 0, tocolor(255, 255, 255, fulFilled and 255 or 150))
		elseif fileExists("files/".. self.m_TemplateItem:getDisplayPicture()) then
			dxDrawImage(self.m_AltX, self.m_AltY, self.m_Width, self.m_Height, "files/".. self.m_TemplateItem:getDisplayPicture(), 0, 0, 0, tocolor(255, 255, 255, fulFilled and 255 or 150))
        end
	end
	
	if self.m_RequiredAmount > 0 then
		dxDrawBorderedTextExt(1, ("%d/%d"):format(self.m_CurrentAmount, self.m_RequiredAmount), self.m_AltX, self.m_AltY, self.m_AltX + self.m_Width - 3, self.m_AltY + self.m_Height, tocolor(255,255,255),
					1, "default", "right", "bottom")
	end
end