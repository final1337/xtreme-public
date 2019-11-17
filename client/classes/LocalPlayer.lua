LocalPlayer = inherit(Object)

registerElementClass("player", LocalPlayer)

addEvent("RP:Client:OnPastLogin", true)
addEvent("PlayRemoteSound", true)
addEvent("CreateRemoteEffect", true)
addEvent("CreateRemoteFxEffect", true)

function LocalPlayer:constructor()
	--toggleControl("next_weapon", false)
	--toggleControl("previous_weapon", false)


	self.m_Lobby = false

--	addEventHandler("RP:Client:OnRpLoading", root, bind(self.Event_OnRpLoading, self))
	addEventHandler("RP:Client:OnPastLogin", root, bind(self.Event_OnPastLogin, self))

	self.m_Bind_KeyBind_ShowInventory = bind(self.KeyBind_ShowInventory, self)
	
	self.m_SwitchBindNext = bind(self.Action_FastSelection, self, 1)
	self.m_SwitchBindPrevious = bind(self.Action_FastSelection, self, -1)
	
	-- addEventHandler("onClientPlayerWeaponFire", localPlayer, bind(self.Event_WeaponFire, self))
	addEventHandler("PlayRemoteSound", root, bind(self.playSound, self))
	addEventHandler("CreateRemoteEffect", root, bind(self.createEffect, self))
	addEventHandler("CreateRemoteFxEffect", root, bind(self.createFxEffect, self))	

	self.m_Timer = false
	self.m_Bind_TimerReset = bind(self.ResetTimer, self)

	addCommandHandler("autologin", bind(self.Command_AutoLogin, self))
end

function LocalPlayer:Command_AutoLogin(cmd, password)
	if getElementData(localPlayer,"loggedin") == 1 then
		config:set("Password", password)
		localPlayer:sendMessage("Wir versuchen sie beim nächsten Mal automatisch einzuloggen.", 255, 255, 0)
	end
end

function LocalPlayer:playSound(soundPath, looped, throttled, pVolume)
	Sound(soundPath, looped, throttled).volume = pVolume or 30
end

function LocalPlayer:createEffect(effectTable, tempFade)
	for key, value in ipairs(effectTable) do
		local foo = Effect(unpack(value))
		setTimer( function (effect) 
			if isElement (effect) then
				foo:destroy() 
			end 
		end, tempFade, 1, foo)
	end
end

function LocalPlayer:isFullfillingItemCondition(id)
	local templateFlags = itemmanager:getItemTemplate(id):getConditionFlags()
	local flagAmount = math.floor(tonumber(templateFlags:len()/8))

	if flagAmount > 0 then
		for i = 1, flagAmount, 1 do
			local ri = i - 1
			local condition = tonumber(templateFlags:sub(ri+ri*8, i*8))
			if not ItemConditions[condition].Func(localPlayer) then
				return false
			end
		end
	end

	return true
end

function LocalPlayer:createFxEffect(effectTable)
	for key, value in ipairs(effectTable) do
		if value[1] == "WaterSplash" then
			fxAddWaterSplash(value[2], value[3], value[4])
		elseif value[1] == "WaterHydrant" then
			fxAddWaterHydrant(value[2], value[3], value[4])	
		end
	end
end

function LocalPlayer:Event_WeaponFire()
	if not isTimer(self.m_Timer) then
		unbindKey("next_weapon", "down", self.m_SwitchBindNext)
		unbindKey("previous_weapon", "down", self.m_SwitchBindPrevious)
		self.m_Timer = Timer(self.m_Bind_TimerReset, 500, 1)
	elseif isTimer(self.m_Timer) then
		killTimer(self.m_Timer)
		self.m_Timer = Timer(self.m_Bind_TimerReset, 500, 1)
	end
end

function LocalPlayer:ResetTimer()
	if not isKeyBound("next_weapon", "down", self.m_SwitchBindNext) then
		bindKey("next_weapon", "down", self.m_SwitchBindNext)
	end
	if not isKeyBound("previous_weapon", "down", self.m_SwitchBindPrevious) then
		bindKey("previous_weapon", "down", self.m_SwitchBindPrevious)
	end
end

function LocalPlayer:KeyBind_ShowInventory()
    ItemManager:getSingleton():Command_GetInventory()
end

function LocalPlayer:triggerLobbyEvent(event, ...)
	if self:getLobby() then
		self:sendMessage("Das Event '%s' wurde getriggered.", 255, 255, 255, ("%s_Category%sLobby%s"):format(event, lobbymanager:getCategory(), lobbymanager:getLobbyId()))
		triggerServerEvent(("%s_Category%sLobby%s"):format(event, lobbymanager:getCategory(), lobbymanager:getLobbyId()), ...)
	end
end

function LocalPlayer:Event_OnPastLogin()
	-- Load core scripts first

	core:pastLogin()

	-- Than the localPlayer stuff

	--bindKey("next_weapon", "down", self.m_SwitchBindNext)
	--bindKey("previous_weapon", "down", self.m_SwitchBindPrevious)

	self:Action_FastSelection(1)

    ItemManager:getSingleton():activate()
	bindKey("i", "up", self.m_Bind_KeyBind_ShowInventory)	
	
	Timer(function ()
		toggleControl("next_weapon", false)
		toggleControl("previous_weapon", false)
	end, 500, 0)

	---

	self.m_LastSwitch = 0
	self.m_LastValidSwitch = 0

	--addEventHandler("onClientKey", root, bind(self.Event_KeyPress, self))
	--addEventHandler("onClientPlayerWeaponFire", root, bind(self.Event_WeaponFire, self))
	--addEventHandler("onClientPlayerWeaponSwitch", root, bind(self.Event_WeaponSwitch, self))
end

function LocalPlayer:Event_WeaponFire()
	if source == localPlayer then
		outputChatBox("fire")
		self.m_LastSwitch = getTickCount()
	end
end

function LocalPlayer:Event_WeaponSwitch()
	if getPedWeapon(localPlayer) == 0 and getTickCount() >= self.m_LastValidSwitch + 50 then
		self:Action_FastSelection(-1)
	end
	-- cancelEvent(true)
end

function LocalPlayer:Event_KeyPress(button, pressOrRelease)
	if not pressOrRelease then return end
	if button == "q" or button == "e" or button == "mouse_wheel_up" or button == "mouse_wheel_down" then
		if getTickCount() >= self.m_LastSwitch + 300 then
			self.m_LastValidSwitch = getTickCount()
			if button == "q" or button == "mouse_wheel_down" then
				self:Action_FastSelection(-1)
			else
				self:Action_FastSelection(1)
			end
		end
	end
end

function LocalPlayer:setLobby(lobby) self.m_Lobby = lobby end
function LocalPlayer:getLobby() return self.m_Lobby end

function LocalPlayer:Action_FastSelection(amount)
	triggerServerEvent("RP:Server:StorageManager:fastSwitch", resourceRoot, amount, true)
end

function LocalPlayer:tryToGetLocalization(string)
	local tryResult = loc(string, self)
	if tryResult == string then
		return string
	else
		return tryResult
	end
end

function LocalPlayer:sendMessage(msg, r, g, b, ...)
	msg = self:tryToGetLocalization(msg)
	if not r then
		r, g, b = 255, 255, 255
	end
	outputChatBox((msg):format(...), r,g,b,true)
end

function LocalPlayer:sendNotification(msg, r, g, b, ...)
	msg = self:tryToGetLocalization(msg)
	if not r then
		r, g, b = 255, 255, 255
	end	
	Infobox.new((msg):format(...), r, g, b)
end

function LocalPlayer:getData(value)
	return getElementData(self, value)
end

function LocalPlayer:destructor()

end