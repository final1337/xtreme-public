--

Levelsystem = {needExp = 250};

-- [[ ERFAHRUNGSPUNKTE VERGEBEN ]] --

function Levelsystem.givePoints(player,points)
	local points = math.floor(points);
	local level = getElementData(player,"Level")+1;
	setElementData(player,"Erfahrungspunkte",getElementData(player,"Erfahrungspunkte")+points);
	setElementData(player,"ErfahrungspunkteZumAusgeben",getElementData(player,"ErfahrungspunkteZumAusgeben")+points);
	local nextLevel = Levelsystem.needExp*level;
	if(getElementData(player,"Erfahrungspunkte") >= nextLevel)then
		setElementData(player,"Erfahrungspunkte",0);
		setElementData(player,"Level",getElementData(player,"Level")+1);
	end
end