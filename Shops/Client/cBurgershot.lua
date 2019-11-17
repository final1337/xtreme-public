--

-- [[ TABLES ]] --

Burgershot = {};

-- [[ FENSTER ÖFFNEN ]] --

addEvent("Burgershot.openWindow",true)
addEventHandler("Burgershot.openWindow",root,function()
	if(isWindowOpen())then
		Elements.window[1] = Window:create(577, 353, 286, 194,"Burgershot",1440,900);
		Elements.image[1] = Image:create(587, 422, 82, 77,"Files/Images/Shops/Burger1.png",1440,900);
		Elements.image[2] = Image:create(679, 422, 82, 77,"Files/Images/Shops/Burger2.png",1440,900);
		Elements.image[3] = Image:create(771, 422, 82, 77,"Files/Images/Shops/Burger3.png",1440,900);
		Elements.button[1] = Button:create(587, 509, 82, 28,"Bleender\nMeal - 3€","buyBleenderMeal",1440,900);
		Elements.button[2] = Button:create(679, 509, 82, 28,"Money Shot\nMeal - 5€","buyMoneyShotMeal",1440,900);
		Elements.button[3] = Button:create(771, 509, 82, 28,"Torpedo\nMeal - 8€","buyTorpedoMeal",1440,900);
		setWindowDatas();
	end
end)

-- [[ ARTIKEL KAUFEN ]] --

function buyBleenderMeal()
	triggerServerEvent("Burgershot.buy",localPlayer,"Bleeder Meal");
end

function buyMoneyShotMeal()
	triggerServerEvent("Burgershot.buy",localPlayer,"Money Shot Meal");
end

function buyTorpedoMeal()
	triggerServerEvent("Burgershot.buy",localPlayer,"Torpedo Meal");
end