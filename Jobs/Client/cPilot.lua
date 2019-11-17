PilotJob = inherit(Singleton)

addEvent("setClipboard", true)
addEventHandler("setClipboard", root, setClipboard)

local screenWidth, screenHeight = guiGetScreenSize()

function PilotJob:constructor()

	self.m_Window = GUIWindow:new(screenWidth/2 - 250, screenHeight/2 - 175, 500, 350, "Flughafen San Fierro", true)
	
	self.m_Window:getTitleLabel():setFont("default-bold")
	
	self.m_Window:setColor(100, 100, 100, 200)
	
	self.m_Accept = GUIClassicButton:new("Mission starten", 50, 235, 400, 35, self.m_Window)
	self.m_Repeat = GUIClassicButton:new("Mission wiederholen", 50, 285, 400, 35, self.m_Window)
	
	self.m_AirCraftGrid = GUIGridList:new(30, 30, 200, 150, self.m_Window)
	self.m_AirCraftGrid:addColumn("", 0.05)
	self.m_AirCraftGrid:addColumn("Typ", 0.5)
	self.m_AirCraftGrid:addColumn("Name", 0.5)
	
	self.m_AirCraftGrid.onGridSelect = bind(self.refillMissionList, self)
	
	self.m_Window:getCloseButton().onInternLeftUp = closeXTRPilotWindow
	
	self.m_AirMissionGrid = GUIGridList:new( 270, 30, 200, 150, self.m_Window)
	self.m_AirMissionGrid:addColumn("", 0.05)
	self.m_AirMissionGrid:addColumn("ID", 0.1)
	self.m_AirMissionGrid:addColumn("Mission", 0.45)

	self.m_ValidAirCraftMissions = {}
	self.m_AirPortMissions = {}
	self.m_LastMission = false
	self.m_LastKind    = false
	self.m_LastModel   = false
	
	self.m_Marker = createMarker(0,0,0,"cylinder",15,125,0,0,0)
	self.m_Blip = createBlip(0,0,0,0,2,255,0,0,0,0,99999)
	
	
	self.m_Accept.onLeftUp = acceptXTRPilotMission
	self.m_Repeat.onLeftUp = repeatXTRPilotMission
	
	addEvent("xtr:pilot:openwindow", true)
	addEventHandler("xtr:pilot:openwindow", root, bind(self.createWindow,self))
	
	addEvent("xtr:pilot:setupJob", true)
	addEventHandler("xtr:pilot:setupJob", root, bind(self.setupJob,self))

	addEvent("xtr:pilot:stopJob", true)
	addEventHandler("xtr:pilot:stopJob", root, bind(self.stopJob,self))	
end

function PilotJob:stopJob()
	setElementAlpha(self.m_Marker,0)
	setBlipColor(self.m_Blip,255,0,0,0)
end

function PilotJob:createWindow(AirPortMissions, ValidAirCraftMissions)
	
	self.m_ValidAirCraftMissions = ValidAirCraftMissions
	self.m_AirPortMissions = AirPortMissions
	
	showCursor(true)
	
	--[[xtmDrawWindow("PilotMenu","window","Flughafen San Fierro",screenWidth/2 - 250, screenHeight/2 - 175, 500, 350, "closeXTRPilotWindow")
	local tbl = {}
	
	for kind, missions in pairs(ValidAirCraftMissions) do
		for modelId, _ in pairs (missions) do
			table.insert(tbl, { PilotJob.ScriptToGerman[kind], getVehicleNameFromModel(modelId) } )
		end
	end
	
	xtmDrawRectangle("PilotMenu","justarectangle",screenWidth/2 - 250, screenHeight/2 - 110, 500, 150,tocolor(255,120,0,50))
	
	xtmDrawButton("PilotMenu","PilotAccept","Mission starten",screenWidth/2- 200,screenHeight/2 + 60 , 400, 35,"acceptXTRPilotMission")
	xtmDrawButton("PilotMenu","PilotRepeat","Mission wiederholen",screenWidth/2- 200,screenHeight/2 + 110 , 400, 35,"repeatXTRPilotMission")
	
	xtmDrawGridlist("PilotMenu","PilotAirCraft",screenWidth/2 - 220, screenHeight /2 - 110, 200, 150,{{"Typ",75},{"Name",125}},tbl,"selectXTRPilotMission")
	
	xtmDrawGridlist("PilotMenu","PilotMissions",screenWidth/2 + 20, screenHeight/2-110, 200, 150, {{"Mission",200}},{})]]
	
	self.m_AirCraftGrid:flush()
	self.m_AirMissionGrid:flush()
	
	for kind, missions in pairs(ValidAirCraftMissions) do
		for modelId, _ in pairs (missions) do
			local row = self.m_AirCraftGrid:addRow()
			row:setValue("Typ", PilotJob.ScriptToGerman[kind])
			row:setValue("Name", getVehicleNameFromModel(modelId))
			--table.insert(tbl, { PilotJob.ScriptToGerman[kind], getVehicleNameFromModel(modelId) } )
		end
	end	
	
	self.m_Window:setVisible(true)
end

function PilotJob:setupJob(coords,dimension,kind,model,mission)
	setElementPosition(self.m_Marker,unpack(coords))
	setElementPosition(self.m_Blip,unpack(coords))
	setElementAlpha(self.m_Marker, 200)
	setBlipColor(self.m_Blip, 255,0,0,255)
	setElementDimension(self.m_Blip,dimension)
	setElementDimension(self.m_Marker,dimension)
	self.m_Window:setVisible(false)
    showCursor(false)
	setTimer(setElementData,100,1,localPlayer,"Clicked",false)	
	
	-- Ermoegliche einfache Wiederholung der letzten Mission
	
	self.m_LastKind = kind
	self.m_LastModel = model
	self.m_LastMission = mission
end

function PilotJob:acceptMission()
	local airCraftRow = self.m_AirCraftGrid:getActiveRow()
	local model = airCraftRow:getColumnValue("Name")
	local airMissionRow = self.m_AirMissionGrid:getActiveRow()
	local missionSelected = tonumber(airMissionRow:getColumnValue("ID"))
	if model and missionSelected then
		triggerServerEvent("xtr:pilot:start", resourceRoot, getVehicleType(getVehicleModelFromName(model)), model, missionSelected)
	end
end

function PilotJob:repeatMission()
	if self.m_LastKind then
		triggerServerEvent("xtr:pilot:start", resourceRoot, self.m_LastKind, self.m_LastModel, self.m_LastMission)
	else
		outputChatBox("Du hast in dieser Sitzung noch keine Mission gestartet.",125,0,0)
	end
end

function PilotJob:refillMissionList()
	local item = self.m_AirCraftGrid:getActiveRow()
	self.m_AirMissionGrid:flush()
	if item then
		local values = item:getValues()
		local modelId = getVehicleModelFromName(values["Name"])
		local vehType = getVehicleType(modelId)
	
		for key, value in pairs (self.m_ValidAirCraftMissions[vehType][modelId]) do
			local row = self.m_AirMissionGrid:addRow()
			local levelreq = self.m_AirPortMissions[vehType][key][4]
			local name = self.m_AirPortMissions[vehType][key][1]
			row:setValue("ID", key)
			row:setValue("Mission", name)
		end
		
		self.m_Window:setVisible(true)
		--xtmDrawGridlist("PilotMenu","PilotMissions",screenWidth/2 + 20, screenHeight/2-110, 200, 150, {{"Id",25},{"Mission",125},{"Level",50}},tbl)
	end
end

function PilotJob:closeWindow()
	self.m_Window:setVisible(false)
    showCursor(false)
end

function closeXTRPilotWindow()
	PilotJob:getSingleton():closeWindow()
end

function selectXTRPilotMission()
	PilotJob:getSingleton():refillMissionList()
end

function acceptXTRPilotMission()
	PilotJob:getSingleton():acceptMission()
end

function repeatXTRPilotMission()
	PilotJob:getSingleton():repeatMission()
end

PilotJob.ScriptToGerman = { ["Automobile"] = "Auto",
  ["Plane"] = "Flugzeug",
  ["Helicopter"] = "Helikopter"
}

PilotJob:new()

