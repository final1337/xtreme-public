TrainingGroundGUI = inherit(Singleton)

TrainingGroundGUI.MAX_FIRES = 20
TrainingGroundGUI.MAX_TREES = 12
TrainingGroundGUI.MAX_VEHICLES = 6

TrainingGroundGUI.CUSTOM_EVENTS = {
	[1] = "Kleiner Vekehrsunfall",
	[2] = "Großer Vekehrsunfall",
	[3] = "Baumsturz",
	[4] = "Großbrand",
	[5] = "Kleinbrand",
	[6] = "Leere Fläche",
}

addEvent("XTM:TrainingGroundGUI:YesNoHandler", true)

TrainingGroundGUI.COOLDOWN = 1000*30 -- in ms

function TrainingGroundGUI:constructor()

	self.m_LastTimeUsed = 0

	self.m_Window = GUIWindow:new( screenWidth*0.7, screenHeight * 0.2, screenWidth*0.2, screenHeight*0.6, "Xtream - Feuerwehrtestgelände", true )

	local w,h = self.m_Window:getWidth(), self.m_Window:getHeight()

	self.m_BackgroundRectangle = GUIRectangle:new(w*.05, h*.075, w*.9, h*.9, self.m_Window)
	self.m_BackgroundRectangle:setColor(0,0,0, 150)

	self.m_FireOption = {}

	self.m_FireAmount = 0

	self.m_FireOption.DescribeFont = GUIFont:new("Feueranzahl: 0",w*0.075, h*0.1, w*0.4, h*0.05, self.m_Window)
	self.m_FireOption.DescribeFont:setAlignX("left"):setAlignY("top"):setFont("default-bold")
	self.m_FireOption.Slider = GUIHorizontalScrollbar:new(w*0.075, h*0.15, w*0.85, h*0.05, self.m_Window)
	self.m_FireOption.Slider.onGUIHorizontalScrollbarChange = function (_, progress)
		self.m_FireAmount = math.floor ( (progress * TrainingGroundGUI.MAX_FIRES) + 0.5)
		self.m_FireOption.DescribeFont:setText("Feueranzahl: "..self.m_FireAmount)
	end

	self.m_TreeOption = {}

	self.m_TreeAmount = 0

	self.m_TreeOption.DescribeFont = GUIFont:new("Baumstammanzahl: 0",w*0.075, h*0.25, w*0.4, h*0.05, self.m_Window)
	self.m_TreeOption.DescribeFont:setAlignX("left"):setAlignY("top"):setFont("default-bold")
	self.m_TreeOption.Slider = GUIHorizontalScrollbar:new(w*0.075, h*0.3, w*0.85, h*0.05, self.m_Window)
	self.m_TreeOption.Slider.onGUIHorizontalScrollbarChange = function (_, progress)
		self.m_TreeAmount = math.floor ( (progress * TrainingGroundGUI.MAX_TREES) + 0.5)
		self.m_TreeOption.DescribeFont:setText("Baumstammanzahl: "..self.m_TreeAmount)
	end

	self.m_VehicleOption = {}

	self.m_VehicleAmount = 0

	self.m_VehicleOption.DescribeFont = GUIFont:new("Autos: 0",w*0.075, h*0.4, w*0.4, h*0.05, self.m_Window)
	self.m_VehicleOption.DescribeFont:setAlignX("left"):setAlignY("top"):setFont("default-bold")
	self.m_VehicleOption.Slider = GUIHorizontalScrollbar:new(w*0.075, h*0.45, w*0.85, h*0.05, self.m_Window)
	self.m_VehicleOption.Slider.onGUIHorizontalScrollbarChange = function (_, progress)
		self.m_VehicleAmount = math.floor ( (progress * TrainingGroundGUI.MAX_VEHICLES) + 0.5)
		self.m_VehicleOption.DescribeFont:setText("Autos: "..self.m_VehicleAmount)
	end


	GUIRectangle:new(w*0.075 - 1, h*.55 - 1, w*0.85 + 2, h*0.25 + 2, self.m_Window):setColor(0,0,0)
	self.m_ScenarioList = GUIGridList:new(w*0.075, h*.55, w*0.85, h*0.25, self.m_Window)
	self.m_ScenarioList:setColor(75,75,75)
	self.m_ScenarioList:addColumn("", screenWidth*.01)
	self.m_ScenarioList:addColumn("Szenarienname", screenWidth*.5)
	local temp = self.m_ScenarioList:addEntry({"Szenarienname", "Custom"})
	temp.NoSelectionRow = true
	temp:setBackgroundColor(55,55,55)
	table.insert(self.m_ScenarioList.m_Selected, temp)
	temp:setSelectionStatus(true)

	for key, value in ipairs (TrainingGroundGUI.CUSTOM_EVENTS) do
		local temp = self.m_ScenarioList:addEntry({"Szenarienname", value})
		temp.Id = key
		temp:setBackgroundColor(55,55,55)
	end

	self.m_AcceptAllButton = XtreamButton:new(w*0.1, h*0.85, w*0.8, h*0.1, "Erstelle Szenario", self.m_Window)
	self.m_AcceptAllButton.onLeftClick = bind(self.sendObjects, self)


	self.m_Window.m_CloseButton.onLeftClick = function ()
		self.m_Window:setVisible(false)
		showCursor(false)
		setElementData(localPlayer, "Clicked", false)
	end

	self.m_Window:setVisible( false )

	self.m_ActivateMarker = Marker(-2596.3671875,676.4921875,26.8125, "cylinder", 1.2, 125, 0, 0, 125)

	addEventHandler("onClientMarkerHit", self.m_ActivateMarker, 
		function (hitElement, matchingDimension)
			if hitElement == localPlayer then
				if hitElement:getType() == "player" and matchingDimension and getElementData(localPlayer,"Fraktion") == 10 and getElementData(localPlayer, "Rank") >= 3  then
					self.m_Window:setVisible(true)
					showCursor(true)
					setElementData(localPlayer, "Clicked", true)
				else
					outputChatBox("Dieses Testgelände ist nur für die Feuerwehr!", 200, 0, 0)
				end
			end
		end
	)

	addEventHandler("XTM:TrainingGroundGUI:YesNoHandler", root, bind(self.handlerAccept, self))
end

function TrainingGroundGUI:handlerAccept(positiveAnswer)
	if positiveAnswer then
		if self.m_CurrentSelectedItem.NoSelectionRow then	
			triggerServerEvent("XTM:FF:trainingGroundInit", resourceRoot, { FireAmount = self.m_FireAmount, TreeAmount = self.m_TreeAmount, VehicleAmount = self.m_VehicleAmount}, true)
		else
			triggerServerEvent("XTM:FF:trainingGroundInit", resourceRoot, self.m_CurrentSelectedItem.Id, false)
		end
		self.m_LastTimeUsed = getTickCount()			
	else
		return
	end
end


function TrainingGroundGUI:sendObjects()
	if self.m_LastTimeUsed + TrainingGroundGUI.COOLDOWN <= getTickCount () then
		local currentSelectedItem = self.m_ScenarioList:getSelectedItems()
		if currentSelectedItem and #currentSelectedItem > 0 then
			currentSelectedItem = currentSelectedItem[1]
			-- Setup the custom trigger
			self.m_CurrentSelectedItem = currentSelectedItem
			self.m_Window:setVisible(false)
			showCursor(false)
			setElementData(localPlayer, "Clicked", false)			
			if not self.m_CurrentSelectedItem.NoSelectionRow then
				BinaryQuery:getSingleton():start("Wollen sie wirklich einen ".. TrainingGroundGUI.CUSTOM_EVENTS[self.m_CurrentSelectedItem.Id] .." starten?",
				 "Natürlich!", "Nein, nicht wirklich.", "XTM:TrainingGroundGUI:YesNoHandler", true)
			else
				BinaryQuery:getSingleton():start("Wollen sie wirklich einen benutzerdefinierten Einsatz starten?",
				 "Natürlich!", "Nein, nicht wirklich.", "XTM:TrainingGroundGUI:YesNoHandler", true)
			end
		end
	else
		local diffBetweenStates = ( self.m_LastTimeUsed + TrainingGroundGUI.COOLDOWN ) - getTickCount()
		outputChatBox(("Derzeit darfst du keinen weiteren Einsatz starten.\nWieder verfügbar in %s Sekunden!"):format(math.floor(diffBetweenStates/1000)), 200, 0, 0)
	end
end
