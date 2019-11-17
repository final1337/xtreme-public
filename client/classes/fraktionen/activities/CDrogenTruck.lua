Drogentruck = inherit(ActivityBase)
inherit(Singleton, Drogentruck)

addEvent("DT:openGUI", true)

function Drogentruck:constructor()
	ActivityBase.constructor(self, name, id, abbreviation)
	
	self.m_Window = GUIWindow:new(screenWidth/2 - screenWidth/8, screenHeight/2 - screenHeight/8, screenWidth*0.25, screenHeight*0.25, "Drogentruck", true)
	self.m_Window:setColor(50,50,50)
	
	--self.m_Background = GUIRectangle:new(0, screenHeight*0.03, screenWidth/4, screenHeight/4 - screenHeight*0.03, self.m_Window)
	--self.m_Background:setColor(75,75,75)

	self.m_DrugStorageFont = GUILabel:new("Drogen im Depot: 5000 Twizzla", screenWidth*0.01, screenHeight*0.05, screenWidth*0.21, screenHeight*0.01, self.m_Window)
	self.m_DrugStorageFont:setFont("default-bold"):setAlignX("left"):setAlignY("top")

	self.m_FactionStorageFont = GUILabel:new("Fraktionskasse: 2.000.000 €", screenWidth*0.01, screenHeight*0.07, screenWidth*0.21, screenHeight*0.01, self.m_Window)
	self.m_FactionStorageFont:setFont("default-bold"):setAlignX("left"):setAlignY("top")

	GUILabel:new("Anzahl der Drogen:", screenWidth*0.01, screenHeight*0.11, screenWidth*0.21, screenHeight*0.01, self.m_Window):setFont("default-bold"):setAlignX("left"):setAlignY("top")
	
	self.m_DrugEdit = GUIEditbox:new(screenWidth * 0.01, screenHeight*0.135, screenWidth*0.23, screenHeight*0.03, self.m_Window)
	self.m_DrugEdit:setShadowText("Anzahl der Drogen, welche transportiert werden sollen.")
	
	self.m_AcceptButton = GUIClassicButton:new("Drogentruck starten", screenWidth * 0.01, screenHeight*0.2, screenWidth*0.23, screenHeight*0.03, self.m_Window )
	
	self.m_AcceptButton.onLeftUp = bind(self.acceptButtonClick, self)
	
	self.m_InfoFont = GUILabel:new("Weitere Informationen?", screenWidth*0.01, screenHeight*0.11, screenWidth*0.23, screenHeight*0.02, self.m_Window):setFont("default-bold"):setAlignX("right"):setAlignY("top")
	
	self.m_InfoBox = GUIWindow:new(screenWidth/2 + screenWidth/8, screenHeight/2 - screenHeight/8, screenWidth*0.16, screenHeight*0.16)
	self.m_InfoBox:setColor(0,0,0,150)
	
	self.m_InfoBoxFont = GUILabel:new("", screenWidth*0.005, screenHeight*0.01, screenWidth*0.15, screenHeight*0.15, self.m_InfoBox)
	self.m_InfoBoxFont:setAlignX("left"):setAlignY("top"):setClip(true):setWordBreak(true):setFont("default-bold")
	
	self.m_InfoBoxFont:setText("Hinweiß: Hier könnt ihr einen Drogentruck starten. Der Drogentruck muss in eure Base geliefert werden. Beim Start werden 1€ pro 3g aus der Fraktionskasse genommen. Bei erfolgreicher Abgabe erhält die Fraktion 1,5€ pro 3g in die Fraktionskasse + einen Bonus für den Fahrer.")
	
	local r,g,b = unpack(XTREAM_ORANGE)
	
	self.m_InfoBox:setVisible(false)
	
	self.m_InfoFont.onHoverStart = function (font) font:setColor(r,g,b) font:sthChanged() self.m_InfoBox:setVisible(true) end
	self.m_InfoFont.onHoverStop = function (font) font:setColor(255,255,255) font:sthChanged() self.m_InfoBox:setVisible(false) end

	
	self.m_Window:setVisible(false)
	
	self.m_Window:getCloseButton().onLeftUp = function ()
		self.m_Window:setVisible(false)
		setTimer(function () setElementData(localPlayer,"Clicked", false)
		showCursor(false) end, 500, 1)
	end
	
	-- DEBUG
	
	self.m_CountDrugs = 0
	
	addEventHandler("DT:openGUI", root, bind(self.openDTwindow, self))
	
	addEventHandler("onPlayerWasted", root, function ()
		self.m_Window:setVisible(false)
		setElementData(localPlayer,"Clicked", false)
		showCursor(false)
	end)
end

function Drogentruck:acceptButtonClick()
	local drugs = self.m_DrugEdit:getText()
	
	if drugs:len() > 0 and tonumber(drugs) then
		triggerServerEvent("DT:requestStart", resourceRoot, tonumber(drugs))
		self.m_Window:getCloseButton().onLeftUp(self)
	end
end


function Drogentruck:openDTwindow(countDrugs, fraktionKasse)
	self.m_CountDrugs = countDrugs
	self.m_DrugStorageFont:setText("Drogen im Depot: ".. countDrugs)
	self.m_FactionStorageFont:setText("Fraktionskasse: ".. fraktionKasse)
	setElementData(localPlayer,"Clicked", true)	
	self.m_Window:setVisible(true)
	showCursor(true)
end