ItemManager = inherit(Singleton)

addEvent("ItemManager:requestAllExitingItems", true)

function ItemManager:constructor()
	self.m_Items = {}
	self.m_Receipes = {}
	self.m_SendItems = {}

	self:load()

	addCommandHandler("reloaditems", bind(self.Command_ReloadItems, self))

	addEventHandler("ItemManager:requestAllExitingItems", resourceRoot, bind(self.Event_RequestAllExitingItems, self))
end

function ItemManager:Event_RequestAllExitingItems()

end

function ItemManager:getCraftingReceipes()
	return self.m_Receipes
end

function ItemManager:getCraftingReceipt(id)
	return self.m_Receipes[id]
end

function ItemManager:reloadConditionsAndScripts()
	-- Load Conditions
	local file = fileOpen("server/classes/itemsys/ItemConditions.lua")
	local conditions = fileRead(file, fileGetSize(file))
	fileClose(file)
	ItemConditions = nil
	loadstring(conditions)()
	-- Load scripts
	file = fileOpen("server/classes/itemsys/ItemScripts.lua")
	local scripts = fileRead(file, fileGetSize(file))
	fileClose(file)
	ItemScripts = nil
	loadstring(scripts)()	
end

function ItemManager:Command_ReloadItems(player)
	if player:getData("Adminlevel") >= 3 then
		outputChatBox("Die Itemdatenbank wird in 5 Sekunden neu geladen..", root, 255, 255, 0)
		-- This just functions as a hotfix, the client doesnt download the script as a new file
		self:reloadConditionsAndScripts()
		--
		self:load()

		Timer(function ()
			downloadmanager:loadMainFiles()
			for key, value in ipairs(getElementsByType("player")) do
				downloadmanager:downloadPackage(value, PROJECT_NAME.."_MAIN")
			end			
			outputChatBox("Die Itemdatenbank wurde neu geladen.", root, 255, 255, 0)
		end, 5000, 1)
	end
end

function ItemManager:load()
	self:deleteOldItems()

	local query = dbQuery(newDBHandler, "SELECT * FROM item_template")
	local results = dbPoll(query, -1)

	local tempSendData = {}

	if results == 0 then return end
	for k, v in ipairs(results) do
		self.m_Items[v["itementry"]] = ItemTemplate:new(v["itementry"], v["class"], v["subclass"], v["nameDE"], v["nameEN"],
										v["displayPicture"], v["quality"], v["flags"], v["conditionFlags"], v["allowedFactions"],
										v["stackable"], v["maxdurability"], v["duration"], v["specialscript"],
										v["descriptionDE"], v["descriptionEN"], v["tradable"], v["illegal"])

		tempSendData[v["itementry"]] = v
	end

	local f;

	if not fileExists("generated/ItemTemplate.json") then
		f = fileCreate("generated/ItemTemplate.json")
	else
		f = fileOpen("generated/ItemTemplate.json")
	end

	fileWrite(f, toJSON(tempSendData))

	fileClose(f)


	local query = db:query("SELECT * FROM crafting_recipes")
	local result = db:poll(query, -1)

	local tempData = {}

	if #result == 0 then return end
	for k, v in ipairs(result) do
		self.m_Receipes[v.receiptId] = CraftingReceipt:new(v.receiptId, v.skillRequired, v.category, v.secret, v.rewardItem, v.rewardAmount, 
                                    v.requiredItem1, v.requiredAmount1, v.requiredItem2, v.requiredAmount2, v.requiredItem3, v.requiredAmount3,
                                    v.requiredItem4, v.requiredAmount4, v.requiredItem5, v.requiredAmount5, v.requiredItem6, v.requiredAmount6)
		tempData[v.receiptId] = v
	end

	if not fileExists("generated/CraftingTemplate.json") then
		f = fileCreate("generated/CraftingTemplate.json")
	else
		f = fileOpen("generated/CraftingTemplate.json")
	end

	fileWrite(f, toJSON(tempData))

	fileClose(f)	

	-- Todo: add better debug message
	-- outputDebugString(math.random(9999).." the amount of items loaded are " .. i)
end

function ItemManager:add(itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext, storage, temporary)
	

	if not self.m_Items[itemId] then return false end

	local uuid, query;
	
	query = dbQuery(newDBHandler, "SELECT uuid();")
	uuid = dbPoll(query, -1)[1]["uuid()"]
		
	if not temporary then

		uuid = uuid:gsub("-", "")
		
		query = dbQuery(newDBHandler, "INSERT INTO item_instance (uid,itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext) VALUES (?,?,?,?,?,?,?,?,?,?,?)"
											, uuid, itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext)
		local result, num_affected_rows, last_insert_id = dbPoll(query, -1)
	end
			
	local itemClass = itemmanager:getItem(itemId):getClass()
	itemClass = Item.Classes[itemClass]

	local item = itemClass:new(uuid, itemId, owner, creator, gift, amount, flags, conditionFlags, durability, played, specialtext, storage)
	item:setTemporary(temporary)
	return item
end

function ItemManager:addItem(itemId, itemAmount, storage, specialText, temporary)
	if storage:hasPlace() then
		local item = itemmanager:add(itemId, 0, 0, 0, itemAmount, 0, 0, 100, 0, specialText or "none", storage, temporary)
		return item, storage:addItem(item)
	end
	return false
end

function ItemManager:getTemplate(itemid)
	return self.m_Items[itemid]
end

function ItemManager:deleteOldItems()
	for key, value in ipairs(self.m_Items) do
		delete(value)
	end
	self.m_Items = {}
	self.m_SendItems = {}
end

function ItemManager:getItem(uid)
	return self.m_Items[uid]
end