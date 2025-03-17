local PlayerModule = {}
-- Services
local Players = game:GetService("Players") --- Players Service
local DSService = game:GetService("DataStoreService") --- DataStore Service

-- CONSTANTS
local PLAYER_DEFAULT_DATA = {
    hunger = 100,
    inventory = {},
    level = 1
}

-- Members
local playersCached = {} --- Dictionary with all players
local ds = DSService:GetDataStore("WoodEchos DSv.A1")

function PlayerModule.Isloaded(player:Player) : boolean
    local Isloaded = playersCached[player.UserId] and true or false
    return Isloaded
end

--- Sets the hunger of the given player
function PlayerModule.SetHunger(player:Player, hunger:number)
    playersCached[player.UserId].hunger = hunger
end

--- Gets the hunger of the given player
function PlayerModule.GetHunger(player: Player)
    return playersCached[player.UserId].hunger    
end



local function onPlayerAdded(player: Player)
    player.CharacterAdded:Connect(function(_)
        local data = ds:GetAsync(player.UserId)
        if not data then
            data = PLAYER_DEFAULT_DATA
        end

        playersCached[player.UserId] = data
    end)
end

local function onPlayerRemoving(player: Player)
    ds:SetAsync(player.UserId, playersCached[player.UserId])
    playersCached[player.UserId] = nil
end


Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

return PlayerModule