

-- [[ TABLES ]] --

AD = {};

-- [[ FENSTER ÖFFNEN ]] --

function AD.openWindow()
	if(isWindowOpen())then
		Elements.window[1] = Window:create(477, 325, 486, 250,"Marketing Xtreme",1400,900);
		Elements.edit[1] = Edit:create(487, 499, 466, 27,1400,900);
		Elements.button[1] = Button:create(487, 536, 228, 29,"Premium Werbung für 2000€ kaufen","AD.premium",1400,900);
		Elements.button[2] = Button:create(725, 536, 228, 29,"Normale Werbung für 350€ kaufen","AD.normal",1400,900);
		Elements.text[1] = Text:create(477,385,963,472,"Hier kannst du eine Werbung schalten, die anschließend bei allen Spielern oben links im Chat angezeigt wird. Es gibt zwei Arten von Werbung, Premium und Normal. Die beiden Arten unterscheiden sich an den Kosten, der Wartezeit und der Anzeige der Werbung.\nEs werden nur Werbungen für z.B. An- und Verkauf und Fraktionswerbung geduldet. Unnötige AD's werden mit einem Kick oder Ban bestraft.",1400,900);
		Elements.text[2] = Text:create(477,472,963,499,"Dein aktueller Marketing-Text:",1400,900);
		setWindowDatas();
	end
end
addCommandHandler("werbung",AD.openWindow)
addCommandHandler("ad",AD.openWindow)

-- [[ WERBUNG SCHALTEN ]] --

function AD.premium()
	local werbung = Elements.edit[1]:getText();
	if(#werbung >= 10)then
		if(#werbung <= 120)then
			triggerServerEvent("AD.send",localPlayer,werbung,"Premium");
			dxClassClose();
		else infobox("Dein Text ist zu lang und kann daher nicht abgesendet werden! (Max. 120 Zeichen)",120,0,0)end
	else infobox("Dein Text ist zu kurz und kann daher nicht abgesendet werden! (Mind. 10 Zeichen)",120,0,0)end
end

function AD.normal()
	local werbung = Elements.edit[1]:getText();
	if(#werbung >= 10)then
		if(#werbung <= 120)then
			triggerServerEvent("AD.send",localPlayer,werbung,"Normal");
			dxClassClose();
		else infobox("Dein Text ist zu lang und kann daher nicht abgesendet werden! (Max. 120 Zeichen)",120,0,0)end
	else infobox("Dein Text ist zu kurz und kann daher nicht abgesendet werden! (Mind. 10 Zeichen)",120,0,0)end
end