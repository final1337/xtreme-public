Player = inherit(Object)

registerElementClass("player", Player)

function Player:constructor()
	-- DatabasePlayer.constructor(self)

	self.m_CurrentLobby = false
	self.m_SelectedIter = 0
	self.m_SelectedItem = false
	self.m_LogId = false
	self.m_LoggedIn = false
	self.m_Storages = {}
	self.m_Groups   = {}
	self.m_Data = {}
	self.m_CurrentDownloads = {}
	self.m_LastVisits = {}
	self.m_SelectedStorages = {}

	self.m_LastSwitch = 0

	self.m_SwitchBindNext = bind(self.Action_FastSelection, self, 1)
	self.m_SwitchBindPrevious = bind(self.Action_FastSelection, self, -1)	
	self.Bind_OnPlayerUse = bind(self.Bind_OnPlayerUse, self)

	self.Bind_TurnEngine = bind(VehicleManager.Action_Engine, vehiclemanager, self)
	self.Bind_TurnLights = bind(VehicleManager.Action_Lights, vehiclemanager, self)
	
	self.Bind_OnPlayerWeaponSwitch = bind(self.Event_WeaponSwitch, self)
end

function Player:addSelectedStorage(storage)
	if not self:isSelectedStorage(storage) then
		table.insert(self.m_SelectedStorages, storage)
	end
end

function Player:Event_WeaponSwitch(previous,current)
	if getTickCount() >= self.m_LastSwitch + 100 then
		self:Action_FastSelection(-1)
	end
end

function Player:leaveVehicle()
	local veh = getPedOccupiedVehicle(self);
	if(isElement(veh))then
		if(getPedOccupiedVehicleSeat(self) == 0)then
			setElementVelocity(veh,0,0,0);
		end
		setControlState(self,"enter_exit",false);
		setTimer(removePedFromVehicle,750,1,self);
		setTimer(setControlState,125,1,self,"enter_exit",false);
		setTimer(setControlState,125,1,self,"enter_exit",true);
		setTimer(setControlState,700,1,self,"enter_exit",false);
	end
end


function Player:init()
	-- Autohaus.loadVehicles(self:getName())

	bindKey(self, "h", "up", function ()
		if BreathingEquipment:getSingleton() then
			BreathingEquipment:getSingleton():equip(self)
		end
	end)	
end

function Player:Action_FastSelection(amount)
	self.m_LastSwitch = getTickCount()
	storagemanager:fastSwitch(self, amount, true)
end

function Player:loadItems()

	-- Generate storages
	self.m_Storages[1] = ElementStorage:new(1, self) -- Default inventory
	self.m_Storages[2] = ElementStorage:new(2, self) -- Fast selection
	self.m_Storages[3] = ElementStorage:new(3, self) -- bank storage
	self.m_Storages[4] = ElementStorage:new(4, self) -- mail storage
	self.m_Storages[9] = ElementStorage:new(9, self) -- weapon storage
	---

	-- fill the storages
	local query = dbQuery(newDBHandler,"SELECT * FROM inventory WHERE owner = ? AND serverId = ? AND elementType = ?", self:getId(), 1, self:getType())
	local results = dbPoll(query, -1)

	local tempItemIds = {}
	local fetchString = ""

	if #results == 0 then return end
	for k, v in ipairs(results) do
		local inv, itemId = tonumber(v["inventory"]), v["item"]

		tempItemIds[itemId] = {inv, v["slot"]}


		if #tostring(fetchString) == 0 then
			fetchString = ("\"%s\""):format(itemId)
		else
			fetchString = ("%s, \"%s\""):format(fetchString, itemId)
		end
	end


	fetchString = ("(%s)"):format(fetchString)

	query = dbQuery(newDBHandler, "SELECT * FROM item_instance WHERE uid IN ".. fetchString)
	results = dbPoll(query, -1)

	for k, v in ipairs(results) do
		local id = v["uid"]
		if tempItemIds[id] then
			self.m_Storages[tempItemIds[id][1]]:initItem(tempItemIds[id][2], v["uid"], v["itemId"], v["owner"], v["creator"],
													v["gift"], v["amount"], v["flags"], v["conditionflags"], v["durability"],
													v["played"], v["specialtext"])
		end
	end
	-- Garbage collector
	tempItemIds = nil
end

function Player:loadReceipes()
	local query = db:query("SELECT * FROM crafting_player WHERE playerId=?", self:getId())
	local result = db:poll(query, - 1)

	if #result == 0 then
		db:exec("INSERT INTO crafting_player (playerId, knownReceipes, craftingSkill) VALUES (?,?,?)", self:getId(), toJSON({}), 1)
		result = {
			[1] = {
				knownReceipes = toJSON({}),
				craftingSkill = 1
			}
		}
	end

	self:setData("CraftingSkill", result[1].craftingSkill)
	
	local receipes = {}

	for key, value in pairs(fromJSON(result[1].knownReceipes)) do
		receipes[tonumber(value)] = true
	end

	self:setData("KnownReceipes", receipes)

	-- Start receipes
	self:learnReceipt(1)
	self:learnReceipt(2)
	self:learnReceipt(8)
	self:learnReceipt(7)
	self:learnReceipt(9)

end

function Player:getSelectedStorages() return self.m_SelectedStorages end

function Player:removeSelectedStorages()
	for key, value in ipairs(self.m_SelectedStorages) do
		value:removeInteractingPlayer(self)
	end
end

function Player:isSelectedStorage(storage)
	for key, value in ipairs(self.m_SelectedStorages) do
		if value == storage then
			return true
		end
	end
	return false
end

function Player:removeSelectedStorage(storage)
	for key, value in ipairs(self.m_SelectedStorages) do
		if value == storage then
			table.remove(self.m_SelectedStorages, key)
			return
		end
	end
end

function Player:addGroup(group) self.m_Groups[group] = true end
function Player:removeGroup(group) self.m_Groups[group] = false end
function Player:getGroups() return self.m_Groups end
function Player:getLastVisits() return self.m_LastVisits end
function Player:getLobby() return self.m_CurrentLobby end

function Player:setLobby(lobby, entry) 
	self.m_CurrentLobby = lobby 
	if lobby ~= nil or lobby ~= false then
		self:setData("Lobby_Category", nil)
		self:setData("Lobby_Entry", nil)
	else
		self:setData("Lobby_Category", lobby:getCategory())
		self:setData("Lobby_Entry", entry)
	end
end

function Player:giveMoney(amount)
	self:setData("Bankgeld", self:getData("Bankgeld") + amount)
end

function Player:takeMoney(amount)
	self:setData("Bankgeld", self:getData("Bankgeld") - amount)
end

function Player:giveCash(amount)
	self:setData("Geld", self:getData("Geld") + amount)
end

function Player:takeCash(amount)
	self:setData("Geld", self:getData("Geld") - amount)
end

function Player:addBonus(amount)
	self:setData("Bonus", self:getData("Bonus") + amount)
end

function Player:subBonus(amount)
	self:setData("Bonus", math.max(0, self:getData("Bonus") - amount) )
end


function Player:getBonus(amount)
	return self:getData("Bonus")
end

function Player:getId()
	return self.m_LogId or getElementData(self,"Id")
end

function Player:setId(pId)
	pId = tonumber(pId)
	setElementData(self,"Id", pId)
	self.m_LogId = pId
end

function Player:getVehicles()
	return vehiclemanager:getPlayerVehicles(self:getId())
end

function Player:xtremePastLogin()
	Player.Existing[self:getId()] = self
	self:loadItems()
	self:loadReceipes()
	vehiclemanager:loadPlayerVehicle(self)
	bindKey(self, "aim_weapon", "down", self.Bind_OnPlayerUse)
	bindKey(self, "next_weapon", "down", self.m_SwitchBindNext)
	bindKey(self, "previous_weapon", "down", self.m_SwitchBindPrevious)
	-- addEventHandler("onPlayerWeaponFire", self, self.Bind_OnPlayerWeaponFire)	
	-- addEventHandler("onPlayerWeaponSwitch", self, self.Bind_OnPlayerWeaponSwitch)
	-- addEventHandler("onPlayerWeaponFire", self, self.Bind_OnPlayerWeaponFire)	
	bindKey(self,"x","down",self.Bind_TurnEngine)
	bindKey(self,"l","down",self.Bind_TurnLights)	
end

function Player:getTotalItemAmount(itemId)
	local amount = 0
	for key, value in pairs(self.m_Storages) do	
		amount = amount + value:getItemAmount(itemId)
	end
	return amount
end

function Player:takeItemAmount(itemId, lossAmount)
	local itemType, amount, storages, lossAmount = itemId, 0, {}, lossAmount
	for key, value in pairs(self:getStorages()) do
		amount = amount + value:getItemAmount(itemId)
		table.insert(storages, value)
		-- we already got enough, so end the for-loop and continue with the decrementation of the items
		if amount >= lossAmount then
			break
		end
	end
	if amount >= lossAmount then
		for key, value in ipairs(storages) do
			local storageAmount = value:getItemAmount(itemId)
			if lossAmount ~= 0 then
				if storageAmount - lossAmount > 0 then
					value:takeItemAmount(itemId, lossAmount)
					lossAmount = 0
					break
				else
					value:takeItemAmount(itemId, storageAmount)
					lossAmount = lossAmount - storageAmount
				end
			end
		end
		return true
	end
	return false
end

function Player:pastLogin(loginId)
	self:setId(loginId) -- Set databaseentry for database-handling etc
	self.m_LoggedIn = true
	self:loadData()
	self:triggerEvent("RP:Client:OnPastLogin")

	-- Get every player gang

	local query = db:query("SELECT GroupId FROM ??.group_member WHERE Id = ?", db:getPrefix(), self:getId() )
	local results = db:poll(query, -1)

	for key, group in ipairs(results) do
		groupmanager:getGroups()[tonumber(group.GroupId)]:addPlayer(self)
	end

	-- Add last server_visit

	local query = db:query("SELECT * FROM ??.server_last_visit WHERE user_Id = ?", db:getPrefix(), self:getId())
	local results = db:poll(query, -1)

	for key, group in pairs(results) do
		self.m_LastVisits[group.ServerType] = group.ServerId
	end

	-- Lead player to lobby selection ( TODO )

	for key, gamemodes in ipairs(lobbymanager:getLobbys()) do
		for key, lobby in ipairs(gamemodes) do
			self:sendMessage("Lobby: %s, Category: %d, Id: %d - Map: %s - Status: %s", 255, 255, 255, lobby:getDesignation(), lobby:getCategory(), key, lobby:getMap(), lobby:getStatus())
		end
	end
	
end

function Player:inGame()
	return self.m_LoggedIn
end

function Player:setData(key, value, noSync)
	self.m_Data[key] = value
	if not noSync then
		setElementData(self, key, value)
	end
end

function Player:getData(key)
	return getElementData(self,key) or self.m_Data[key]
end

function Player:triggerEvent(event, ...)
	triggerClientEvent(self, event, self, ...)
end

function Player:getLocalization()
	return Localization:getSingleton():getLocalizationPackage(self:getData("Localization"), self)
end

function Player:selectItem(slot)
	if self:getStorages()[2]:getItems()[slot] and self:getStorages()[2]:getItems()[slot]:select(self) then
		self:setData("SelectedItem", {Slot = slot, ItemId = self:getStorages()[2]:getItems()[slot]:getItemId()})
		self.m_SelectedItem = self:getStorages()[2]:getItems()[slot]
		self.m_SelectedIter = slot
		-- self:sendMessage("Item - %s", 255, 255, 255, self.m_SelectedItem:getTemplateItem():getName())
	else
		self:setData("SelectedItem", false)
	end
end

function Player:useSpecificItem(item)
	item:useItem(self)
end

function Player:useItem()
	if self.m_SelectedItem then
		self.m_SelectedItem:useItem(self)

		if self.m_SelectedItem:getAmount() == 0 then
			
		end
	else
		self:sendNotification("Du hast derzeit kein Item selektiert.")
	end
end

function Player:tryToGetLocalization(string)
	local tryResult = loc(string, self)
	if tryResult == string then
		return string
	else
		return tryResult
	end
end

function Player:sendMessage(msg, r, g, b, ...)
	msg = self:tryToGetLocalization(msg)
	outputChatBox((msg):format(...), self, r or 255 ,g or 255,b or 255, true)
end

function Player:sendNotification(msg, r, g, b, ...)
	msg = self:tryToGetLocalization(msg)	
	if not r then
		r, g, b = 255, 255, 255
	end	
	self:triggerEvent("notification", (msg):format(...), r,g,b)
end

function Player:getSelectedItem()
	return self.m_SelectedItem
end

function Player:deselectItem()
	if self:getSelectedItem() then
		-- self:sendMessage("Dein ausgewähltes Item wurde deselektiert.", 200, 200, 200)
		self:setData("SelectedItem", false)
		self:getSelectedItem():deselect(self)
		self.m_SelectedItem = nil
	end
end

function Player:showInventory(player)
	for key, value in ipairs(self.m_Storages) do
		outputChatBox("Storage: ".. value.m_StorageType, player)
		for itemKey, item in pairs(value:getItems()) do
			local msg = ("%sItem (%s)(Slot:%d) with amount (%s)"):format(("\t"):rep(10),item:getTemplateItem():getName(), itemKey, item:getAmount())
		end
	end
end

function Player:playRemoteSound(...)
	self:triggerEvent("PlayRemoteSound", ...)
end

function Player:createRemoteEffect(effectTable, tempFade)
	self:triggerEvent("CreateRemoteEffect", type(effectTable) == "table" and effectTable or {effectTable}, tempFade)
end

function Player:createFxEffect(effectTable)
	self:triggerEvent("CreateRemoteFxEffect", type(effectTable) == "table" and effectTable or {effectTable})
end


function Player:deleteInventarItem(cmd, storageSlot, slot)
	local storage = self.m_Storages[tonumber(storageSlot)]
	storage:destroyItem(tonumber(slot))
end

function Player:addInventory()
	if getElementData(self,"Fraktion") == 1 or getElementData(self,"Fraktion") == 2 or getElementData(self,"Fraktion") == 3 then
		local item = itemmanager:add(1, self:getId(), self:getId(), self:getId(), 30, 0, 0, 100, 0, "none", self.m_Storages[1])
		self.m_Storages[1]:addItem(item)
	end
end

function Player:addItem(itemId, itemAmount, specialText, temporary)
	if self.m_Storages[1]:hasPlace() then
		local item = itemmanager:add(itemId, self:getId(), self:getId(), self:getId(), itemAmount, 0, 0, 100, 0, specialText or "none", self.m_Storages[1], temporary)
		return item, self.m_Storages[1]:addItem(item)
	end
	return false
end

function Player:generateItem(itemId, itemAmount, specialText, temporary, storage)
	if storage:hasPlace() then
		local item = itemmanager:add(itemId, self:getId(), self:getId(), self:getId(), itemAmount, 0, 0, 100, 0, specialText or "none", storage, temporary)
		return item, storage:addItem(item)		
	end
	return false
end

function Player:getStorages() return self.m_Storages end

function Player:getPlayerReceipes()
	return self:getData("KnownReceipes")
end

function Player:learnReceipt(id)
	local receipes = self:getPlayerReceipes()
	receipes[id] = true
	self:setData("KnownReceipes", receipes)
end

-- A lobby is required to get the right inventory

function Player:Bind_OnPlayerUse(player, key, keyState)
	if player:getSelectedItem() and player:getSelectedItem():getTemplateItem():getClass() ~= 1 then
		player:getSelectedItem():useItem(player)
	end
end

-- Player.Get = DatabasePlayer.Get

function Player:destructor()

    for key, value in pairs(self.m_Storages) do
		value:delete()
	end

	if self:getData("CraftingSkill") then
		
		local temp = {}
		for key, value in ipairs(self:getData("KnownReceipes")) do
			table.insert(temp, tonumber(key))
		end

		db:exec("UPDATE crafting_player SET knownReceipes = ?, craftingSkill = ? WHERE playerId = ?", toJSON(temp), self:getData("CraftingSkill"), self:getId())
	end
	--[[for group in pairs(self.m_Groups) do
		group:removePlayer(self)
	end

	-- DatabasePlayer.destructor(self)
	if self:getLobby() then
		self:getLobby():removePlayer(self)
	end]]
	if self:getId() then
		Player.Existing[self:getId()] = nil
	end
end

Player.Existing = {}

function Player.Get(stuff)
    if type(stuff) == "number" then
        if Player.Existing[stuff] then
            return Player.Existing[stuff]
        else
            Player.Existing[stuff] = Player:new(stuff)
            Player.Existing[stuff]:loadData()
            return Player.Existing[stuff]
        end
    elseif type(stuff) == "string" then
        if getPlayerFromName(stuff) then
            return getPlayerFromName(stuff)
        end
    elseif type(stuff) == "userdata" then
        return stuff
    else
        outputDebugString("Invalid type @ Player.Get")
    end
end