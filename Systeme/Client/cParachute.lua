Parachute = { image = {},
    pickup = createPickup(-1544.12695, -441.13184, 6.00000, 3, 1239),
    jump   = createPickup(1.52472, 23.61567, 1199.59375, 3, 1318),
}
local sx, sy = guiGetScreenSize()

function Parachute.trigger(x, y, size)
    setElementInterior(localPlayer, 1)
    setElementPosition(localPlayer, 1.6127, 34.7411, 1199.0)
    destroyWindow("Parachute")
    destroyElement(Parachute.image[1])
    setTimer(function() setElementData(player, "Clicked", false) end, 500, 1)
    showCursor(false)
    addEventHandler("onClientPickupHit", Parachute.jump, function(player, mdim)
        triggerServerEvent("setPlayerParachute", player)
        setElementInterior(player, 0)
        fadeCamera(false)
        local mid = size/2
        local tx = (3000/mid) * (x-mid)
        local ty = (3000/mid) * (mid-y)
        if ty > 0 then
            ty = ty+8
        else
            ty = ty-8
        end
        if tx > 0 then
            tx = tx+8
        else
            tx = tx-8
        end
        local z = tonumber(getGroundPosition(tx, ty, 1000))+10000
        local element = player
        if isPedInVehicle(player) then element = getPedOccupiedVehicle(player) end
        setTimer(function()
            setTimer(function()
                local z = tonumber(getGroundPosition(tx, ty, 1000))+10000
                setElementPosition(element, tx, ty, z)
                fadeCamera(true)
            end, 1000, 1)
            infobox("Wir sehen uns unten!", 0, 120, 0)
        end, 1000, 1)
    end)
end

function Parachute.destroy()
    showCursor(false)
    destroyWindow("Parachute")
    destroyElement(Parachute.image[1])
    setTimer(function() setElementData(localPlayer, "Clicked", false) end, 500, 1)
end

function Parachute.constructor(player, mDim)
    if getElementData(player, "Clicked") == false then
        if getElementData(player, "Geld") >= 750 then
            showChat(false)
            setElementData(player, "Geld", getElementData(player, "Geld")-750)
            setElementData(player, "Clicked", true)
            showCursor(true)
            local height = math.floor((sy/4)*3)
            local wHeight = height+36
            local wWidth = height+18
            local posx = sx/2-wWidth/2
            local posy = sy/2-wHeight/2
            drawWindow("Parachute", "Window", "Bei mir kannst du Fallschirm springen für 750€!", 232, 63, 821, 858, "Parachute.destroy")
            Parachute.image[1] = guiCreateStaticImage(posx+9, posy+18, height, height, "Files/Images/Parachute/map.png", false)
            
            addEventHandler("onClientGUIClick", Parachute.image[1], function(_, _, x, y)
                showChat(true)
                local x = x - posx-9
                local y = y - posy-18
                Parachute.trigger(x, y, height)
                showCursor(false)
                destroyWindow("Parachute")
                destroyElement(Parachute.image[1])
                setTimer(function() setElementData(localPlayer, "Clicked", false) end, 500, 1)            
            end, false)
        else infobox("Du hast nicht genug Geld, um Fallschirm zu springen!", 0, 120, 0) end
    end
end
addEventHandler("onClientPickupHit", Parachute.pickup, Parachute.constructor)