--[[

	(c) FiNAL
	Xtreme Reallife
	2019

]]--


Fahrschule = {
	["Fahrzeugspawn"] = {
		["Fuehrerschein"] = {405,-2047.2777099609,-84.39510345459,35.164100646973,0,0,0},
		["Motorradschein"] = {521,-2047.2777099609,-84.39510345459,35.164100646973,0,0,0},
		["Bootschein"] = {452,-1766.1875,-194.93190002441,0,0,0,270},
		["LKWSchein"] = {403,-2047.2777099609,-84.39510345459,35.164100646973,0,0,0},
		["Helikopterschein"] = {487,-2028.0963134766,-109.25700378418,39.186901092529,0,0,0},
		["Flugschein"] = {593,-1647.3325195313,-165.37829589844,14.698599815369,0,0,316},
	},
	car = {}, ped = {},
}

addEvent("Fahrschule.constructor", true)
addEventHandler("Fahrschule.constructor", root, function(license, type)
	if type == "destroy" then
		infobox(client, "Du hast die Prüfung mit Erfolg beendet!", 0, 120, 0)
		destroyElement(Fahrschule.car[client])
		destroyElement(Fahrschule.ped[client])
		setTimer( function (player)
			setElementPosition(player, -2030.84180, -116.81423, 1035.17188)
			setElementRotation(player, 0, 0, 180)
			setElementInterior(player, 3)
			setElementFrozen(player, true)
			Timer(setElementFrozen, 500, 1, player, false)
			setElementDimension(player, 0)
		end, 500, 1, client)
        setElementData(client, "Fahrschule", false)
	else
		infobox(client, "Viel Erfolg!", 0, 120, 0)
		local t = Fahrschule["Fahrzeugspawn"][license]
		local dim = math.random(1337, 13337)
		Fahrschule.car[client] = createVehicle(t[1], t[2], t[3], t[4], t[5], t[6], t[7])
		Fahrschule.ped[client] = createPed(48, 0, 0, 0, 0)

		Fahrschule.car[client].Player = client
		setElementInterior(client, 0)
		setElementDimension(client, dim)
		setElementDimension(Fahrschule.car[client], dim)
		setElementDimension(Fahrschule.ped[client], dim)
		warpPedIntoVehicle(client, Fahrschule.car[client])
		warpPedIntoVehicle(Fahrschule.ped[client], Fahrschule.car[client], 1)

		addEventHandler("onVehicleExit", Fahrschule.car[client], function(client)
			infobox(client, "Du hast die Prüfung abgebrochen!", 120, 0, 0)
			destroyElement(Fahrschule.car[client])
			destroyElement(Fahrschule.ped[client])
			setTimer( function (player)
				setElementPosition(player, -2030.84180, -116.81423, 1035.17188)
				setElementRotation(player, 0, 0, 180)
				setElementInterior(player, 3)
				setElementFrozen(player, true)
				Timer(setElementFrozen, 500, 1, player, false)
				setElementDimension(player, 0)
			end, 500, 1, client)
			setElementFrozen(client, true)
			Timer(setElementFrozen, 500, 1, client, false)			
			setElementData(client, "Fahrschule", false)
			client:triggerEvent("Fahrschule.stopPraxis")
		end)


		addEventHandler("onVehicleExplode", Fahrschule.car[client],
			function()
				local player = source.Player
				infobox(player, "Du hast die Prüfung abgebrochen!", 120, 0, 0)
				destroyElement(Fahrschule.car[player])
				destroyElement(Fahrschule.ped[player])
				setElementDimension(player, 0)		
				setElementData(player, "Fahrschule", false)
				player:triggerEvent("Fahrschule.stopPraxis")				
			end
		)
		triggerClientEvent(client, "Fahrschule.startPraxis", client, "create")
		if license == "Flugschein" or license == "Helikopterschein" then
			outputChatBox("#FF7D00[INFO] #ffffffDeine Aufgabe ist es, die Marker abzufliegen, um die Prüfung abzuschließen.", client, 255, 255, 255, true)
		elseif license == "Bootschein" then
			outputChatBox("#FF7D00[INFO] #ffffffDeine Aufgabe ist es, die Marker abzusegeln, um die Prüfung abzuschließen.", client, 255, 255, 255, true)
		else
			outputChatBox("#FF7D00[INFO] #ffffffDeine Aufgabe ist es, die Marker abzufahren.", client, 255, 255, 255, true)
			outputChatBox("#FF7D00[INFO] #ffffffNutze /limit um ein Tempolimit festzulegen. Maximal erlaubtes Tempo: 80 kmh/h.", client, 255, 255, 255, true)
		end
	end
end)