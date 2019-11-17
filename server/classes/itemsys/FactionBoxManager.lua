FactionBoxManager = inherit(Singleton)


function FactionBoxManager:constructor()
    self.m_FactionBox = {}

	self:initVehicles()
	
	addEventHandler("onResourceStop", resourceRoot, bind(self.saveAllVehicles, self))
end

function FactionBoxManager:getVehicles()
    return self.m_FactionBox
end

function FactionBoxManager:deleteVehicles()
    for key, value in ipairs(self.m_FactionBox) do
        -- PogChamp auch bekannt als Kappadokien
    end
end


-- // TODO: do not load the items at the beginning -> they are now getting loaded when the vehicle get opened first
function FactionBoxManager:initVehicles()
    local query = dbQuery(newDBHandler, "SELECT * FROM factionbox_general")
    local results = dbPoll(query, -1)

    if not results then return end

    local box

    for k, v in ipairs(results) do
        local veh = Element("factionBox")
        veh:setDimension(0)
        box = veh:initBox(v.Id, v.model, v.posX, v.posY, v.posZ, v.rotX, v.rotY, v.rotZ, v.Faction)
        veh.Id = v.Id
        box.Parent = veh
        veh.Storage = {[5] = ElementStorage:new(5, veh)}
        veh.LastInteraction = nil      
        veh.Faction = v.Faction  
		self:initVehicle(box)
		self:loadItems(box)
        table.insert(self.m_FactionBox, veh)
    end
end 

function FactionBoxManager:initVehicle(veh)
end 

function FactionBoxManager:getFactionBoxes(faction)
    local tbl = {}
    for key, value in ipairs(self.m_FactionBox) do
        if value.Faction == faction then
            table.insert(tbl, value)
        end
    end
    return tbl
end

function FactionBoxManager:loadItems(temp)

    local vehicle = temp.Parent

	local query = dbQuery(newDBHandler,"SELECT * FROM inventory WHERE owner = ? AND elementType = ?", vehicle.Id, vehicle:getType())
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
			vehicle.Storage[tempItemIds[id][1]]:initItem(tempItemIds[id][2], v["uid"], v["itemId"], v["owner"], v["creator"],
													v["gift"], v["amount"], v["flags"], v["conditionflags"], v["durability"],
													v["played"], v["specialtext"])
		end
	end
	-- Garbage collector
	tempItemIds = nil     
end

function FactionBoxManager:saveAllVehicles()
	for key, value in pairs(self.m_FactionBox) do
		--// Just save the vehicles which got interacted with
		if value.LastInteraction ~= nil then
			value.Storage[5]:delete()
		end
	end
end

function FactionBoxManager:destructor()

end
