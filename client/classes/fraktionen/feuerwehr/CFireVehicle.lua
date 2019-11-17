FireVehicle = inherit(Singleton)

-- Purpose: Includes the managmentclass for firefightervehicle ( 407 )


function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                              
end

local screenWidth, screenHeight = guiGetScreenSize()

function FireVehicle:constructor()
	self.m_Selected = 1
	self.m_ActiveObject = false
	self.m_RenderTarget = dxCreateRenderTarget(screenWidth*0.2, screenHeight*0.2, true)
	
	-- Add the ACTION_LIST-Events
	
	self.m_Events = {
		[407] = {
			{ Func = nil, Name = "Wasserstand: %d l", ElementData = {"Tank"} },
			{ Func = bind(self.getPump, self), Name = "Pumpe: %s", ElementData = {"PumpeDesc"}  },
			{ Func = bind(self.getChainSaw, self), Name = "Kettensäge" },
			--{ Func = bind(self.getDynamite, self), Name = "Dynamite" },
			{ Func = bind(self.getPickAxe, self), Name = "Spitzhacke" },
			--{ Func = bind(self.getBeatmung, self), Name = "Beatmungsgerät" },
			{ Func = bind(self.fillFireExt, self), Name = "Feuerlöscher" },
			{ Func = bind(self.getBarricades, self), Name = "Barrikaden" },
			{ Func = bind(self.getOnVehicle, self), Name = "Draufklettern: %s", ElementData = {"AufsteigbarDesc"} },
		},
		[563] = {
			{ Func = nil, Name = "Wassertank: %d l", ElementData = {"Tank"} },
			{ Func = bind(self.fillFireExtHelicopter, self), Name = "Feuerlöscher" },
			{ Func = bind(self.getChainSaw, self), Name = "Kettensäge" },
			{ Func = bind(self.getPickAxe, self), Name = "Spitzhacke" },
		},	
		[490] = {
			{ Func = bind(self.getChainSaw, self), Name = "Kettensäge" },
			{ Func = bind(self.getPickAxe, self), Name = "Spitzhacke" },
		},
	}
	
	addEventHandler("onClientRender", root, bind(self.draw, self))
	addEventHandler("onClientKey", root, bind(self.Event_OnClientMouseWheel, self))
	addEventHandler("onClientElementStreamIn", resourceRoot, bind(self.Event_ElementStreamIn, self))
	addEventHandler("onClientObjectBreak", resourceRoot, bind(self.Event_ObjectBreak, self))
	bindKey("z", "down", bind(self.performAction, self))
end

function FireVehicle:Event_ObjectBreak()
	if getElementData(source, "isUnbreakable") then
		cancelEvent(true)
	end
end

function FireVehicle:fillFireExtHelicopter()
	triggerServerEvent("XTM:FF:fillFireExtHelicopter", self.m_ActiveObject)
end

function FireVehicle:performAction(key,button,state)
	if self.m_ActiveObject then
		if self.m_Events[getElementModel(self.m_ActiveObject)][self.m_Selected].Func then
			self.m_Events[getElementModel(self.m_ActiveObject)][self.m_Selected].Func()
		end
		-- Reset the render target with delay
		-- reason for this is the synchronization
		setTimer(bind(self.refreshRenderTarget, self), 150, 1)
	end
end

function FireVehicle:getOnVehicle()
	triggerServerEvent("XTM:FF:getOnVehicle", self.m_ActiveObject)
end

function FireVehicle:getBarricades()
	triggerServerEvent("XTM:FF:getBarricades", self.m_ActiveObject)
end

function FireVehicle:getChainSaw()
	triggerServerEvent("XTM:FF:getChainSaw", self.m_ActiveObject)
end

function FireVehicle:getDynamite()
	triggerServerEvent("XTM:FF:getDynamite", self.m_ActiveObject)
end

function FireVehicle:getPickAxe()
	triggerServerEvent("XTM:FF:getPickAxe", self.m_ActiveObject)
end

function FireVehicle:getBeatmung()
	triggerServerEvent("XTM:FF:getBeatmung", self.m_ActiveObject)
end

function FireVehicle:fillFireExt()
	triggerServerEvent("XTM:FF:fillFireExt", self.m_ActiveObject)
end

function FireVehicle:getPump()
	if self.m_ActiveObject and self.m_ActiveObject.model == 407 then
		triggerServerEvent("XTM:FF:getPump", self.m_ActiveObject)
	end
end

function FireVehicle:Event_OnClientMouseWheel(btn,state)
	if  ( btn == "mouse_wheel_up" or btn == "mouse_wheel_down" ) and state then
		local upOrDown = btn == "mouse_wheel_down" and 1 or -1
		if not self.m_ActiveObject then return end
		self.m_Selected = math.max ( 1, math.min ( self.m_Selected + upOrDown, #self.m_Events[getElementModel(self.m_ActiveObject)]))
		
		self:refreshRenderTarget()
	end
end

function FireVehicle:refreshRenderTarget()
	dxSetRenderTarget(self.m_RenderTarget, true)
	
	local model = getElementModel(self.m_ActiveObject)
	
	local sizePerItem = screenHeight*0.2 / # self.m_Events[model]
	
	for i = 0, sizePerItem - 1, 1 do
		if self.m_Selected-1 ~= i then
			dxDrawRectangle(0, sizePerItem * i, screenWidth*.2, sizePerItem - 2, tocolor(30,30,30,200))
		else
			dxDrawRectangle(0, sizePerItem * i, screenWidth*.2, sizePerItem - 2, tocolor(125,30,30,200))
		end
		local nick = ""
		if self.m_Events[model] and self.m_Events[model][i+1] and self.m_Events[model][i+1].Name then
			nick = self.m_Events[model][i+1].Name
			if self.m_Events[model][i+1].ElementData and #self.m_Events[model][i+1].ElementData > 0 then
				local elementData = {}
				for key, value in ipairs(self.m_Events[model][i+1].ElementData) do
					table.insert(elementData, getElementData(self.m_ActiveObject, value))
				end
				nick = nick:format(unpack(elementData))
			end
		end
		dxDrawText( nick, 0, sizePerItem * i, screenWidth*.2, sizePerItem * i + (sizePerItem - 2), tocolor(255,255,255), 1.5, "default-bold", "center", "center")
	end
	
	
	
	dxSetRenderTarget()
end

function FireVehicle:Event_ElementStreamIn()
	if source and isElement(source) and getElementData(source,"Fireladder") then
		setElementCollidableWith(source, getElementData(source,"Fireladder"), false)
	end
	if source and isElement(source) and getElementData(source,"isUnbreakable") then
		setObjectBreakable(source, false)
	end
end

function FireVehicle:draw()


	if not getPedOccupiedVehicle(localPlayer) and getElementData(localPlayer,"Fraktion") == 9 then
		local count, currentrange, newveh = 0, 6.5, false
		-- Search the nearest vehicle
		for _, vehicle in ipairs (getElementsByType("vehicle", resourceRoot, true)) do
			if getElementData(vehicle,"Firefighter") then
				if getDistanceBetweenPoints3D(vehicle:getPosition(), localPlayer:getPosition()) < currentrange then
					currentrange = getDistanceBetweenPoints3D(vehicle:getPosition(), localPlayer:getPosition())
					newveh       = vehicle
				end
			end
		end
		-- Set the active vehicle
		if newveh then
			if newveh ~= self.m_ActiveObject then
				self.m_Selected = 1
				self.m_ActiveObject = newveh
				self:refreshRenderTarget()
			end
			self.m_ActiveObject = newveh
			local sX, sY = getScreenFromWorldPosition(self.m_ActiveObject:getPosition())
			if sX and sY then
				--local model = getElementModel(self.m_ActiveObject)
				--dxDrawRectangle(sX - screenWidth*.2/2 , sY - screenHeight*.2/2 + (screenHeight*0.2 / # FireVehicle.ACTION_LIST[model]) * (self.m_Selected-1), screenWidth*0.2, screenHeight*0.2 / # FireVehicle.ACTION_LIST[model], tocolor( 125, 125, 125, 125))
				dxDrawImage(sX - screenWidth*.2/2, sY - screenHeight*.2/2, screenWidth*0.2, screenHeight*0.2, self.m_RenderTarget) 				
			end
		else
			self.m_ActiveObject = false
		end
	end
end

--[[
addEventHandler("onClientRender", root,
	function ()
		local infos = dxGetStatus()
		
		local text = ""
		
		for key, value in pairs(infos) do
			text = ("%s%s : %s \n"):format(text, key, tostring(value))
		end
		
		dxDrawText(text, 50, 100)
	end
, true, "high+999999")]]