Fire = inherit(Object)

--Boteinsatz

--Wiederbeleben von den Medics ( double time; save weapons or revive )

function Fire:constructor(id,x,y,z,int,dim)
	self.m_Id = id
	self.m_PosX = x
	self.m_PosY = y
	self.m_PosZ = z
	self.m_Interior = int
	self.m_Dimension = dim
	self.m_IsExtinguished = false
	
	self.m_ColShape = ColShape.Sphere(x,y,z, 1.5)
	
	self.onTouchFire = false
	self.onFinish = false
	
	addEventHandler("onColShapeHit", self.m_ColShape, bind(self.Event_OnColShapeHit, self))
end

function Fire:Event_OnColShapeHit(hitElement)
	if hitElement:getType() == "player" and hitElement:getDimension() == self.m_Dimension  and hitElement:getInterior() == self.m_Interior then
		if self.onTouchFire then
			self:onTouchFire(hitElement)
		end
	end
end

function Fire:getPosition()
	return self.m_PosX, self.m_PosY, self.m_PosZ
end

function Fire:getId()
	return self.m_Id
end

function Fire:getInterior()
	return self.m_Interior
end

function Fire:getDimension()
	return self.m_Dimension
end

function Fire:getExtinguishedState()
	return self.m_IsExtinguished
end

function Fire:extinguish(foreSynch)
	self.m_IsExtinguished = true
	if foreSynch then
		FireManager:getSingleton():syncNewFire(self.m_Id)
	end
end

function Fire:destructor()
	self.m_IsExtinguished = true
	self.m_ColShape:destroy()
	FireManager:getSingleton():syncNewFire(self.m_Id)
end