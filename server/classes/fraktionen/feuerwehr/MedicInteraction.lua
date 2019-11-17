MedicInteraction = inherit(Singleton)

function MedicInteraction:constructor()
	self.m_MainLayer = interaction:getDefaultLayer():getChildByName("Faction")

	local f = self.m_MainLayer

	self.m_OfferMedikit = f:addChild("Medikit anbieten"):addCondition(function (element) return getElementHealth(element) > 0 end)

	self.m_OfferMedikit:addCondition(function (element) return localPlayer:getData("Fraktion") == 10 end)

	self.m_OfferMedikit:setFunction(bind(self.offerMedikit, self))


	f = localPlayer:getDefaultInteractionLayer()

	local operation = f:addChild("Einsätze"):addCondition(function (element) return localPlayer:getData("Fraktion") == 10 end)

	operation:setFunction(bind(self.getOverview, self))

	local haupt = operation:addChild("Haupteinsatz neu")
	local neben = operation:addChild("Nebeneinsatz neu")

	haupt:addCondition(function() return localPlayer:getData("Rank") == 5 end)
	neben:addCondition(function() return localPlayer:getData("Rank") == 5 end)


	haupt:setFunction(function () self:newTask("main") end)
	neben:setFunction(function () self:newTask("minor") end)
end

function MedicInteraction:newTask(typ)
	triggerServerEvent("FireFighterCentral:newTask", resourceRoot, typ)
end

function MedicInteraction:getOverview()
	interaction:executeCommandHandler("firefighteroverview")
end

function MedicInteraction:offerMedikit(element)
	if not isElement(element) then return end
	triggerServerEvent("MediKit:remoteOffer", resourceRoot, element)
	interaction:deactivate()
end