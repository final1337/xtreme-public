Renderer = inherit(Singleton)

function Renderer:constructor()
	self.m_RenderAreas = {}

	self.m_ControlRender 	  = bind(self.updateAllControlls, self)
	self.m_UpdateRenderArea   = bind(self.updateAllRenderArea, self)

	self.m_InteractedSinceLastTick = false
	self.m_FocusedSinceLastTick = false
	self.m_LastInteractedWindow = false
	self.m_LastFocusedElement = element

	addEventHandler("onClientPreRender", root, self.m_ControlRender)
	addEventHandler("onClientRender",    root, self.m_UpdateRenderArea)
end
-- adds a new render area
-- new render areas are always at the top
function Renderer:addRenderArea(renderArea)
	local currentAreas = {unpack(self.m_RenderAreas)}
	self.m_RenderAreas = {}
	table.insert(self.m_RenderAreas, renderArea)
	for key, value in ipairs (currentAreas) do
		table.insert(self.m_RenderAreas, value)
	end
end

function Renderer:removeRenderArea(renderArea)
	for key, value in ipairs(self.m_RenderAreas) do
		if value == renderArea then
			table.remove(self.m_RenderAreas, key)
			return true
		end
	end
	return false
end

function Renderer:sthInteracted(element)
	local parentElement = element
	if element.m_ParentElement then
		while parentElement.m_ParentElement do
			parentElement = parentElement.m_ParentElement
		end
	end
	parentElement = parentElement.m_RenderArea
	if self.m_LastInteractedWindow ~= parentElement then
		self.m_LastInteractedWindow = parentElement
		for key, value in ipairs(self.m_RenderAreas) do
			if value == self.m_LastInteractedWindow then
				table.remove(self.m_RenderAreas, key)
				self:addRenderArea(self.m_LastInteractedWindow)
			end
		end
	end
	self.m_InteractedSinceLastTick = true
end

function Renderer:getLastFocusedElement()
	return self.m_LastFocusedElement
end

function Renderer:focused(element)
	self.m_LastFocusedElement = element
	self.m_FocusedSinceLastTick = true
end

-- controlls all targets also via the renderarea
function Renderer:updateAllControlls()
	self.m_InteractedSinceLastTick = false
	self.m_FocusedSinceLastTick    = false
	for key, value in ipairs(self.m_RenderAreas) do
		if value.m_ParentElement.m_Visible then
			value:controlUpdate()
		end
	end
end

-- render all areas with images
function Renderer:updateAllRenderArea()
	for i = #self.m_RenderAreas, 1, -1 do -- key, value in ipairs(self.m_RenderAreas) do
		-- if value.m_ParentElement.m_Visible then
		-- 	value:drawThis()
		-- end
		if self.m_RenderAreas[i].m_ParentElement.m_Visible then
			self.m_RenderAreas[i]:drawThis()
		end 
	end
	if false then
		local i = 0
		for key, value in pairs(dxGetStatus()) do
			dxDrawText(key..": "..tostring(value),screenWidth/2, i*10)

			i = i + 1
		end
	end
end