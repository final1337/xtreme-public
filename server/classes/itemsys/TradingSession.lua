TradingSession = inherit(Object)

function TradingSession:constructor(player, target)
    self.m_Player = player
    self.m_Target = target

    self.m_PlayerItems = {}
    self.m_TargetItems = {}

    self.m_PlayerReady = false
    self.m_TargetReady = false
end

function TradingSession:getPlayer() return self.m_Player end
function TradingSession:getTarget() return self.m_Target end

function TradingSession:getPlayerItems() return self.m_PlayerItems end
function TradingSession:getTargetItems() return self.m_TargetItems end

function TradingSession:getPlayerItemAmount()
    local i = 0

    for key, value in pairs(self.m_PlayerItems) do
        i = i + 1
    end

    return i
end

function TradingSession:getTargetItemAmount()
    local i = 0

    for key, value in pairs(self.m_TargetItems) do
        i = i + 1
    end
    
    return i
end

function TradingSession:setReadyState(id, bool)
    if id == "player" then
        self.m_PlayerReady = bool
    else
        self.m_TargetReady = bool
    end

end

function TradingSession:getReadyState(id)
    if id == "player" then
        return self.m_PlayerReady
    else
        return self.m_TargetReady
    end
end