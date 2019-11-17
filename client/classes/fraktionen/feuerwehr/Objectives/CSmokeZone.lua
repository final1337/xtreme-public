SmokeZone = inherit(Singleton)

addEvent("XTM:FF:SmokeZoneEffectEnter", true)
addEvent("XTM:FF:SmokeZoneEffectLeave", true)

SmokeZone.MAX_PARTICLES = 40

function SmokeZone:constructor()
	
	self.m_Fade = 0
	self.m_Particles = {}
	self.m_RenderHandler = bind(self.draw, self)
	self.m_SmokeTexture = dxCreateTexture("client/classes/fraktionen/feuerwehr/files/textures/smoke.dds")
	
	addEventHandler("XTM:FF:SmokeZoneEffectEnter", root, bind(self.Event_SmokeZoneEffectEnter, self))
	addEventHandler("XTM:FF:SmokeZoneEffectLeave", root, bind(self.Event_SmokeZoneEffectLeave, self))
	
	self:loadParticles()
end

function SmokeZone:loadParticles()
	for i =1 , SmokeZone.MAX_PARTICLES, 1 do
		self.m_Particles[i] = {
			PosX = math.random(screenWidth),
			PosY = math.random(screenHeight),
			Rotation = math.random(),
			Size = math.random(500, 800),
			SpeedX = math.random(3,9)/10,
			SpeedY = math.random(3,9)/10,
			RotationSpeed = math.random (),
			X_AxisMove = math.random(2),
			Y_AxisMove = math.random(2),
		}
	end
end

function SmokeZone:Event_SmokeZoneEffectEnter()
	addEventHandler("onClientPreRender", root, self.m_RenderHandler)
end

function SmokeZone:Event_SmokeZoneEffectLeave()
	removeEventHandler("onClientPreRender", root, self.m_RenderHandler)
end


function SmokeZone:draw()
	dxDrawRectangle(0,0, screenWidth, screenHeight, tocolor ( 50, 50, 50, 150 + math.abs(math.sin(getTickCount()/1000)) * 50))
	--dxDrawImage(0,0, 60, 60, self.m_SmokeTexture)
	
	for key, value in ipairs(self.m_Particles) do
		value.PosX = value.PosX +  ( value.X_AxisMove == 1 and value.SpeedX or - value.SpeedX)
		value.PosY = value.PosY +  ( value.Y_AxisMove == 1 and value.SpeedY or - value.SpeedY)
		value.Rotation = value.Rotation + value.RotationSpeed
		
		if value.PosX > screenWidth then
			value.PosX = 0 - value.Size
		elseif value.PosX < 0 - value.Size then
			value.PosX = screenWidth + value.Size
		end
		if value.PosY > screenHeight then
			value.PosY = 0 - value.Size
		elseif value.PosY  < 0 - value.Size then
			value.PosY = screenHeight + value.Size
		end
		
		
		dxDrawImage(value.PosX, value.PosY, value.Size, value.Size, self.m_SmokeTexture, value.Rotation, 0, 0, tocolor(50,50,50, 200))
	end
end

function SmokeZone:destructor()
	
end