local SPAWNBOT_NAME = "spawnbot"
local SPOT = Vector(0, 0, 0)

local function handleScout(player)
    player:SetAbsOrigin(SPOT)
end

function ScoutLogicGate()
    -- find the first real player who is a scout
    for _, player in pairs(ents.GetAllPlayers()) do
        if player:IsRealPlayer() and player.m_iClass == 1 then
            handleScout(player)
            return
        end
    end

    -- no scout player found
    local spawnbot = ents.FindByName(SPAWNBOT_NAME)
    spawnbot:Enable()
end