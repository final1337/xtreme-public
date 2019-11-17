GUIEditboxManager = inherit(Singleton)

function GUIEditboxManager:constructor()
    self.m_DummyBox = GuiEdit(0, 0, 1, 1, "", false)
    
    self.m_DummyBox:setAlpha(0)
    guiSetInputEnabled(false)

    GUIEditboxManager.ms_SelectedBox = false

    addEventHandler("onClientGUIChanged", root, bind(self.Event_OnClientGUIChanged, self))
    addEventHandler("onClientGUIBlur",    root, bind(self.Event_onClientGUIBlur, self))
    addEventHandler("onClientRender",     root, bind(self.Event_OnClientRender, self))
end

function GUIEditboxManager:Event_OnClientRender()
    if GUIEditboxManager.ms_SelectedBox then
        local box = GUIEditboxManager.ms_SelectedBox
        local oldPosition = box:getCaretPosition()
        box:setCaretPosition(guiEditGetCaretIndex(self.m_DummyBox))
        if box:getCaretPosition() ~= oldPosition then
            box:sthChanged()
        end
    end
end

function GUIEditboxManager:setBox(box)
    if GUIEditboxManager.ms_SelectedBox then
        if GUIEditboxManager.ms_SelectedBox ~= box then
            if GUIEditboxManager.ms_SelectedBox.onFocusLose then
                GUIEditboxManager.ms_SelectedBox:onFocusLose()
            end
            GUIEditboxManager.ms_SelectedBox = false
        end
    end

    if box then
        guiBringToFront(self.m_DummyBox)

        if box.onFocusGain then
            box:onFocusGain()
        end

        box:setStatus(true)
        guiSetText(self.m_DummyBox, box:getText())
        guiEditSetCaretIndex(self.m_DummyBox, #box:getText())

        GUIEditboxManager.ms_SelectedBox = box

        guiSetInputEnabled(true)
        return
    end
    guiSetInputEnabled(false)
    guiMoveToBack(self.m_DummyBox)
end

function GUIEditboxManager:Event_OnClientGUIChanged()
    if not GUIEditboxManager.ms_SelectedBox then return end
    local box = GUIEditboxManager.ms_SelectedBox
    box:setCaretPosition(guiEditGetCaretIndex(self.m_DummyBox))
    box:setText(guiGetText(self.m_DummyBox)) 
    box:tryChange()
end

function GUIEditboxManager:Event_onClientGUIBlur()
    if not GUIEditboxManager.ms_SelectedBox then return end
    local box = GUIEditboxManager.ms_SelectedBox
    GUIEditboxManager.ms_SelectedBox = false
    box:setStatus(false)
    if box.onFocusLose then
        box:onFocusLose()
    end
    guiSetInputEnabled(false)
    guiMoveToBack(self.m_DummyBox)
    box:sthChanged()
end