ItemDragAndDrop = inherit(Singleton)

function ItemDragAndDrop:constructor()
	self.m_CurrentItemFrame = false

	self.m_DrawThisHandler = bind(self.drawThis, self)

end

function ItemDragAndDrop:setItemFrame(itemFrame)
	if itemFrame and not itemFrame:isDragable() then
		return
	end
	self.m_CurrentItemFrame = itemFrame
	if self.m_CurrentItemFrame then
		addEventHandler("onClientRender", root, self.m_DrawThisHandler)
	else
		removeEventHandler("onClientRender", root, self.m_DrawThisHandler)
	end
end

function ItemDragAndDrop:drawThis()
	local cx, cy = getAbsoluteCursorPosition()
	
	if not cx then
		removeEventHandler("onClientRender", root, self.m_DrawThisHandler)
		self.m_CurrentItemFrame = false
		return
	end
	-- dxDrawText(self.m_CurrentItemFrame:getTemplateItem():getName(), cx, cy)
	dxDrawImage(cx, cy, 32, 32, "files/".. self.m_CurrentItemFrame:getTemplateItem():getDisplayPicture())
end

function ItemDragAndDrop:getItemFrame()
	return self.m_CurrentItemFrame
end

function ItemDragAndDrop:destructor()

end