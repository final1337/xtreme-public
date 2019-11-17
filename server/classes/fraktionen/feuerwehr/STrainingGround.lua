TrainingGround = inherit(Singleton)

addEvent("XTM:FF:trainingGroundInit", true)

TrainingGround.SCENARIO = {
	[1] = {
		Name = "Kleiner Vekehrsunfall",
		["Fire"] = {
			{-2569.58203125,659.044921875,29.048263549805},
			{-2566.8623046875,658.6591796875,28.957887649536},
			{-2566.2626953125,664.357421875,29.057298660278},
			{-2573.90234375,658.8671875,27.8125},
			{-2566.5107421875,665.8798828125,27.8125},
		},
		["Object"] = {
			
		},
		["BreakAbleObject"] = {

		},
		["Vehicles"] = {
			{405,-2570.7000000,658.0999800,27.8000000,0,0,298.0000000},
			{536,-2565.5000000,658.4000200,27.7000000,0,0,86.0000000},
			{545,-2565.7000000,664.7000100,27.6541600,0,0,127.9950000},
		},
	},
	[2] = {
		Name = "Großer Vekehrsunfall",
		["Fire"] = {
			{-2566.41015625,658.583984375,28.952360153198},
			{-2569.4462890625,658.515625,29.061977386475},
			{-2573.84375,660.046875,30.7024269104},
			{-2576.6796875,662.439453125,31.653337478638},
			{-2568.30859375,668.009765625,31.144021987915},
			{-2563.5244140625,663.1533203125,30.059495925903},
			{-2555.2236328125,657.58203125,29.265266418457},
		},
		["Object"] = {

		},
		["BreakAbleObject"] = {

		},
		["Vehicles"] = {
			{405,-2570.7000000,658.0999800,27.8000000,0,0,298.0000000},
			{536,-2565.5000000,658.4000200,27.7000000,0,0,86.0000000},
			{545,-2554.5000000,658.2000100,27.8000000,0,0,127.9950000},
			{524,-2575.5000000,661.4000200,28.9000000,0,0,244.0000000},
			{455,-2566.0000000,666.2000100,28.4000000,0,0,217.2500000},
		},
	},
	[3] = {
		Name = "Baumsturz",
		["Fire"] = {

		},
		["Object"] = {

		},
		["BreakAbleObject"] = {
			{836,-2573.8994000,658.4003900,28.1000000,0.0000000,0.0000000,0.0000000		},
			{836,-2572.2000000,655.5000000,28.1000000,0.0000000,0.0000000,302.0000000	},
			{846,-2572.3000000,647.5000000,27.6000000,0.0000000,0.0000000,0.0000000	 	},
			{848,-2569.8000000,642.7000100,28.0000000,0.0000000,0.0000000,0.0000000 	},
			{843,-2577.0000000,661.2000100,27.7000000,0.0000000,0.0000000,0.0000000 	},
		},
		["Vehicles"] = {

		},
	},
	[4] = {
		Name = "Großbrand",
		["Fire"] = {
			{-2569.2775878906,651.703125,28.793750762939	},					
			{-2565.9875488281,652.2919921875,28.796068191528},
			{-2578.6015625,659.7705078125,27.8125},
			{-2581.044921875,669.3056640625,27.8125},
			{-2582.8796386719,675.36779785156,28.163227081299},
			{-2566.9560546875,680.1142578125,27.8125},
			{-2566.6982421875,643.9130859375,27.806203842163},
			{-2566.419921875,637.1630859375,27.806203842163},
			{-2569.7170410156,653.3515625,32.522811889648},
			{-2564.1752929688,636.716796875,32.109909057617},
			{-2583.1628417969,671.62463378906,31.485813140869},
			{-2582.5837402344,679.64318847656,31.485214233398},
		},
		["Object"] = {
			{3639,-2569.3000000,656.0000000,31.2000000,0.0000000,0.0000000,296.0000000	},
			{3641,-2568.3999000,637.5000000,29.2000000,0.0000000,0.0000000,26.0000000	},
			{3646,-2575.7000000,676.9000200,29.0000000,0.0000000,0.0000000,82.0000000	},
		},
		["BreakAbleObject"] = {

		},
		["Vehicles"] = {

		},
	},
	[5] = {
		Name = "Kleinbrand",
		["Fire"] = {
			{-2576.142578125,652.072265625,27.8125},
			{-2567.8937988281,652.578125,28.796068191528},
			{-2560.10546875,654.43359375,27.806203842163},
			{-2560.791015625,662.671875,27.8125},
			{-2568.1845703125,663.02734375,27.8125},
			{-2573.5168457031,660.541015625,32.758499145508},
			{-2573.9191894531,655.6904296875,33.265727996826},
			{-2564.6721191406,652.140625,32.098438262939},
		},
		["Object"] = {
			{3639,-2569.3000000,656.0000000,31.2000000,0.0000000,0.0000000,296.0000000},
		},
		["BreakAbleObject"] = {

		},
		["Vehicles"] = {

		},
	},	
	[6] = {
		Name = "Leere Fläche",
		["Fire"] = {

		},
		["Object"] = {

		},
		["BreakAbleObject"] = {

		},
		["Vehicles"] = {

		},
	},				
}

function TrainingGround:constructor()
	self.m_Vehicles 		= {}
	self.m_Fires    		= {}
	self.m_BreakAbleObjects = {}
	self.m_Objects          = {}

	addEventHandler("XTM:FF:trainingGroundInit", root, bind(self.Event_TrainingGroundInit, self))
end

function TrainingGround:deleteCurrentObjects()
	for key, value in ipairs ( self.m_Vehicles ) do
		destroyElement(value)
	end
	for key, value in ipairs( self.m_Objects ) do
		destroyElement(value)
	end
	for key, value in ipairs(self.m_BreakAbleObjects) do
		DamageObject:getSingleton():delete(value.Iterator)
		self.m_BreakAbleObjects[key] = nil
	end
    for key, value in pairs(self.m_Fires) do
        value:delete()
    end

	self.m_Vehicles 		= {}
	self.m_Fires    		= {}
	self.m_BreakAbleObjects = {}
	self.m_Objects          = {}
end
-- -2594.1640625,623.15625,27.8125
function TrainingGround:Event_TrainingGroundInit(content, custom)
	self:deleteCurrentObjects()
	if custom then
		for i = 1, content.FireAmount, 1 do
			table.insert(self.m_Fires, FireManager:getSingleton():addEntity(-2594.16 + math.random ( 35 ), 623.15 + math.random( 50 ), 27.8125, 0, 0))
		end
		for i = 1, content.TreeAmount, 1 do
			table.insert(self.m_BreakAbleObjects, DamageObject:getSingleton():addEntity(848, -2594.16 + math.random ( 35 ), 623.15 + math.random( 50 ), 27.8125, 0, 0, 500, {[9] = true}))
		end
		for i = 1, content.VehicleAmount, 1 do
			local veh = Vehicle(math.random(411, 420), -2594.16 + math.random ( 35 ), 623.15 + math.random( 50 ), 28.8125)
			veh:setLocked(true)
			table.insert(self.m_Vehicles, veh)
		end
	else
		-- Supress wrong triggered scenarioids
		if TrainingGround.SCENARIO[content] then
			for objectType, objects in pairs (TrainingGround.SCENARIO[content]) do
				if objectType == "Fire" then
					for key, value in ipairs (objects) do
						table.insert(self.m_Fires, FireManager:getSingleton():addEntity(value[1], value[2], value[3], 0, 0))
					end
 				elseif objectType == "Object" then
					for key, value in ipairs (objects) do
						table.insert(self.m_Objects, createObject(value[1], value[2], value[3], value[4]))
					end
				elseif objectType == "BreakAbleObject" then
					for key, value in ipairs (objects) do
						table.insert(self.m_BreakAbleObjects, DamageObject:getSingleton():addEntity(value[1], value[2], value[3], value[4], 0, 0, 500, {[9] = true}))
					end
				elseif objectType == "Vehicles" then
					for key, value in ipairs(objects) do
						local veh = Vehicle(value[1], value[2], value[3], value[4], value[5], value[6], value[7])
						veh:setLocked(true)
						veh:setFrozen(true)
						table.insert(self.m_Vehicles, veh)
					end
				end
			end
		end
	end
end

function TrainingGround:destructor()

end
