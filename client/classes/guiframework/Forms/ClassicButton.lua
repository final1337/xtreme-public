GUIClassicButton = inherit(GUIBlankControl)
inherit(GUIColourable, GUIClassicButton)

function GUIClassicButton:constructor(text, posX, posY, width, height, parentElement)
	GUIBlankControl.constructor(self, posX, posY, width, height, parentElement)
	self.m_Background = GUIRectangle:new(0, 0, width, height, self):setColor(XTREAM_ORANGE[1], XTREAM_ORANGE[2], XTREAM_ORANGE[3])
	self.m_Rectangle = GUIRectangle:new(1, 1, width - 2, height - 2, self)
	self.m_Rectangle:setColor(100, 100, 100)
	self.m_Text = GUILabel:new(text, 0, 0, width, height, self.m_Rectangle)

	self.m_Text:setAlignX("center"):setAlignY("center")


	self.m_Text.onInternLeftUp = self.onInternalLabelLeftUp
	self.m_Text.onInternLeftDown = self.onInternalLabelLeftDown

	self.m_Rectangle.onInternLeftUp = self.onInternalRectangleLeftUp
	self.m_Rectangle.onInternLeftDown = self.onInternalRectangleLeftDown

	self.m_Background.onInternLeftUp = self.onInternalRectangleLeftUp
	self.m_Background.onInternLeftDown = self.onInternalRectangleLeftDown

	self.m_Text.onInternRightUp = self.onInternalLabelRightUp
	self.m_Text.onInternRightDown = self.onInternalLabelRightDown

	self.m_Rectangle.onInternRightUp = self.onInternalRectangleRightUp
	self.m_Rectangle.onInternRightDown = self.onInternalRectangleRightDown

	self.m_Background.onInternRightUp = self.onInternalRectangleRightUp
	self.m_Background.onInternRightDown = self.onInternalRectangleRightDown



	self.m_Text.onInternHoverStart = bind(self.onInternHoverStart, self)
	self.m_Text.onInternHoverStop = bind(self.onInternHoverStop, self)

	self.m_Background.onInternHoverStart = bind(self.onInternHoverStart, self)
	self.m_Background.onInternHoverStop = bind(self.onInternHoverStop, self)

	--[[self.m_Rectangle.onInternRightUp = self.onInternalRightClickUp
	self.m_Text.onInternRightUp = self.onInternalRightClickUp

	self.m_Rectangle.onInternRightDown = self.onInternalRightClickDown
	self.m_Text.onInternRightDown = self.onInternalRightClickDown]]
end

function GUIClassicButton:onInternHoverStart()
	self.m_Rectangle:setColor(XTREAM_ORANGE[1], XTREAM_ORANGE[2], XTREAM_ORANGE[3])
end

function GUIClassicButton:onInternHoverStop()
	self.m_Rectangle:setColor(100, 100, 100)
end

function GUIClassicButton:drawThis()

end

function GUIClassicButton:setText(...)
	self.m_Text:setText(...)
end

function GUIClassicButton:onInternalLabelLeftUp()
	if self.m_ParentElement.m_ParentElement.onLeftUp then
		self.m_ParentElement.m_ParentElement:onLeftUp()
	end
end

function GUIClassicButton:onInternalLabelLeftDown()
	if self.m_ParentElement.m_ParentElement.onLeftDown then
		self.m_ParentElement.m_ParentElement:onLeftDown()
	end
end

function GUIClassicButton:onInternalRectangleLeftUp()
	if self.m_ParentElement.onLeftUp then
		self.m_ParentElement:onLeftUp()
	end
end

function GUIClassicButton:onInternalRectangleLeftDown()
	if self.m_ParentElement.onLeftDown then
		self.m_ParentElement:onLeftDown()
	end
end

function GUIClassicButton:onInternalLabelRightUp()
	if self.m_ParentElement.m_ParentElement.onRightUp then
		self.m_ParentElement.m_ParentElement:onRightUp()
	end
end

function GUIClassicButton:onInternalLabelLeftDown()
	if self.m_ParentElement.m_ParentElement.onRightDown then
		self.m_ParentElement.m_ParentElement:onLeftDown()
	end
end

function GUIClassicButton:onInternalRectangleRightUp()
	if self.m_ParentElement.onRightUp then
		self.m_ParentElement:onRightUp()
	end
end

function GUIClassicButton:onInternalRectangleRightDown()
	if self.m_ParentElement.onRightDown then
		self.m_ParentElement:onRightDown()
	end
end