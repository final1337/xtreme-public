Core = inherit(Object)

-- TODO: deactivate when real server is online
DEBUG = true

function Core:constructor()
	outputDebugString("Loading serverside-core...")

	core = self

	db = Database:new()
	Localization:new()

	itemmanager = ItemManager:new()
	storagesettings = StorageSettings:new()

	if not getResourceFromName("XTM_LOGS") then
		createResource("XTM_LOGS")
	end

	self:initLogs()

	storagemanager = StorageManager:new()

	-- Load this as last classes
	downloadmanager = DownloadManager:new()
	carparkmanager = CarparkManager:new()	
	vehiclemanager = VehicleManager:new()
	tuning = Tuning:new()
	trademanager = TradeManager:new()
	crafting = Crafting:new()
	ticketmanager = TicketManager:new()
	factionboxmanager = FactionBoxManager:new()

	breathingequipment = BreathingEquipment:new()
	firemanager = FireManager:new()
	BreakAbleObjects = DamageObject:new()
	activitymanager = ActivityManager:new()
	plantsystem = PlantSystem:new()
	TrainingGround:new()
	firefightercentral = FireFighterCentral:new()
	MediKit:new()
	
	PlayerManager:new()
	
	outputDebugString("Serverside-Core has been loaded.")
end

function Core:initLogs()

	--LogLog = Log:new("Log")
	--LogLog:prepareString("%s")

	teleportToLog = Log:new("TeleportTo")
	teleportToLog:prepareString("%s hat sich zu %s teleportiert.")
	--teleportToLog:prepareString("Admin", "Player")

	teleportGetLog = Log:new("TeleportGet")
	teleportGetLog:prepareString("%s hat %s zu sich teleportiert.")
	--teleportGetLog:prepareString("Admin", "Spieler")

	damageLog = Log:new("Damage")
	damageLog:prepareString("%s hat %s mit %d %d Schaden an %d verursacht.")
	--damageLog:prepareString("Attacker", "Target", "Weapon", "Loss", "part")

	killLog = Log:new("Kill")
	killLog:prepareString("%s hat %s mit Waffe %d im Gebiet %s umgebracht.")
	--killLog:prepareString("Killer", "Victim", "Weapon", "Area")

	banLog = Log:new("Ban")
	banLog:prepareString("%s hat %s gebannt! Grund: %s Zeit: %s")
	--banLog:prepareString("Admin", "Player", "Reason", "Time")

	payLog = Log:new ("Pay")
	payLog:prepareString("%s hat %s %d€ gegeben.")
	--payLog:prepareString("Player", "Target", "Amount")

	transactionLog = Log:new ("BankTransfer")
	transactionLog:prepareString("%s hat %s %d€ überwiesen. Verwendungszweck: %s")
	--transactionLog:prepareString("Player", "Target", "Amount", "Reason")

	withdrawLog = Log:new ("BankAus")
	withdrawLog:prepareString("%s hat %d€ abgehoben.")
	--withdrawLog:prepareString("Player", "Amount")

	depositLog = Log:new ("BankEin")
	depositLog:prepareString("%s hat %d€ eingezahlt.")
	--depositLog:prepareString("Player", "Amount")

	vehBuyLog = Log:new ("VehBuy")
	vehBuyLog:prepareString("%s hat ein Fahrzeug mit der ID: %d für %d€ gekauft.")
	--vehBuyLog:prepareString("Player", "Model", "Price")

	vehSellLog = Log:new ("VehSell")
	vehSellLog:prepareString("%s hat ein Fahrzeug mit der ID: %d für %d€ verkauft")
	--vehSellLog:prepareString("Player", "Model", "Price")

	LevelshopLog = Log:new ("Levelshop")
	LevelshopLog:prepareString("%s hat für %d Punkte eingekauft.")
	--LevelshopLog:prepareString("Player", "Amount")

	frakAbhebenLog = Log:new("FraktionAbheben")
	frakAbhebenLog:prepareString("%s hat %d € von %d abgehoben. - Neuer Stand: %d")
	--frakAbhebenLog:prepareString("Player", "Amount", "Faction", "Current")

	frakEinzahlenLog = Log:new("FraktionEinzahlen")
	frakEinzahlenLog:prepareString("%s hat %d € bei %d eingezahlt. - Neuer Stand: %d")
	--frakEinzahlenLog:prepareString("Player", "Amount", "Faction", "Current")

	healLog = Log:new("Heal")
	healLog:prepareString("%s hat einen Energy Drink benutzt")

	chatLog = Log:new("Chat")
	chatLog:prepareString("%s : %s")

	handyChatLog = Log:new("Chat")
	handyChatLog:prepareString("%s am Handy: %s")

end

function Core:destructor()
	-- delete(lobbymanager)
	
	--stopResource(getResourceFromName("rp_wrapper"))
end