--

GUIEditor = { window = {}, label = {}, button = {}, radiobutton = {}}


Waffenschein = {
	["Informationstexte"] = {
		"Der Besitz von Waffen ist gestattet, wenn man einen gültigen Waffenschein besitzt und die Waffe auf legalem Weg eroworben wurde.",
		"In sogenannten Deathmatch freien Zonen, ist es nicht gestattet, Gewalt anzuwenden. Weder mit Waffen, noch mit Fäusten oder Fahrzeugen. Diese Regel gilt nicht für den Staat, welche auch in den genannten Zonen Festnahmen durchführen darf, und die Gesuchten, welche sich wehren dürfen. Sobald man sich in einer Deathmatch freien Zone befindet, wird sich angezeigt.",
		"Waffen dürfen ausschließlich zur Selbstverteidigung genutzt werden. Sollte man gerade keinen Gebrauch von seiner Waffe machen müssen, muss diese eingesteckt bleiben, um seine Mitmenschen zu schützen, indem man es nicht darauf anlegt, ungewollte Situationen entstehen zu lassen.",
		"Es ist möglich, die Waffe eines Spielers nach seinem Tod aufzuheben. Sollte die Waffe angemeldet sein, kann man sie dem Spieler zurückgeben oder sie der Polizei überreichen. Sollte es eine illegal erworbene Waffe ohne Seriennummer sein, sollte man sie unverzüglich der Polizei bringen."},
	["Fragen"] = {
		{"Wann darf man eine Waffe besitzen?","Wenn man einen Waffenschein besitzt und die Waffe auf legalem Weg erworben wurde.","Da gibt es keine Gesetze.","Wenn man Lust dazu hat.",1},
		{"Wann darf man Gebrauch von Waffen machen?","Wenn man angerempelt wird.","Wenn man bedroht wird.","Während man die Bpjm stürmt, weil sein Lieblingsalbum indiziert wurde.",2},
		{"Wo darf man keinen Gebrauch von Schusswaffen machen?","An Kreuzungen.","An vom Staat verifizierten Schießständen.","In Deathmatch freien Zonen.",3},
		{"Was macht man, wenn man eine nicht angemeldete Waffe gefunden hat?","Sie behalten und die Munition verballern.","Sie zur Polizei bringen.","Den Dödel vorne reinstecken.",2},
	},
	["Spawnpositions"] = {
		{-7186.6000976562, -2463.6000976562, 31.5,false},
		{-7186.6000976562, -2465.1000976562, 31.39999961853,false},
		{-7186.6000976562, -2462, 31.5,false},
		{-7186.6000976562, -2460.3000488281, 31.5,false},
		{-7186.6000976562, -2458.6999511719, 31.5,false},
		{-7186.6000976562, -2457.1000976562, 31.5,false},
		{-7186.6000976562, -2455.5, 31.5,false},
		{-7186.6000976562, -2466.6999511719, 31.5,false},
		{-7186.6000976562, -2468.3999023438, 31.5,false},
		{-7186.6000976562, -2470, 31.5,false},
		{-7186.6000976562, -2471.6000976562, 31.5,false},
		{-7186.6000976562, -2473.1999511719, 31.5,false},
		{-7186.6000976562, -2474.8000488281, 31.5,false},
	},
};

addEvent("Waffenschein.openWindow",true)
addEventHandler("Waffenschein.openWindow",root,function()
	if(isWindowOpen())then
        GUIEditor.window[1] = guiCreateWindow(456, 249, 374, 153, "San Fierro Police Department - Waffenschein", false)

        GUIEditor.label[1] = guiCreateLabel(10, 27, 354, 78, "Mit einem Waffenschein ist es dir möglich, auf legalem Weg Waffen zu kaufen.", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(10, 115, 172, 25, "Kaufen - 7500€", false, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(192, 115, 172, 25, "Schließen", false, GUIEditor.window[1])
		setWindowDatas(1);
		
		addEventHandler("onClientGUIClick",GUIEditor.button[1],function()
				if(getElementData(localPlayer,"Waffenschein") == 0)then
					if(getElementData(localPlayer,"Geld") >= 7500)then
						setElementData(localPlayer,"Geld",getElementData(localPlayer,"Geld")-7500);
						destroyWindow(GUIEditor.window[1])
						showCursor(true)
						setElementData(localPlayer,"Waffenschein",1);
						infobox("Du hast dir deinen Waffenschein gekauft.",0,120,0);
					else infobox("Du hast nicht genug Geld dabei!",120,0,0)end
				end
		end,false)
		
		addEventHandler("onClientGUIClick",GUIEditor.button[2],function()
			destroyElement(GUIEditor.window[1]);
			setElementData(localPlayer,"elementClicked",false);
			showCursor(false);
		end,false)
    end
end)