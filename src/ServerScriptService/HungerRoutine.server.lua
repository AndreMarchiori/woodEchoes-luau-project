local PlayerModule = require(game:GetService("ServerStorage").Modules.PlayerModule)
local PlayerLoaded: BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerLoaded
local PlayerUnloaded: BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerUnloaded

-- CONSTANTS
local CORE_LOOP_INTERVAL = 2
local HUNGER_DECREMENT = 1

local function coreLoop(player: Player)
    -- Whether or not the routine should run
    local isRunning = true

    -- Listen to the PlayerUnloaded event to stop this thread
    PlayerUnloaded.Event:Connect(function(playerUnloaded: Player)
        if playerUnloaded == player then
            print("Parou somente para o jogador ", player)
            isRunning = false
        end
    end)
    
    -- Main Loop
	while true do
        if not isRunning then break end

		local currentHunger = PlayerModule.GetHunger(player)
		PlayerModule.SetHunger(player, currentHunger - HUNGER_DECREMENT)

		wait(CORE_LOOP_INTERVAL)
	end
end

local function onPlayerLoaded(player: Player)
	spawn(function()
		coreLoop(player)
	end)
end

PlayerLoaded.Event:Connect(onPlayerLoaded)
