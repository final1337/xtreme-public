MediKit = inherit(Singleton)

addEvent("MediKit:getAmount", true)
addEvent("MediKit:acceptOffer", true)
addEvent("MediKit:remoteOffer", true)

MediKit.COMMAND = "medikit"
MediKit.REQUEST_COMMAND = "helpme"
MediKit.PRICE_PER_MEDIKIT = 100
MediKit.OFFER_EXPIRE = 1000*7.5
MediKit.MAX_RANGE = 10

MediKit.BASE_VALUE = 100
MediKit.MONEY_PER_HOURS = 25
MediKit.HOUR_AMOUNT = 500

function MediKit:constructor()
	self.m_CommandBind = bind(self.prepareSell, self)
	self.m_ClickHandler = bind(self.Event_OnElementClicked, self)
	self.m_AmountHandler = bind(self.Event_ReceiveAmount, self)
	self.m_OfferHandler = bind(self.Event_AcceptOffer, self)
	self.m_RemoteOfferHandler = bind(self.Event_RemoteOffer, self)
	self.m_RequestBind = bind(self.requestHelp, self)

	self.m_MedicTarget  = {}
	self.m_IsAbleToHeal = {}
	self.m_HealTimer    = {}
	-- Variables for the requesthelp-command
	self.m_SpamTimer = {}
	self.m_Markers = {}

	addCommandHandler(MediKit.COMMAND, self.m_CommandBind)
	addCommandHandler(MediKit.REQUEST_COMMAND, self.m_RequestBind)
	addEventHandler("onElementClicked", root, self.m_ClickHandler)
	addEventHandler("MediKit:getAmount", root, self.m_AmountHandler)
	addEventHandler("MediKit:acceptOffer", root, self.m_OfferHandler)
	addEventHandler("MediKit:remoteOffer", root, self.m_RemoteOfferHandler)
end

function MediKit:Event_RemoteOffer(player)
	if not client then return end
	self:prepareSell(client)
	if (player:getPosition()-client:getPosition()).length < MediKit.MAX_RANGE and client ~= player then
		client:setData("IsHealing", player)
		client:triggerEvent("XTM:TextQuery", ("Anzahl der Medikits, welche an %s verkauft werden sollen."):format(player:getName()), "Anbieten", "Abbrechen", "MediKit:getAmount")
	end
end

function MediKit:requestHelp(player)
	if not isTimer(self.m_SpamTimer[player]) then
		local rnd = math.random(255)
		local x,y,z = getElementPosition(player)
		local blip = createBlip ( x,y,z, 0, 2, rnd,105, 160 )
		setElementVisibleTo(blip, root, false)
		blip:attach(player)
		for key, value in ipairs (getElementsByType("player")) do
			if getElementData(value, "Fraktion") == 10 and value:getData("medic") then
				setElementVisibleTo(blip, value, true)
				outputChatBox( getPlayerName(player)  .." benötigt medizinische Hilfe!", value, rnd, 105, 160)
			end
		end
		player:sendNotification("Ein Sanitäter wurde informiert und wird sich in ihre Richtung begeben!")
		
		self.m_SpamTimer[getPlayerName(player)] = setTimer( function (afterBlip)
			destroyElement(afterBlip)
		end, 30000, 1, blip )
	end
end

function MediKit:Event_AcceptOffer(answerState)
	if not client then return end
	local medicInfo = client:getData("Healer")
	if answerState then
		if getElementData(client, "Bargeld") >= medicInfo.Price then
			client:takeCash(medicInfo.Price)
			fraktionskassen[10] = fraktionskassen[10] + medicInfo.Amount*MediKit.BASE_VALUE
			client:sendNotification("Sie haben das Angebot akzeptiert und die %d Medikits erhalten.", 255, 255, 255, medicInfo.Amount)
			inventarAddItem(client, "Medikit", medicInfo.Amount)
			if isElement(medicInfo.Medic) then
				medicInfo.Medic:setData("wiederbelebt", medicInfo.Medic:getData("wiederbelebt") + medicInfo.Amount)
				medicInfo.Medic:giveCash(medicInfo.Price - medicInfo.Amount*MediKit.BASE_VALUE)
				medicInfo.Medic:sendNotification(client:getName().." hat ihr Angebot akzeptiert.")
			end
		else
			client:sendNotification("Sie haben leider zu wenig Geld auf der Hand.")
		end
	else
		client:sendNotification("Sie haben das Angebot abgelehnt.")
		if isElement(medicInfo.Medic) then
			medicInfo.Medic:sendNotification("Ihr Angebot an %s wurde von Ihm/Ihr abgelehnt.", 125, 0, 0, client:getName())
		end
	end
	client:setData("IsHealing", false)
end

function MediKit:Event_ReceiveAmount(answerState, text)
	if not client then return end
	if answerState then
		if isElement(client:getData("IsHealing")) then
			if text and tonumber(text) and math.abs(tonumber(text)) > 0 and math.abs(tonumber(text)) < 10000000 then
				local moneyForAllMedikits = self:getPriceForEachKit(client:getData("IsHealing")) * math.abs(tonumber(text))
				client:getData("IsHealing"):setData("Healer", {Medic = client, Price = moneyForAllMedikits, Amount = math.abs(tonumber(text))})
				client:getData("IsHealing"):triggerEvent("XTM:BinaryQuery", ("%s bietet ihnen %d Medikits für %d € an."):format(client:getName(), math.abs(tonumber(text)), moneyForAllMedikits), "Kaufen", "Ablehnen", "MediKit:acceptOffer")
			end
		end
	else
		client:setData("IsHealing", false)
	end
end

function MediKit:getPriceForEachKit(player)
	return MediKit.BASE_VALUE + MediKit.MONEY_PER_HOURS * math.floor(tonumber(player:getData("SpielzeitDB"))/60/MediKit.HOUR_AMOUNT)
end

function MediKit:Event_OnElementClicked(mouseButton, buttonState, player, clickPosX, clickPosY, clickPosZ)
	if getElementType(source) == "player" then
		if self.m_IsAbleToHeal[player] and (player:getPosition()-source:getPosition()).length < MediKit.MAX_RANGE and source ~= player then
			if isTimer(self.m_HealTimer[player]) then
				killTimer(self.m_HealTimer[player])
			end
			self.m_IsAbleToHeal[source] = nil
			player:setData("IsHealing", source)
		
			player:triggerEvent("XTM:TextQuery", ("Anzahl der Medikits, welche an %s verkauft werden sollen."):format(source:getName()), "Anbieten", "Abbrechen", "MediKit:getAmount")
		end
	end
end

function MediKit:prepareSell(player, _, arguments)
	if player:getData("Fraktion") == 10 then
		self.m_IsAbleToHeal[player] = true

		self.m_HealTimer = Timer (function (medic)
			self.m_IsAbleToHeal[medic] = false
		end, MediKit.OFFER_EXPIRE, 1, player)

		player:sendNotification("Sie haben nun 7,5 Sekunden Zeit um einen Spieler anzuhandeln!")
	end
end

function MediKit:destructor()

end