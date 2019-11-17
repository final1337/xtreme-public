--

if(VariableDessenNamenDuNieErfahrenWirstWeilErVielZuLangIstLolTROLOLOLOL and VariableDessenNamenDuNieErfahrenWirstWeilErVielZuLangIstLolTROLOLOLOL == true)then

else
	triggerServerEvent("stopResource",localPlayer);
end

local Bars1,Bars2,Open,Alpha,AlphaNumber = 720,720,false,false,255;
setElementData(localPlayer,"loggedin",0);
fadeCamera(true);
RegisterLogin = {};
triggerServerEvent("RegisterLogin.checkAccount",localPlayer);
local Password = "";
local ShowPassword = "";

local ScreenSource = dxCreateScreenSource(x,y);
local BlackWhiteShader = dxCreateShader("Files/blackwhite.fx");

function RenderBlackWhiteShader()
	if(BlackWhiteShader)then
		dxUpdateScreenSource(ScreenSource);
		dxSetShaderValue(BlackWhiteShader,"ScreenSource",ScreenSource);
		dxDrawImage(0,0,x,y,BlackWhiteShader);
	end
end

function RegisterLogin.dxDrawBlackBars()
	if(Bars1 > 0 and Open == true)then Bars1 = Bars1 - 20 Bars2 = Bars2 + 20 end
    dxDrawRectangle(0*(x/1440), 0*(y/900), Bars1*(x/1440), 900*(y/900), tocolor(1, 0, 0, 255), false)
    dxDrawRectangle(Bars2*(x/1440), 0*(y/900), 720*(x/1440), 900*(y/900), tocolor(1, 0, 0, 255), false)
end

function RegisterLogin.dxDrawLogo()
	if(AlphaNumber > 0 and Alpha == true)then AlphaNumber = AlphaNumber - 5 end
	local ax,ay = interpolateBetween(0,-200,0,0,361,0,(getTickCount()-startRender)/3000,"OutBack");
    dxDrawImage(628*(x/1440), ay*(y/900), 184*(x/1440), 179*(y/900), "Files/Images/XtremeLogo.png", 0, 0, 0, tocolor(255, 255, 255, AlphaNumber), false)
	if(AlphaNumber == 0)then removeEventHandler("onClientRender",root,RegisterLogin.dxDrawLogo)end
end

addEvent("RegisterLogin.createWindow",true)
addEventHandler("RegisterLogin.createWindow",root,function(type)
	RegisterLogin.type = type;
	startRender = getTickCount();
	addEventHandler("onClientRender",root,RegisterLogin.dxDrawBlackBars);
	addEventHandler("onClientRender",root,RegisterLogin.dxDrawLogo);
	setElementData(localPlayer,"elementClicked",true);
	bartimer = setTimer(function()
		Open = true; Alpha = true;
		createBlackbBoxForChatbox("create");
	end,3000,1)
	setCameraMatrix(-1778.3509521484,1013.3497924805,184.78939819336,-1777.9047851563,1012.4898681641,184.5415802002);
	smoothMoveCamera(-1778.3509521484,1013.3497924805,184.78939819336,-1777.9047851563,1012.4898681641,184.5415802002,-1677.1295166016,840.07147216797,149.83090209961,-1676.6326904297,839.24133300781,149.57781982422,60000);
	showChat(false);
	setPlayerHudComponentVisible("all",false);
	bartimer2= setTimer(function()
		if(type == "Registrieren")then
			RegisterLogin.chatbox = Chatbox:addText("Herzlich willkommen auf Xtreme Reallife, "..getPlayerName(localPlayer)..".\nAnscheinend hast du noch keinen Account bei uns, also trage nun bitte dein Passwort ein und bestätige mit Enter, um dir einen zu erstellen.");
		else
			RegisterLogin.chatbox = Chatbox:addText("Herzlich willkommen zurück, "..getPlayerName(localPlayer)..".\nTippe nun dein Passwort ein und bestätige mit Enter, um dich in deinen Account einzuloggen.");
		end
		createContinueForChatbox("create");
		bindKey("enter","down",RegisterLogin.pressKeyForPassword);
		removeEventHandler("onClientRender",root,RegisterLogin.dxDrawBlackBars);
		removeEventHandler("onClientRender",root,RegisterLogin.dxDrawLogo);
	end,5000,1)
end)

function RegisterLogin.pressKeyForPassword()
	unbindKey("enter","down",RegisterLogin.pressKeyForPassword);
	RegisterLogin.chatbox:destroy();
	RegisterLogin.chatboxPW = Chatbox:addText("Passwort:");
	addEventHandler("onClientRender",root,RegisterLogin.dxDrawPassword);
	addEventHandler("onClientKey",root,inputPassword);
	bindKey("lshift","both",passwordOnShift);
	bindKey("rshift","both",passwordOnShift);
	bindKey("enter","down",RegisterLogin.pressTriggerServer);
end

function RegisterLogin.pressTriggerServer()
	if(#Password >= 4)then
		triggerServerEvent("RegisterLogin.server",localPlayer,RegisterLogin.type,Password);
	else infobox("Dein Passwort muss mindestens vier Zeichen lang sein!",120,0,0)end
end

addEvent("RegisterLogin.destroy",true)
addEventHandler("RegisterLogin.destroy",root,function()
	unbindKey("lshift","both",passwordOnShift);
	unbindKey("rshift","both",passwordOnShift);
	unbindKey("enter","down",pressTriggerServer);
	removeEventHandler("onClientRender",root,RegisterLogin.dxDrawPassword);
	removeEventHandler("onClientKey",root,inputPassword);
	if isTimer(bartimer) then
		killTimer(bartimer)
	end
	if isTimer(bartimer2) then
		removeEventHandler("onClientRender",root,RegisterLogin.dxDrawBlackBars);
		removeEventHandler("onClientRender",root,RegisterLogin.dxDrawLogo);		
		killTimer(bartimer2)
	end
	if RegisterLogin.chatBox then
		RegisterLogin.chatbox:destroy()
	end
	if RegisterLogin.chatboxPW then
		RegisterLogin.chatboxPW:destroy();
	end
	removeCamHandler();
	createContinueForChatbox();
	createBlackbBoxForChatbox();
	setPlayerHudComponentVisible("all",true);
	showChat(true);
	setElementData(localPlayer,"elementClicked",false);
	setRadarSettings()
	local language = config:get("Radar")
	if not language then
		config:set("Radar", "1")
		--// this variable gets modified again after the login
	end	
	if config:get("Radar") == "1" then
		hideRadar()
		setPlayerHudComponentVisible("radar", true)
	else
		showRadar()
	end
end)

function RegisterLogin.dxDrawPassword()
	dxDrawText(ShowPassword, 495*(x/1440), 784*(y/900), 946*(x/1440), 854*(y/900), tocolor(255, 255, 255, 255), 1.00*(y/900), XtremeFont, "center", "center", false, false, false, false, false)
end

function inputPassword(key,press)
	if(press)then
		local state = true;
		for _,v in pairs(NotAllowedKeys)do
			if(key == v)then
				state = false;
				break
			end
		end
		if(state == true)then
			if(key == "space")then
				Password = Password.." ";
			elseif(key == "backspace")then
				sub = string.sub(Password,1,#Password-1);
				Password = sub;
				
			else
				if(passwordShiftactive == true)then
					if(SpecialKeys[key])then
						key = SpecialKeys[key];
					else
						key = string.upper(key);
					end
				end
				Password = Password..key;
			end
			ShowPassword = "";
			for i = 1,#Password do
				ShowPassword = ShowPassword.."*";
			end
		end
	end
end

function passwordOnShift(key,state)
	if(state == "down")then
		passwordShiftactive = true;
	else
		passwordShiftactive = false;
	end
end