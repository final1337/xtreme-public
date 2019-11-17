TextQuery = inherit(Singleton)

addEvent("XTM:TextQuery", true)


TextQuery.WIDTH = screenWidth / 3
TextQuery.HEIGHT = screenHeight / 5

function TextQuery:constructor()

	local w,h = TextQuery.WIDTH, TextQuery.HEIGHT

	self.m_Window = GUIWindow:new(screenWidth / 2 - w/2, screenHeight / 4 - h/2, w, h, "Xtreme - Entscheidungsfrage", true)

	self.m_Background = GUIRectangle:new(0, 24, w, h - 24, self.m_Window)
	self.m_Background:setColor(50,50,50)

	w,h = self.m_Background:getWidth(), self.m_Background:getHeight()

	GUIRectangle:new(w* 0.1 - 2, h*0.1 - 2, w*0.8 + 4, h*0.2 + 4, self.m_Background):setColor(0,0,0,0)
	self.m_FontBackground = GUIRectangle:new (w* 0.1, h*0.1, w*0.8, h*0.2, self.m_Background)
	self.m_FontBackground:setColor(0,0,0,0)

	self.m_Font = GUILabel:new("?",0,0, w*0.8, h*0.2, self.m_FontBackground)
	self.m_Font:setAlignX("center")
	self.m_Font:setAlignY("center")
	self.m_Font:setFont("default-bold")
	self.m_Font:setScale(1)
	self.m_Font:setColor(255,255,255)
	self.m_Font:setWordBreak(true)
	
	--GUIRectangle:new(w* 0.1 - 2, h*0.35 - 2, w*0.8 + 4, h*0.2 + 4, self.m_Background):setColor(0,0,0)
	self.m_Edit = GUIEditbox:new(w* 0.1, h*0.35, w*0.8, h*0.2, self.m_Background)

	self.m_YesButton = GUIClassicButton:new("KekTest", w/16, h*0.7, w/2 - w/16*2, h*0.2, self.m_Background)

	self.m_NoButton  = GUIClassicButton:new("Kektest", w - w/2 + w/16, h*0.7, w/2 - w/16*2, h*0.2, self.m_Background)

	self.m_YesButton.onLeftUp = bind(self.onYesClick, self)
	self.m_NoButton.onLeftUp = bind(self.onNoclick, self)

	self.m_HandleEvent = false
	self.m_AnswerIsClientSide = false
	self.m_Active = false

    self.m_YesCallBack = false
    self.m_NoCallBack = false

    self.m_Window:setVisible(false)

	-- addEventHandler("onClientRender", root, bind(self.draw, self))
end

function TextQuery:draw()
	if self.m_Active then
		showCursor(true)
	end
end

function TextQuery:onYesClick()
    if self.m_YesCallBack then
        self.m_YesCallBack(self.m_Edit:getText())
    end
	self:deactiviateFrame()
end

function TextQuery:onNoclick()
    if self.m_NoCallBack then
        self.m_NoCallBack(self.m_Edit:getText())
    end
	self:deactiviateFrame()
end

function TextQuery:deactiviateFrame()
	self.m_Window:setVisible(false)	
	self.m_Active = false
end


function TextQuery:Event_BinaryQuery(generalText, yesText, noText, yesHandle, noHandle)
	showCursor(true)
	self.m_Edit:setText("")
	self.m_Active = true
	self.m_Window:setVisible(true)	
	self.m_YesButton.m_Text:setText(yesText)
	self.m_NoButton.m_Text:setText(noText)
	self.m_Font:setText(generalText)
    self.m_YesCallBack = yesHandle
    self.m_NoCallBack = noHandle
    self.m_Edit:setFocused()
    
    Renderer:getSingleton():focused(self.m_Window)
end

function TextQuery:start(...)
    if self.m_Window.m_Visible then
        if self.m_NoCallBack then
            self.m_NoCallBack()
        end
    end
	self:Event_BinaryQuery(...)
end

function TextQuery:destructor()
	-- Give the event a negative answer, so none is going to abuse this for instance a bug
	if self.m_Active then
		self:onNoclick()
	end
end

