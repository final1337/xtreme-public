-- // Made by FiNAL
-- || cRadar.lua
-- \\ Xtreme Reallife

-- [[ TABLES (BONUSS!!!) ]]

-- INFO: Zur Übersichtlichkeit wurde in den Koordinatenberechnungen mit Leertasten gearbeitet

Radar = {}

local playerX, playerY, playerZ = 0, 0, 0


-- [[ Auszug aus dem englischen MTA Forum / Excerpt from the English MTA:SA Forum ]]

function dxDrawBorder(x, y, w, h, size, color, postGUI)
    size = size or 2
    dxDrawRectangle(x - size, y, size, h, color or tocolor(0, 0, 0, 180), postGUI)
    dxDrawRectangle(x + w, y, size, h, color or tocolor(0, 0, 0, 180), postGUI)
    dxDrawRectangle(x - size, y - size, w + (size * 2), size, color or tocolor(0, 0, 0, 180), postGUI)
    dxDrawRectangle(x - size, y + h, w + (size * 2), size, color or tocolor(0, 0, 0, 180), postGUI)
end

-- [[ HELPFUL FUNCTIONS ]]

local isColliding = function(x1, y1, w1, h1, x2, y2, w2, h2)
    local horizontal = (x1 < x2) ~= (x1 + w1 < x2) or (x1 > x2) ~= (x1 > x2 + w2)
    local vertical = (y1 < y2) ~= (y1 + h1 < y2) or (y1 > y2) ~= (y1 > y2 + h2)

    return (horizontal and vertical)
end

local getRadarRadius = function()
    if not Radar.playerInVehicle then return 100 else
        local x, y, z = getElementVelocity(Radar.playerInVehicle)
        local curspeed = (1+(x^2+y^2+z^2)^(0.5))/2 -- { thanks to strobe for the calculation }
        if curspeed <= 0.5 then return 100 else return 360 end

        local distance = curspeed-0.5
        local radius  = 180/0.5
        
        return math.ceil((distance*radius)+180)
    end
end

local getVectorRotation = function(x, y, x1, y1)
    local rot = 6.2831853071796-math.atan2(x1-x, y1-y)%6.2831853071796 -- { thanks to strobe again for the calculation <3 }
    return -rot
end

local getRotation = function()
    local x, y, finalspenis, rx, ry = getCameraMatrix()
    local result = getVectorRotation(x, y, rx, ry)

    return result
end

local getPointFromDistanceRotation = function(x, y, distance, winkel)
    local x1 = math.cos(math.rad(90-winkel))*distance
    local y1 = math.sin(math.rad(90-winkel))*distance
    return x+x1, y+y1
end


-- [[ MAKE 'EM GLOBAL AMK ]]

getRadarState = function()
    return Radar.isVisible
end

showRadar = function()
    addEventHandler("onClientRender", root, drawRadar)
end

hideRadar = function()
    removeEventHandler("onClientRender", root, drawRadar)
end





-- [[ MAKE 'EM GLOBAL AMK ]]

setRadarSettings = function()
    local radarSettings = {
        ["mapTexture"] = "Files/Images/Radar/map.png",
        ["mapTextureSize"] = 3072,
        ["mapWaterColor"] = { 50, 75, 100 },
        ["alpha"] = 225,
    }

    Display = {}
	Display.Width, Display.Height = guiGetScreenSize()

    Radar = {}
    Radar.Width = 325
    Radar.Height = 225
    Radar.PosX = 15
    Radar.PosY = Display.Height-15-Radar.Height

    Radar.IsVisible = true
    Radar.TextureSize = radarSettings["mapTextureSize"]
    Radar.NormalTargetSize, Radar.BiggerTargetSize = Radar.Width, Radar.Width*2
    Radar.MapTarget = dxCreateRenderTarget(Radar.BiggerTargetSize, Radar.BiggerTargetSize, true)
    Radar.RenderTarget = dxCreateRenderTarget(Radar.NormalTargetSize*3, Radar.NormalTargetSize*3, true)
    Radar.MapTexture = dxCreateTexture(radarSettings["mapTexture"])

    Radar.CurrentZoom = 6
    Radar.MaximumZoom = 10
    Radar.MinimumZoom = 3

    Radar.WaterColor = { 50, 75, 100 }
    Radar.Alpha = radarSettings["alpha"]
    Radar.playerInVehicle = false
    Radar.LostRotation = 0
    Radar.MapUnit = Radar.TextureSize/6000

    Fonts = {}
    Fonts.Roboto = "default-bold"
    Fonts.Icons = "default-bold"

    Stats = {}
    Stats.Bar = {}
    Stats.Bar.Width = Radar.Width
    Stats.Bar.Height = 12.5
end
	
function drawRadar()
    if getElementData(localPlayer, "loggedin") == 1 and getElementInterior(localPlayer) == 0 then
		setPlayerHudComponentVisible("radar", false)
        dxSetTextureEdge(Radar.MapTexture, "border", tocolor(50, 68, 89, 255))
        dxDrawBorder(Radar.PosX, Radar.PosY, Radar.Width, Radar.Height, 3, tocolor(0, 0, 0, 150))
		
            Radar.playerInVehicle = getPedOccupiedVehicle(localPlayer)
            playerX, playerY, playerZ = getElementPosition(localPlayer)

            local playerRotation = getElementRotation(localPlayer)
            local rx, ry, rz = getElementRotation(localPlayer)
            local camX, camY, camZ = getElementRotation(getCamera())
            local playerMapX, playerMapY = (3000 + playerX) / 6000 * Radar.TextureSize, (3000 - playerY) / 6000 * Radar.TextureSize
            local streamDistance, pRotation = getRadarRadius(), getRotation()
            local mapRadius = streamDistance / 6000 * Radar.TextureSize * Radar.CurrentZoom
            local mapX, mapY, mapWidth, mapHeight = playerMapX - mapRadius, playerMapY - mapRadius, mapRadius * 2, mapRadius * 2

            dxSetRenderTarget(Radar.MapTarget, true)
            dxDrawRectangle(0, 0, Radar.BiggerTargetSize, Radar.BiggerTargetSize, tocolor(Radar.WaterColor[1], Radar.WaterColor[2], Radar.WaterColor[3], Radar.Alpha), false)
            dxDrawImageSection(0, 0, Radar.BiggerTargetSize, Radar.BiggerTargetSize, mapX, mapY, mapWidth, mapHeight, Radar.MapTexture, 0, 0, 0, tocolor(255, 255, 255, Radar.Alpha), false)

            for _, area in ipairs(getElementsByType("radararea")) do
                local areaX, areaY = getElementPosition(area)
                local areaWidth, areaHeight = getRadarAreaSize(area)
                local areaMapX, areaMapY, areaMapWidth, areaMapHeight = (3000+areaX)/6000*Radar.TextureSize, (3000-areaY)/6000*Radar.TextureSize, areaWidth/6000*Radar.TextureSize, -(areaHeight/6000*Radar.TextureSize)

                if isColliding(playerMapX - mapRadius, playerMapY - mapRadius, mapRadius * 2, mapRadius * 2, areaMapX, areaMapY, areaMapWidth, areaMapHeight) then
                    local areaR, areaG, areaB, areaA = getRadarAreaColor(area)

                    if isRadarAreaFlashing(area) then
                        areaA = areaA * math.abs(getTickCount()%1000-500)/500
                    end

                    local mapRatio = Radar.BiggerTargetSize/(mapRadius*2)
                    local areaMapX, areaMapY, areaMapWidth, areaMapHeight = (areaMapX-(playerMapX-mapRadius))*mapRatio, (areaMapY-(playerMapY-mapRadius))*mapRatio, areaMapWidth*mapRatio, areaMapHeight*mapRatio

                    dxSetBlendMode("modulate_add")
                    dxDrawRectangle(areaMapX, areaMapY, areaMapWidth, areaMapHeight, tocolor(areaR, areaG, areaB, areaA), false)
                    dxSetBlendMode("blend")
                end
            end

            dxSetRenderTarget(Radar.RenderTarget, true)
            dxDrawImage(Radar.NormalTargetSize/2, Radar.NormalTargetSize/2, Radar.BiggerTargetSize, Radar.BiggerTargetSize, Radar.MapTarget, math.deg(-pRotation), 0, 0, tocolor(255, 255, 255, 255), false)

            local serverBlips = getElementsByType("blip")

            table.sort(serverBlips, function(b1, b2)
                return getBlipOrdering(b1) < getBlipOrdering(b2)
            end)

            for _, blip in ipairs(serverBlips) do
                local blipX, blipY, blipZ = getElementPosition(blip)

                if localPlayer ~= getElementAttachedTo(blip) and getElementInterior(localPlayer) == getElementInterior(blip) and getElementDimension(localPlayer) == getElementDimension(blip) then
                    local blipDistance = getDistanceBetweenPoints2D(blipX, blipY, playerX, playerY)
                    local blipRotation = math.deg(-getVectorRotation(playerX, playerY, blipX, blipY)-(-pRotation))-180
                    local blipRadius = math.min((blipDistance/(streamDistance*Radar.CurrentZoom))*Radar.NormalTargetSize, Radar.NormalTargetSize)
                    local distanceX, distanceY = getPointFromDistanceRotation(0, 0, blipRadius, blipRotation)
                    local bid = getElementData(blip, "customIcon") or getBlipIcon(blip)
                    local blipX, blipY = Radar.NormalTargetSize*1.5+(distanceX-(20/2)), Radar.NormalTargetSize*1.5+(distanceY-(20/2))
                    if getBlipIcon(blip) == 0 then
                        bR, bG, bB = getBlipColor(blip)
                    else
                        bR, bG, bB = 255, 255, 255
                    end
                    dxSetBlendMode("modulate_add")
                    dxDrawImage(blipX, blipY, 24, 24, "Files/Images/Radar/"..bid..".png", 0, 0, 0, tocolor(bR, bG, bB, 255), false)
                    dxSetBlendMode("blend")
                end
            end




            for key, value in ipairs(customBlips) do
                local blipX, blipY, blipZ = value.posX, value.posY, 20

                if getElementInterior(localPlayer) == 0 and getElementDimension(localPlayer) == 0 then
                    local blipDistance = getDistanceBetweenPoints2D(blipX, blipY, playerX, playerY)
                    local blipRotation = math.deg(-getVectorRotation(playerX, playerY, blipX, blipY)-(-pRotation))-180
                    local blipRadius = math.min((blipDistance/(streamDistance*Radar.CurrentZoom))*Radar.NormalTargetSize, Radar.NormalTargetSize)
                    local distanceX, distanceY = getPointFromDistanceRotation(0, 0, blipRadius, blipRotation)
                    local bid = value.path
                    local blipX, blipY = Radar.NormalTargetSize*1.5+(distanceX-(20/2)), Radar.NormalTargetSize*1.5+(distanceY-(20/2))
                    dxSetBlendMode("modulate_add")
                    dxDrawImage(blipX, blipY, value.width, value.height, bid, 0, 0, 0, tocolor(255, 255, 255, 255), false)
                    dxSetBlendMode("blend")
                end
            end            

            dxSetRenderTarget()
            dxDrawImageSection(Radar.PosX, Radar.PosY, Radar.Width, Radar.Height, Radar.NormalTargetSize / 2 + (Radar.BiggerTargetSize / 2) - (Radar.Width / 2), Radar.NormalTargetSize / 2 + (Radar.BiggerTargetSize / 2) - (Radar.Height / 2), Radar.Width, Radar.Height, Radar.RenderTarget, 0, -90, 0, tocolor(255, 255, 255, 255));

            dxDrawImage((Radar.PosX + (Radar.Width / 2)) - 10, (Radar.PosY + (Radar.Height / 2)) - 10, 20, 20, "Files/Images/Radar/2.png", camZ - rz, 0, 0)

            dxDrawText(getZoneName(playerX, playerY, playerZ) .. " - " .. getZoneName(playerX, playerY, playerZ, true), Radar.PosX + 5, (Radar.PosY - Radar.Height+17.5), Radar.PosX + 5 + Radar.Width - 10, Radar.PosY + Radar.Height, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, false, true, true)

            if (getKeyState("num_add") or getKeyState("num_sub")) then
                Radar.CurrentZoom = math.max(Radar.MinimumZoom, math.min(Radar.MaximumZoom, Radar.CurrentZoom + ((getKeyState("num_sub") and -1 or 1) * (getTickCount() - (getTickCount() + 50)) / 100)))
            end
        dxDrawBorder(Radar.PosX, Radar.PosY, Stats.Bar.Width, Stats.Bar.Height + 10, 2, tocolor(0, 0, 0, 150))
        dxDrawRectangle(Radar.PosX, Radar.PosY, Stats.Bar.Width, Stats.Bar.Height + 10, tocolor(0, 0, 0, 140))
    end
end