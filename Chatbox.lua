
Chatbox = {};

-- Chatbox
function Chatbox:addText(text)
	local self = setmetatable({},{__index = self});
	self.text = text;
	self.activeText = "";
	self.count = 0; self.speedCount = 0;
	self.render = function() self:onRender() end
	addEventHandler("onClientRender",root,self.render);
	return self;
end

function Chatbox:onRender()
	dxDrawText(self.activeText, 10*(x/1440), 679*(y/900), 1430*(x/1440), 853*(y/900), tocolor(255, 255, 255, 255), 1.00*(y/900), XtremeFont, "center", "center", false, true, false, false, false)
	self:nextLetter();
end

function Chatbox:nextLetter()
	if(self.count < #self.text)then
		self.speedCount = self.speedCount + 1;
		if(self.speedCount >= 2)then
			self.count = self.count + 1;
			local letter = string.sub(self.text,self.count,self.count);
			self.activeText = self.activeText..letter;
			local s = playSound("Files/Sounds/Keyboard.mp3",false);
			setSoundVolume(s,0.3);
			self.speedCount = 0;
		end
	end
end

function Chatbox:destroy()
	removeEventHandler("onClientRender",root,self.render);
	self = nil;
end

-- Chatbox background
function createBlackbBoxForChatbox(type)
	chatboxStartRender = getTickCount();
	if(type == "create")then
		addEventHandler("onClientRender",root,renderBlackBoxForChatbox);
	else
		removeEventHandler("onClientRender",root,renderBlackBoxForChatbox);
	end
end

function renderBlackBoxForChatbox()
	local ax,ay = interpolateBetween(-1500,0,0,0,0,0,(getTickCount()-chatboxStartRender)/5000,"OutQuad");
	dxDrawRectangle(ax*(x/1440), 669*(y/900), 1440*(x/1440), 194*(y/900), tocolor(0, 0, 0, 175), false)
end

-- Continue
function createContinueForChatbox(type)
	if(type == "create")then
		continueAlpha = 0;
		addEventHandler("onClientRender",root,renderContinueForChatbox);
	else
		removeEventHandler("onClientRender",root,renderContinueForChatbox);
	end
end

function renderContinueForChatbox()
	if(continueAlpha < 255)then continueAlpha = continueAlpha + 5 end
	dxDrawText("#ffffffDrücke #f06400Enter#ffffff, um fortzufahren.", 570*(x/1440), 822*(y/900), 870*(x/1440), 847*(y/900), tocolor(255, 255, 255, continueAlpha), 1.00, "default-bold", "center", "center", false, false, false, true, false)
end