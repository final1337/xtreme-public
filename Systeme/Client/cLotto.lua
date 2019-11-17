--

Lotto = {};

addEvent("Lotto.createWindow",true)
addEventHandler("Lotto.createWindow",root,function(jackpot)
	if(isWindowOpen())then
		Elements.window[1] = Window:create(554, 290, 333, 320,"Xtreme Lotto",1440,900);
		Elements.text[1] = Text:create(564, 413, 877, 436,"Aktuell im Jackpot: "..jackpot.."€",1440,900);
		Elements.text[2] = Text:create(564, 486, 877, 542,"Hier kannst du dein Glück versuchen. Setze 5 Zahlen im Bereich 0 - 9. Du kannst nur einen Schein einlösen. Kosten: 3500€",1440,900);
		Elements.text[3] = Text:create(564, 584, 877, 600,"Nächste Ziehung: Sonntag 20:00 Uhr",1440,900);
		Elements.image[1] = Image:create(628, 360, 185, 53,"Files/Images/Lotto.png",1440,900);
		Elements.button[1] = Button:create(564, 552, 153, 22,"Eingabe speichern","Lotto.save",1440,900);
		Elements.button[2] = Button:create(724, 552, 153, 22,"Zurücksetzen","Lotto.reset",1440,900);
		Elements.edit[1] = Edit:create(707, 446, 34, 30,1440,900);
		Elements.edit[2] = Edit:create(751, 446, 34, 30,1440,900);
		Elements.edit[3] = Edit:create(663, 446, 34, 30,1440,900);
		Elements.edit[4] = Edit:create(619, 446, 34, 30,1440,900);
		Elements.edit[5] = Edit:create(795, 446, 34, 30,1440,900);
		setWindowDatas();
	end
end)

function Lotto.save()
	local nr1,nr2,nr3,nr4,nr5 = Elements.edit[1]:getText(),Elements.edit[2]:getText(),Elements.edit[3]:getText(),Elements.edit[4]:getText(),Elements.edit[5]:getText();
	if(#nr1 >= 1 and tonumber(nr1) >= 0 and tonumber(nr1) <= 9 and #nr2 >= 1 and tonumber(nr2) >= 0 and tonumber(nr2) <= 9 and #nr3 >= 1 and tonumber(nr3) >= 0 and tonumber(nr3) <= 9 and #nr4 >= 1 and tonumber(nr4) >= 0 and tonumber(nr4) <= 9 and #nr5 >= 1 and tonumber(nr5) >= 0 and tonumber(nr5) <= 9)then
		triggerServerEvent("Lotto.save",localPlayer,{nr1,nr2,nr3,nr4,nr5});
	else infobox("Gib 5 Zahlen zwischen 0 - 9 an!",120,0,0)end
end

function Lotto.reset()
	for i = 1,5 do
		Elements.edit[i]:setText("");
	end
end