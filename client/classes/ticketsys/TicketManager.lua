TicketManager = inherit(Singleton)

function TicketManager:constructor()
    self.m_GUI = TicketGUI:new()
end