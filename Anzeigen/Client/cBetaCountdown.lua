BetaCountdown = true;

function BetaCountdownRender()
	local time = getRealTime();
	local hour,minute = time.hour,time.minute;
	if(hour < 10)then hour = "0"..hour end
	if(minute < 10)then minute = "0"..minute end
end

if(BetaCountdown == true)then
	addEventHandler("onClientRender",root,BetaCountdownRender);
end