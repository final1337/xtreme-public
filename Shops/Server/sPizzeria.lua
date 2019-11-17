--

-- [[ TABLES ]] --

Pizza = {};

-- [[ HINSETZEN ]] --

addEvent("Pizza.sitdown",true)
addEventHandler("Pizza.sitdown",root,function()
	local dim = getFreeDimension();
	setElementPosition(client,379.3639831543,-124.57615661621,1001.9309692383);
	setPedRotation(client,180);
	setElementDimension(client,dim);
	setElementFrozen(client,true);
	setPedAnimation(client,"food","FF_Sit_Eat1");
end)

-- [[ AUFGEGESSEN ]] --

addEvent("Pizza.finish",true)
addEventHandler("Pizza.finish",root,function(health)
	local health = tonumber(health);
	setElementHealth(client,getElementHealth(client)+health);
	setElementFrozen(client,false);
	setPedAnimation(client);
	setElementPosition(client,377.88265991211,-123.38684844971,1001.4921875);
	setPedRotation(client,90);
	setElementDimension(client,getElementData(client,"Pizza.oldDim"));
	infobox(client,"Du hast aufgegessen.",0,120,0);
end)