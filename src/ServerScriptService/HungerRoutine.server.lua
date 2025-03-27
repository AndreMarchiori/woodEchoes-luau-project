local PlayerModule = require(game:GetService("ServerStorage").Modules.PlayerModule)

-- CONSTANTS
local CORE_LOOP_INTERVAL = 4
local HUNGER_DECREMENT = 1

-- Members
local PlayerLoaded: BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerLoaded
local PlayerUnloaded: BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerUnloaded
local PlayerHungerUpdated: RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerHungerUpdated

local function coreLoop(player: Player)
	-- Whether or not the routine should run
	local isRunning = true

	-- Listen to the PlayerUnloaded event to stop this thread
	PlayerUnloaded.Event:Connect(function(playerUnloaded: Player)
		if playerUnloaded == player then
			isRunning = false
		end
	end)

	-- Main Loop
	while true do
		if not isRunning then
			break
		end

		local currentHunger = PlayerModule.GetHunger(player)
		PlayerModule.SetHunger(player, currentHunger - HUNGER_DECREMENT)

		-- Notify Client
		PlayerHungerUpdated:FireClient(player, PlayerModule.GetHunger(player))
		local humanoid = player.Character:WaitForChild("Humanoid")
		
		if PlayerModule.GetHunger(player) <= 10 then
			humanoid.Health -= 5
			humanoid.WalkSpeed = 12
            if humanoid.Health == 0 then
                PlayerModule.SetHunger(player, 100)
            end
		else
			humanoid.WalkSpeed = 18
		end
		wait(CORE_LOOP_INTERVAL)
	end
end

local function onPlayerLoaded(player: Player)
	spawn(function()
		coreLoop(player)
	end)
end

PlayerLoaded.Event:Connect(onPlayerLoaded)