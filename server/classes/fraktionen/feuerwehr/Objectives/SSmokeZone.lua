SmokeZone = inherit(Object)

SmokeZone.DAMAGE_INTERVALL = 3000 -- IN MS
SmokeZone.DAMAGE_PER_TICK = 3 -- FROM 100

function SmokeZone:constructor(x,y,w,h,int,dim)
	self.m_ColSphere = createColRectangle(x,y,w,h)
    
    self.m_Interior = int or 0
    self.m_Dimension = dim or 0

    self.m_ColSphere:setDimension(dim or 0)
    self.m_ColSphere:setInterior(int or 0)
	
	self.m_CurrentElements = {}
	self.m_DamgePerTick = SmokeZone.DAMAGE_PER_TICK
	
	self.m_EnterHandler = bind(self.Event_ColShapeEnter, self)
	self.m_LeaveHandler = bind(self.Event_ColShapeLeave, self)
	self.m_TimerHandler = bind(self.HurtPeople, self)
	
	addEventHandler ("onColShapeHit", self.m_ColSphere, self.m_EnterHandler)
	addEventHandler ("onColShapeLeave", self.m_ColSphere, self.m_LeaveHandler)
	self.m_DamageTimer = setTimer ( self.m_TimerHandler, SmokeZone.DAMAGE_INTERVALL, 0 )
	
	self.onDamage = false
	
end

function SmokeZone:HurtPeople()
	for _, player in ipairs(self.m_CurrentElements) do
		if not player:getData("isWearingBreathing") then
			setElementHealth(player, getElementHealth(player)-self.m_DamgePerTick)
			player:playRemoteSound("client/classes/fraktionen/feuerwehr/files/sound/husten.mp3")
		end
	end
	if self.onDamage then
		self:onDamage(self.m_DamgePerTick)
	end
end

function SmokeZone:setDamage(damage)
	self.m_DamgePerTick = damage
end

function SmokeZone:getDamage()
	return self.m_DamgePerTick
end

function SmokeZone:Event_ColShapeEnter(hitElement, matchingDimension)
    Timer ( function ()
	    if getElementType(hitElement) == "player" and self.m_Dimension == hitElement:getDimension() and hitElement:getInterior() == self.m_Interior then
		    hitElement:setData("isAbleToWearBreathing", true)
		    hitElement:triggerEvent("XTM:FF:SmokeZoneEffectEnter")
		    self:addPlayer(hitElement)
	    end
    end, 50, 1)
end

function SmokeZone:addPlayer(player)
	table.insert(self.m_CurrentElements, player)
end

function SmokeZone:removePlayer(player)
	for key, value in ipairs(self.m_CurrentElements) do
		if value == player then
			return table.remove(self.m_CurrentElements, key)
		end
	end
	return false
end

function SmokeZone:Event_ColShapeLeave(hitElement, matchingDimension)
	if getElementType(hitElement) == "player" and self.m_Dimension == hitElement:getDimension() then
		hitElement:setData("isAbleToWearBreathing", false)
		hitElement:triggerEvent("XTM:FF:SmokeZoneEffectLeave")
		self:removePlayer(hitElement)
	end	
end

function SmokeZone:setPosition(x,y)
	self.m_PosX, self.m_PosY = x,y
	self.m_ColSphere:setPosition(x,y)
end

function SmokeZone:getPosition()
	return x,y
end

function SmokeZone:setSize(w,h)
end

function SmokeZone:destructor()
	destroyElement(self.m_ColSphere)
	killTimer(self.m_DamageTimer)
end