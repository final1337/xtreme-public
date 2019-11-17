RenderArea = inherit(Object)


function RenderArea:constructor(parentElement)
	self.m_ParentElement = parentElement
	-- self.m_RenderArea = dxCreateRenderTarget(parentElement.m_Width, parentElement.m_Height, true)

	Renderer:getSingleton():addRenderArea(self)
end

-- render the image new for update purposes
function RenderArea:update()
	if self.m_ParentElement.m_Visible and self.m_ParentElement.drawThis then
		if isElement(self.m_RenderArea) then
			destroyElement(self.m_RenderArea)
		end
		self.m_RenderArea = dxCreateRenderTarget(self.m_ParentElement.m_Width, self.m_ParentElement.m_Height, true)
		dxSetRenderTarget(self.m_RenderArea, true)
		self:updateRecursive(self.m_ParentElement)
		dxSetRenderTarget()
	end
end

function RenderArea:updateRecursive(parentElement)
	if parentElement.m_Visible and not parentElement.m_MaxWidth then
		if parentElement.drawThis then
			parentElement:drawThis()	
		end
		for key, value in ipairs(parentElement.m_Children) do
			self:updateRecursive(value)
		end
	elseif parentElement.m_Visible and parentElement.m_MaxWidth then
		parentElement:drawThis()
	end
end

-- Used to check controlls
function RenderArea:controlUpdate()
	self.m_ParentElement:checkControl()
end

-- renders the renderarea as image on right
function RenderArea:drawThis()
	dxSetBlendMode("modulate_add")
	local posX, posY, width, height = self.m_ParentElement.m_PosX, self.m_ParentElement.m_PosY, self.m_ParentElement.m_Width, self.m_ParentElement.m_Height
	dxDrawImage(posX, posY, width, height, self.m_RenderArea)
	dxSetBlendMode("blend")
end

function RenderArea:destructor()
	Renderer:getSingleton():removeRenderArea(self)
	if isElement(self.m_RenderArea) then
		destroyElement(self.m_RenderArea)
	end
end