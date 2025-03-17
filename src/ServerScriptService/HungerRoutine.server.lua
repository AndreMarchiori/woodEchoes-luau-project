local Players = game:GetService("Players")
local PlayerModule = require(game:GetService("ServerStorage").Modules.PlayerModule)

-- CONSTANTS
local CORE_LOOP_INTERVAL = 2
local HUNGER_DECREMENT = 1

local function coreLoop(player:Player)
    while true do
        if PlayerModule.Isloaded(player) then
            local currentHunger = PlayerModule.GetHunger(player)
            PlayerModule.SetHunger(player, currentHunger - HUNGER_DECREMENT)
        end
        wait(CORE_LOOP_INTERVAL)
    end
end

local function onPlayerAdded(player:Player)
    spawn(function()
        coreLoop(player)
    end)
end

local function onPlayerRemoving(player:Player)
    print(PlayerModule.GetHunger(player))
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)