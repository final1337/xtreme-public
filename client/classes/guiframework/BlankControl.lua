GUIBlankControl = inherit(GUIBlank)

local getCursorPosition = getCursorPosition

function GUIBlankControl:constructor(posX, posY, width, height, parentElement)
	GUIBlank.constructor(self, posX, posY, width, height, parentElement)
	self.m_Interactable = true

	self.m_LeftButtonDown 	= false
	self.m_RightButtonDown 	= false
	self.m_LeftButtonUp 	= false
	self.m_LeftButtonDown 	= false
	
	self.m_Hover = false

	self.onLeftDown = false
	self.onLeftUp = false
	-- self.onInternLeftDown = false
	-- self.onInternLeftUp = false

	self.onRightDown = false
	self.onRightUp = false

	self.onHoverStart = false;
	self.onHoverStop  = false;

	-- self.onInternRightDown = false
	-- self.onInternRightUp = false	
end

function GUIBlankControl:setInteractable(bool) self.m_Interactable = bool return self end
function GUIBlankControl:getInteractable() return self.m_Interactable end

function GUIBlankControl:disable()
	self.m_LeftButtonDown 	= false
	self.m_LeftButtonUp 	= false		
	self.m_RightButtonDown 	= false
	self.m_RightButtonUp 	= false	
	if self.m_Hover then
		if self.onHoverStop then
			self:onHoverStop();
		end
		if self.onInternHoverStop then
			self:onInternHoverStop();
		end			
	end
	self.m_Hover 			= false
end

function GUIBlankControl:checkControls()
	-- disable all previous controlls

	if not self:getInteractable() or not self:isVisible() then return end

	if Renderer:getSingleton().m_FocusedSinceLastTick then
		self:disable()
		return
	end

	local cX, cY = getAbsoluteCursorPosition()
	
	-- Check if the cursos is out of the bounds of the highestParentElement -- not visible anymore
	local highest = self.m_HighestParentElement

	if not highest then
		if not cX or not ( cX >= self.m_PosX and cY >= self.m_PosY and cX <= self.m_PosX + self.m_Width and cY <= self.m_PosY + self.m_Height ) then
			self:disable()
			return
		end
	else
		if not cX then
			self:disable()
			return
		end
		if not ( cX >= highest.m_PosX and cY >= highest.m_PosY and cX <= highest.m_PosX + highest.m_Width and cY <= highest.m_PosY + highest.m_Height ) then
			self:disable()
			return
		end
		if not ( cX >= self.m_PosX and cY >= self.m_PosY and cX <= self.m_PosX + self.m_Width and cY <= self.m_PosY + self.m_Height ) then
			self:disable()
			return
		end		
	end

	-- Todo: at focus area

	Renderer:getSingleton():focused(self)

	
	if not self.m_Hover then
		self.m_Hover = true;
		if self.onHoverStart then
			self:onHoverStart();
		end
		if self.onInternHoverStart then
			self:onInternHoverStart();
		end		
	end

	if not self.m_LeftButtonDown and getKeyState("mouse1") then
		self.m_LeftButtonDown = true
		self.m_LeftButtonUp = false
		Renderer:getSingleton():sthInteracted(self)
		if self.onLeftDown then
			self:onLeftDown()
		end
		if self.onInternLeftDown then
			self:onInternLeftDown()
		end
		
	elseif self.m_LeftButtonDown and not getKeyState("mouse1") then
		self.m_LeftButtonDown = false
		self.m_LeftButtonUp = true
		Renderer:getSingleton():sthInteracted(self)
		if self.onLeftUp then
			self:onLeftUp(self)
		end
		if self.onInternLeftUp then
			self:onInternLeftUp()
		end
		
	end

	if not self.m_RightButtonDown and getKeyState("mouse2") then
		self.m_RightButtonDown = true
		self.m_RightButtonUp = false
		Renderer:getSingleton():sthInteracted(self)
		if self.onRightDown then
			self:onRightDown(self)
		end
		if self.onInternRightDown then
			self:onInternRightDown()
		end
		
	elseif self.m_RightButtonDown and not getKeyState("mouse2") then
		self.m_RightButtonDown = false
		self.m_RightButtonUp = true
		Renderer:getSingleton():sthInteracted(self)
		if self.onRightUp then
			self:onRightUp(self)
		end
		if self.onInternRightUp then
			self:onInternRightUp()
		end		
		
	end



end

function GUIBlankControl:checkControl()
	-- start at the lowest element

	for key, value in ipairs(self.m_Children) do
		value:checkControl()
	end
	-- for i = #self.m_Children, 1, -1 do
	-- 	self.m_Children[i]:checkControl() 
	-- end
	self:checkControls()
end

addEventHandler("onClientKey", root,
	function (button, pressOrRelease)
		if pressOrRelease then
			if button == "mouse_wheel_up" then
				local lastFocusedElement = Renderer:getSingleton():getLastFocusedElement()
				if lastFocusedElement then
					if lastFocusedElement.onInternWheelUp then
						lastFocusedElement:onInternWheelUp()
					end
					if lastFocusedElement.onWheelUp then
						lastFocusedElement:onWheelUp()
					end					
				end
			elseif button == "mouse_wheel_down" then
				local lastFocusedElement = Renderer:getSingleton():getLastFocusedElement()
				if lastFocusedElement then
					if lastFocusedElement.onInternWheelDown then
						lastFocusedElement:onInternWheelDown()
					end
					if lastFocusedElement.onWheelDown then
						lastFocusedElement:onWheelDown()
					end					
				end
			end
		end
	end
)