--

-- [[ PEDS ]] --

local AmmunationpedSF = createPed(312,295.65991210938,-82.588302612305,1001.515625,0);
setElementInterior(AmmunationpedSF,4);
addEventHandler("onClientPedDamage",AmmunationpedSF,function() cancelEvent() end)
local AmmunationpedLS = createPed(312,308.18939208984,-142.9868927002,999.60162353516,0);
setElementInterior(AmmunationpedLS,7);
addEventHandler("onClientPedDamage",AmmunationpedLS,function() cancelEvent() end)

-- [[ FENSTER ÖFFNEN ]] --

addEvent("Ammunation.openWindow",true)	
addEventHandler("Ammunation.openWindow",root,function()
	if(isWindowOpen())then
		Schlagring,Baseballschlaeger,Messer,Colt,Deagle,Rifle,Sawnoff,Combat,Shotgun,Uzi,Mp5,M4,Sniper,Schutzweste = "1 - 40€","1 - 50€","1 - 30","34 - 150€","21 - 500€","15 - 2500€","20 - 500€","20 - 500€","10 - 480€","200 - 850€","120 - 2300€","200 - 2500€","5 - 10000€","1 - 40€";

		Elements.window[1] = Window:create(449, 267, 542, 367,"Ammu-Nation",1440,900);
		Elements.button[1] = Button:create(459, 501, 66, 19,Schlagring,"buySchlagring",1440,900);
		Elements.button[2] = Button:create(535, 501, 66, 19,Baseballschlaeger,"buyBaseballschlaeger",1440,900);
		Elements.button[3] = Button:create(611, 501, 66, 19,Messer,"buyMesser",1440,900);
		Elements.button[4] = Button:create(687, 501, 66, 19,Colt,"buyColt",1440,900);
		Elements.button[5] = Button:create(763, 501, 66, 19,Deagle,"buyDeagle",1440,900);
		Elements.button[6] = Button:create(839, 501, 66, 19,Rifle,"buyRifle",1440,900);
		Elements.button[7] = Button:create(915, 501, 66, 19,Sawnoff,"buySawnoff",1440,900);
		Elements.button[8] = Button:create(459, 605, 66, 19,Combat,"buyCombat",1440,900);
		Elements.button[9] = Button:create(535, 605, 66, 19,Shotgun,"buyShotgun",1440,900);
		Elements.button[10] = Button:create(611, 605, 66, 19,Uzi,"buyUzi",1440,900);
		Elements.button[11] = Button:create(687, 605, 66, 19,Mp5,"buyMp5",1440,900);
		Elements.button[12] = Button:create(763, 605, 66, 19,M4,"buyM4",1440,900);
		Elements.button[13] = Button:create(839, 605, 66, 19,Sniper,"buySniper",1440,900);
		Elements.button[14] = Button:create(915, 605, 66, 19,Schutzweste,"buySchutzweste",1440,900);
		Elements.image[1] = Image:create(449, 327, 542, 89,"Files/Shops/Ammunation.png",1440,900);
		Elements.image[2] = Image:create(459, 426, 66, 64,"Files/HUD/Weapons/1.png",1440,900);
		Elements.image[3] = Image:create(535, 426, 66, 64,"Files/HUD/Weapons/5.png",1440,900);
		Elements.image[4] = Image:create(611, 426, 66, 64,"Files/HUD/Weapons/4.png",1440,900);
		Elements.image[5] = Image:create(687, 426, 66, 64,"Files/HUD/Weapons/22.png",1440,900);
		Elements.image[6] = Image:create(763, 426, 66, 64,"Files/HUD/Weapons/24.png",1440,900);
		Elements.image[7] = Image:create(839, 426, 66, 64,"Files/HUD/Weapons/33.png",1440,900);
		Elements.image[8] = Image:create(915, 426, 66, 64,"Files/HUD/Weapons/26.png",1440,900);
		Elements.image[9] = Image:create(459, 531, 66, 64,"Files/HUD/Weapons/27.png",1440,900);
		Elements.image[10] = Image:create(535, 531, 66, 64,"Files/HUD/Weapons/25.png",1440,900);
		Elements.image[11] = Image:create(611, 531, 66, 64,"Files/HUD/Weapons/28.png",1440,900);
		Elements.image[12] = Image:create(687, 531, 66, 64,"Files/HUD/Weapons/29.png",1440,900);
		Elements.image[13] = Image:create(763, 531, 66, 64,"Files/HUD/Weapons/31.png",1440,900);
		Elements.image[14] = Image:create(839, 531, 66, 64,"Files/HUD/Weapons/34.png",1440,900);
		Elements.image[15] = Image:create(915, 531, 66, 64,"Files/HUD/Weapons/Weste.png",1440,900);
		setWindowDatas();
	end
end)

-- [[ WAFFE KAUFEN ]] --

function buySchlagring()
	triggerServerEvent("Ammunation.buy",localPlayer,"Schlagring");
end

function buyBaseballschlaeger()
	triggerServerEvent("Ammunation.buy",localPlayer,"Baseballschläger");
end

function buyMesser()
	triggerServerEvent("Ammunation.buy",localPlayer,"Messer");
end

function buyColt()
	triggerServerEvent("Ammunation.buy",localPlayer,"Colt");
end

function buyDeagle()
	triggerServerEvent("Ammunation.buy",localPlayer,"Deagle");
end

function buyRifle()
	triggerServerEvent("Ammunation.buy",localPlayer,"Rifle");
end

function buySawnoff()
	triggerServerEvent("Ammunation.buy",localPlayer,"Sawnoff");
end

function buyCombat()
	triggerServerEvent("Ammunation.buy",localPlayer,"Combat");
end

function buyShotgun()
	triggerServerEvent("Ammunation.buy",localPlayer,"Shotgun");
end

function buyUzi()
	triggerServerEvent("Ammunation.buy",localPlayer,"Uzi");
end

function buyMp5()
	triggerServerEvent("Ammunation.buy",localPlayer,"Mp5");
end

function buyM4()
	triggerServerEvent("Ammunation.buy",localPlayer,"M4");
end

function buySniper()
	triggerServerEvent("Ammunation.buy",localPlayer,"Sniper");
end

function buySchutzweste()
	triggerServerEvent("Ammunation.buy",localPlayer,"Schutzweste");
end