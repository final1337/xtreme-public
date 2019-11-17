

XtremeFont = dxCreateFont("Files/Fonts/Xtreme.ttf",15);

Window = {}; Button = {}; Gridlist = {}; Edit = {}; Text = {}; Image = {}; Rectangle = {};
x,y = guiGetScreenSize();
Elements = {window = {}, button = {}, gridlist = {}, edit = {}, text = {}, image = {}, rectangle = {}};

function isWindowOpen()
	if(Elements.window[1] or getElementData(localPlayer,"elementClicked") == true)then
		return false
	else
		return true
	end
end

function setWindowDatas()
	showCursor(true);
	setElementData(localPlayer,"elementClicked",true);
	if(isElement(GUIEditor.window[1]))then
		centerWindow(GUIEditor.window[1]);
		guiWindowSetMovable(GUIEditor.window[1],false);
		guiWindowSetSizable(GUIEditor.window[1],false);
	end
	if(isElement(GUIEditor.label[1]))then
		for i = 1,#GUIEditor.label do
			guiSetFont(GUIEditor.label[i],"default-bold-small");
			guiLabelSetHorizontalAlign(GUIEditor.label[i],"center",true);
			guiLabelSetVerticalAlign(GUIEditor.label[i],"center");
		end
	end
	guiSetInputMode("no_binds");
end

function isCursorOnElement( posX, posY, width, height )
	if isCursorShowing( ) then
		local mouseX, mouseY = getCursorPosition( )
		local clientW, clientH = guiGetScreenSize( )
		local mouseX, mouseY = mouseX * clientW, mouseY * clientH
		if ( mouseX > posX and mouseX < ( posX + width ) and mouseY > posY and mouseY < ( posY + height ) ) then
			return true
		end
	end
	return false
end

--/* Window functions

function Window:create(x,y,w,h,title,gx,gy)
	local self = setmetatable({},{__index = self});
	self.x = x; self.y = y; self.w = w; self.h = h;
	self.title = title;
	self.gx = gx; self.gy = gy;
	self.render = function() self:onRender() end
	addEventHandler("onClientRender",root,self.render);
	Elements.button["Close"] = Button:create(x+(w-35),y+7.5,20,20,"X","dxClassClose",gx,gy);
	return self;
end

function Window:onRender()
	dxDrawRectangle(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),self.h*(y/self.gy),tocolor(0,0,0,150),true); -- Main window
	dxDrawRectangle(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),60*(y/self.gy),tocolor(0,0,0,175),true); -- Black bar
	dxDrawText(self.title,self.x*(x/self.gx),(self.y+17.5)*(y/self.gy),(self.x+self.w)*(x/self.gx),self.h*(y/self.gy),tocolor(255,255,255,255),1.00*(y/self.gy),XtremeFont,"center","top",_,_,true); -- Title
end

function Window:destroy()
	removeEventHandler("onClientRender",root,self.render);
	self = nil;
end

--/* Button functions

function Button:create(x,y,w,h,title,callfunc,gx,gy)
	local self = setmetatable({},{__index = self});
	self.x = x; self.y = y; self.w = w; self.h = h;
	self.r = 0; self.g = 0; self.b = 0;
	self.title = title;
	self.callfunc = callfunc;
	self.gx = gx; self.gy = gy;
	self.render = function() self:onRender() end
	self.click = function(button,state) self:onClick(button,state) end
	addEventHandler("onClientRender",root,self.render);
	addEventHandler("onClientClick",root,self.click);
	return self;
end

function Button:onRender()
	dxDrawRectangle(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),self.h*(y/self.gy),tocolor(self.r,self.g,self.b,175),true); -- Main rectangle
	dxDrawText(self.title,self.x*(x/self.gx),self.y*(y/self.gy),(self.x+self.w)*(x/self.gx),(self.y+self.h)*(y/self.gy),tocolor(255,255,255,255),1.00*(y/self.gy),"default-bold","center","center",_,_,true); -- Title
	dxDrawLine(self.x*(x/self.gx),self.y*(y/self.gy),(self.x+self.w-1)*(x/self.gx),self.y*(y/self.gy),tocolor(255,255,255,255),1,true); -- Line top
	dxDrawLine(self.x*(x/self.gx),(self.y+self.h-1)*(y/self.gy),(self.x+self.w-1)*(x/self.gx),(self.y+self.h-1)*(y/self.gy),tocolor(255,255,255,255),1,true); -- Line below
	dxDrawLine(self.x*(x/self.gx),self.y*(y/self.gy),self.x*(x/self.gx),(self.y+self.h-1)*(y/self.gy),tocolor(255,255,255,255),1,true); -- Line left
	dxDrawLine((self.x+self.w-1)*(x/self.gx),self.y*(y/self.gy),(self.x+self.w-1)*(x/self.gx),(self.y+self.h-1)*(y/self.gy),tocolor(255,255,255,255),1,true); -- Line right

	if(isCursorOnElement(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),self.h*(y/self.gy)))then self.r = 235; self.g = 117; self.b = 0 else self.r = 0; self.g = 0; self.b = 0; end
end

function Button:onClick(button,state)
	if(button == "left" and state == "down")then
		if(isCursorOnElement(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),self.h*(y/self.gy)))then
			triggerEvent(self.callfunc,localPlayer);
		end
	end
end

function Button:destroy()
	removeEventHandler("onClientRender",root,self.render);
	removeEventHandler("onClientClick",root,self.click);
	self = nil;
end

function Button:getText(text)
	return self.title;
end

function Button:setText(text)
	self.title = text;
end

--*/ Edit functions

function Edit:create(x,y,w,h,gx,gy)
	local self = setmetatable({},{__index = self});
	self.x = x; self.y = y; self.w = w; self.h = h;
	self.text = "";
	self.active = false;
	self.shiftactive = false;
	self.gx = gx; self.gy = gy;
	self.render = function() self:onRender() end
	self.click = function(button,state) self:onClick(button,state) end
	self.shift = function(key,state) self:onShift(key,state) end
	bindKey("lshift","both",self.shift);
	bindKey("rshift","both",self.shift);
	addEventHandler("onClientRender",root,self.render);
	addEventHandler("onClientClick",root,self.click);
	return self;
end

function Edit:destroy()
	removeEventHandler("onClientRender",root,self.render);
	removeEventHandler("onClientClick",root,self.click);
	unbindKey("lshift","both",self.shift);
	unbindKey("rshift","both",self.shift);
	self = nil;
end

function Edit:onRender()
	dxDrawRectangle(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),self.h*(y/self.gy),tocolor(220,220,220,255),true); -- Main rectangle
	dxDrawText(self.text,self.x*(x/self.gx),self.y*(y/self.gy),(self.x+self.w)*(x/self.gx),(self.y+self.h)*(y/self.gy),tocolor(0,0,0,255),1.00*(y/self.gy),"default-bold","center","center",_,_,true); -- Text
	if(self.active == true)then
		dxDrawLine(self.x*(x/self.gx),self.y*(y/self.gy),(self.x+self.w-1)*(x/self.gx),self.y*(y/self.gy),tocolor(0,0,0,255),1,true); -- Line top
		dxDrawLine(self.x*(x/self.gx),(self.y+self.h)*(y/self.gy),(self.x+self.w)*(x/self.gx),(self.y+self.h)*(y/self.gy),tocolor(0,0,0,255),1,true); -- Line below
		dxDrawLine(self.x*(x/self.gx),self.y*(y/self.gy),self.x*(x/self.gx),(self.y+self.h)*(y/self.gy),tocolor(0,0,0,255),1,true); -- Line left
		dxDrawLine((self.x+self.w)*(x/self.gx),self.y*(y/self.gy),(self.x+self.w)*(x/self.gx),(self.y+self.h-0)*(y/self.gy),tocolor(0,0,0,255),1,true); -- Line right
	end
end

function Edit:onClick(button,state)
	if(button == "left" and state == "down")then
		if(isCursorOnElement(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),self.h*(y/self.gy)))then
			self.active = true;
		else
			self.active = false;
		end
	end
end

NotAllowedKeys = {"mouse1","mouse2","mouse3","mouse4","mouse5","mouse_wheel_up","mouse_wheel_down","arrow_l","arrow_u","arrow_r","arrow_D","num_0","num_1","num_2","num_3","num_4","num_5","num_6","num_7","num_8","num_9","num_mul","num_add","num_sep","num_sub","num_div","num_dec","num_enter","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","escape","tab","lalt","ralt","enter","pgup","pgdn","end","home","insert","delete","lctrl","rctrl","[","]","pause","capslock","scroll","lshift","rshift", "-", ".", "+", "*", "/", "%"};
SpecialKeys = {["1"] = "!",["2"] = '"',["3"] = "§",["4"] = "$",["5"] = "%",["6"] = "&",["7"] = "/",["8"] = "(",["9"] = ")",["0"] = "="};

function EditInput(key,press)
	if(press)then
		if(#Elements.edit >= 1)then
			for _,v in pairs(Elements.edit)do
				if(v.active == true)then
					edit = v;
					break
				end
			end
			if(edit)then
				local state = true;
				for _,v in pairs(NotAllowedKeys)do
					if(key == v)then
						state = false;
						break
					end
				end
				if(state == true)then
					if(key == "space")then
						edit.text = edit.text.." ";
					elseif(key == "backspace")then
						sub = string.sub(edit.text,1,#edit.text-1);
						edit.text = sub;
					else
						if(edit.shiftactive == true)then
							if(SpecialKeys[key])then
								key = SpecialKeys[key];
							else
								key = string.upper(key);
							end
						end
						edit.text = edit.text..key;
					end
				end
			end
		end
	end
end
addEventHandler("onClientKey",root,EditInput)

function Edit:onShift(key,state)
	if(self.active == true)then
		if(state == "down")then
			self.shiftactive = true;
		else
			self.shiftactive = false;
		end
	end
end

function Edit:getText() return self.text; end

function Edit:setText(text)
	self.text = "";
end

--/* Text functions

function Text:create(x,y,w,h,text,gx,gy)
	local self = setmetatable({},{__index = self});
	self.x = x; self.y = y; self.w = w; self.h = h;
	self.text = text;
	self.gx = gx; self.gy = gy;
	self.render = function() self:onRender() end
	addEventHandler("onClientRender",root,self.render);
	return self;
end

function Text:onRender()
	dxDrawText(self.text,self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),self.h*(y/self.gy),tocolor(255,255,255,255),1.00*(y/self.gy),"arial","center","center",_,true,true); -- Text
end

function Text:destroy()
	removeEventHandler("onClientRender",root,self.render);
	self = nil;
end

function Text:setText(text)
	self.text = text;
end

--/* Image functions

function Image:create(x,y,w,h,image,gx,gy)
	local self = setmetatable({},{__index = self});
	self.x = x; self.y = y; self.w = w; self.h = h;
	self.image = image;
	self.gx = gx; self.gy = gy;
	self.render = function() self:onRender() end
	addEventHandler("onClientRender",root,self.render);
	return self;
end

function Image:onRender()
	dxDrawImage(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),self.h*(y/self.gy),self.image,0,0,0,_,true);
end

function Image:destroy()
	removeEventHandler("onClientRender",root,self.render);
	self = nil;
end

--/* Rectangle functions

function Rectangle:create(x,y,w,h,r,g,b,alpha,gx,gy)
	local self = setmetatable({},{__index = self});
	self.x = x; self.y = y; self.w = w; self.h = h;
	self.gx = gx; self.gy = gy;
	self.alpha = alpha;
	self.r = r; self.g = g; self.b = b;
	self.render = function() self:onRender() end
	addEventHandler("onClientRender",root,self.render);
	return self;
end

function Rectangle:onRender()
	dxDrawRectangle(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),self.h*(y/self.gy),tocolor(self.r,self.g,self.b,self.alpha),true);
end

function Rectangle:destroy()
	removeEventHandler("onClientRender",root,self.render);
	self = nil;
end

--/* Gridlist functions

function Gridlist:create(x,y,w,h,items,gx,gy)
	local self = setmetatable({},{__index = self});
	self.x = x; self.y = y; self.w = w; self.h = h;
	self.gx = gx; self.gy = gy;
	self.scroll = 0;
	self.gridlistSlots = (self.h/20)-1;
	self.clickedItem = "";
	self.items = items[2];
	self.gridlistTitle = items[1];
	self.clicked = {nil,nil,nil,nil};
	self.render = function() self:onRender() end
	self.click = function(button,state) self:onClick(button,state) end
	addEventHandler("onClientRender",root,self.render);
	addEventHandler("onClientClick",root,self.click);
	return self;
end

function Gridlist:onRender()
	dxDrawRectangle(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),self.h*(y/self.gy),tocolor(0,0,0,175),true);
	dxDrawRectangle(self.x*(x/self.gx),self.y*(y/self.gy),self.w*(x/self.gx),20*(y/self.gy),tocolor(250,100,0,125),true);
	dxDrawText(" "..self.gridlistTitle,self.x*(x/self.gx),self.y*(y/self.gy),self.x+self.w*(x/self.gx),20*(y/self.gy),tocolor(255,255,255,255),1.00*(y/self.gy),"arial","left","top",_,_,true);
	if(self.clicked[1] ~= nil)then
		dxDrawRectangle(self.clicked[1],self.clicked[2],self.clicked[3],self.clicked[4],tocolor(255,255,255,75),true);
	end
	for i = 1+self.scroll,self.gridlistSlots+self.scroll do
		dxDrawRectangle(self.x*(x/self.gx),(self.y+i*20)*(y/self.gy),self.w*(x/self.gx),20*(y/self.gy),tocolor(250,50+(i*5),0,125),true);
		if(self.items[i])then
			dxDrawText(" "..self.items[i],self.x*(x/self.gx),(self.y+i*20)*(y/self.gy),self.x+self.w*(x/self.gx),20*(y/self.gy),tocolor(255,255,255,255),1.00*(y/self.gy),"arial","left","top",_,_,true);
		end
	end
end

function Gridlist:onClick(button,state)
	if(button == "left" and state == "down")then
		for i = 1+self.scroll,self.gridlistSlots+self.scroll do
			if(isCursorOnElement(self.x*(x/self.gx),(self.y+i*20)*(y/self.gy),self.w*(x/self.gx),20*(y/self.gy)))then
				self.clicked = {self.x*(x/self.gx),(self.y+i*20)*(y/self.gy),self.w*(x/self.gx),20*(y/self.gy)};
				self.clickedItem = self.items[i];
				break
			end
		end
	end
end

function Gridlist:getClicked()
	return self.clickedItem;
end

function Gridlist:destroy()
	removeEventHandler("onClientRender",root,self.render);
	removeEventHandler("onClientClick",root,self.click);
	self = nil;
end

function Gridlist:setItems(items)
	self.items = items[2];
	self.gridlistTitle = items[1];
end

--/* Close function

function dxClassClose(button,state)
	if(#Elements.button >= 1)then for i = 1,#Elements.button do if(Elements.button[i])then Elements.button[i]:destroy() end end end
	if(Elements.button["Close"])then Elements.button["Close"]:destroy() end
	if(Elements.window[1])then Elements.window[1]:destroy() end
	if(#Elements.edit >= 1)then for i = 1,#Elements.edit do Elements.edit[i]:destroy() end end
	if(#Elements.text >= 1)then for i = 1,#Elements.text do Elements.text[i]:destroy() end end
	if(#Elements.image >= 1)then for i = 1,#Elements.image do Elements.image[i]:destroy() end end
	if(#Elements.rectangle >= 1)then for i = 1,#Elements.rectangle do Elements.rectangle[i]:destroy() end end
	if(#Elements.gridlist >= 1)then for i = 1,#Elements.gridlist do Elements.gridlist[i]:destroy() end end
	showCursor(false);
	guiSetInputMode("allow_binds");
    
    destroyWindow("Fahrschule")

	Elements = {window = {}, button = {}, gridlist = {}, edit = {}, text = {}, image = {}, rectangle = {}};
	setTimer(function()
		setElementData(localPlayer,"Clicked", false)
		setElementData(localPlayer,"elementClicked",false);
	end,500,1)
end
addEvent("dxClassClose",true)
addEventHandler("dxClassClose",root,dxClassClose)