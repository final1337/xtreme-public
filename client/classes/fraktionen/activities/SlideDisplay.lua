SlideDisplay = inherit(Singleton)

addEvent("XTM:Reward:show", true)

local screenWidth, screenHeight = guiGetScreenSize()

SlideDisplay.TIME_FOR_ANIMATION = 1500 -- in ms
SlideDisplay.TIME_FOR_NEXT_ITEM = 5000 -- in ms

function SlideDisplay:constructor()
	self.m_Offset = 0
	self.m_Step   = 0
	self.m_Queue  = {}
	self.m_RenderHandler = bind(self.draw, self)
	
	addEventHandler("XTM:Reward:show", root, bind(self.Event_Reward_Show, self))
end

function SlideDisplay:Event_Reward_Show(events, timeforanmation, timefornextitem)
	if isTimer(self.m_UpdateTimer) then
		-- Add item to the queue
		table.insert ( self.m_Queue, { Events = events, TIME_FOR_ANIMATION = timeforanmation, TIME_FOR_NEXT_ITEM = timefornextitem })
		return
	end
	
	-- Take the default values or other values
	
	self.m_TimeForAnmation   = timeforanmation ~= nil and timeforanmation or SlideDisplay.TIME_FOR_ANIMATION
	self.m_TimeForNextItem   = timefornextitem ~= nil and timefornextitem or SlideDisplay.TIME_FOR_NEXT_ITEM
	
	self.m_EventsCount 		 = #events+1
	self.m_Offset			 = 0
	self.m_Step  			 = 0
	self.m_RenderTarget 	 = dxCreateRenderTarget ( (2+#events)*screenWidth, screenHeight*0.1, true )
	self.m_UpdateTimer  	 = setTimer ( bind( self.updateDisplay, self ), self.m_TimeForNextItem, #events )
	
	dxSetRenderTarget(self.m_RenderTarget, true)
	for i = 0, #events -1, 1 do
		dxDrawRectangle(screenWidth + screenWidth*i, 0, screenWidth, screenHeight * 0.1, tocolor(0,0,0,100) )
		dxDrawText(events[i+1], screenWidth + screenWidth*i, 0, screenWidth*i + screenWidth*2, screenHeight*0.1, tocolor(255,255,255), 3, "default-bold", "center", "center")
	end	
	dxSetRenderTarget()
	
	addEventHandler("onClientRender", root, self.m_RenderHandler)
	
	-- For starting animation
	self:updateDisplay()
end

function SlideDisplay:updateDisplay()
	self.m_Step = self.m_Step + 1
	self.m_Start = getTickCount()
	self.m_EndTime = self.m_Start + SlideDisplay.TIME_FOR_ANIMATION
	setSoundVolume (playSound("client/classes/fraktionen/activities/woosh.wav"), 1)
	--if self.m_Step ~= self.m_EventsCount then
	--	setTimer ( playSound, self.m_TimeForAnmation, 1, self.m_Step%2 == 0 and "fraktionen/activities/buff.wav" or "fraktionen/activities/puff.wav" )
	--end
end

function SlideDisplay:draw()
	if self.m_Step > 0 then
		self.m_Offset = (self.m_Step-1)*screenWidth +  getEasingValue(math.min(1, ( getTickCount () - self.m_Start ) / self.m_TimeForAnmation ),"InQuad") * screenWidth
		if self.m_Step == self.m_EventsCount and math.min(1, ( getTickCount () - self.m_Start ) / self.m_TimeForAnmation ) == 1 then
			removeEventHandler("onClientRender", root, self.m_RenderHandler)
			-- Get next item from the queue, if possible.
			if self.m_Queue[1] then
				self:Event_Reward_Show( self.m_Queue[1].Events, self.m_Queue[1].TIME_FOR_ANIMATION, self.m_Queue[1].TIME_FOR_NEXT_ITEM)
				table.remove(self.m_Queue, 1)
			end
		end
	end
	-- Draw the bar
	dxDrawImageSection (0, screenHeight*0.25, screenWidth, screenHeight*0.1,
						self.m_Offset, 0, screenWidth, screenHeight*0.1,
						self.m_RenderTarget)
end

SlideDisplay:new()