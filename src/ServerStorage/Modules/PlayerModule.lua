local PlayerModule = {}
-- Services
local Players = game:GetService("Players") --- Players Service
local DSService = game:GetService("DataStoreService") --- DataStore Service

-- CONSTANTS
local PLAYER_DEFAULT_DATA = {
	hunger = 100,
	inventory = {
        Stone = 0,
        Copper = 0,
        Wood = 0
    },
	level = 1,
}

-- Members
local playersCached = {} --- Dictionary with all players
local ds = DSService:GetDataStore("WoodEchos DSv.A1")
local PlayerLoaded: BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerLoaded
local PlayerUnloaded: BindableEvent = game:GetService("ServerStorage").BindableEvents.PlayerUnloaded
local PlayerInventoryUpdated: RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerInventoryUpdated
local PlayerHungerUpdated: RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerHungerUpdated

-- Normalizes the hunger value
function normalizeHunger(hunger: number): number
	if hunger < 0 then
		hunger = 0
	end
	if hunger > 100 then
		hunger = 100
	end

	return hunger
end

function PlayerModule.GetInventory(player: Player)
	return playersCached[player.UserId].inventory
end

function PlayerModule.SetInventory(player: Player, inventory: table)
	playersCached[player.UserId].inventory = inventory
end

function PlayerModule.AddToInventory(player: Player, key: string, value: number)
	local inventory = playersCached[player.UserId].inventory

	if inventory[key] then
		inventory[key] += value
		return
	end

	inventory[key] = value
end

--- Sets the hunger of the given player
function PlayerModule.SetHunger(player: Player, hunger: number)
	hunger = normalizeHunger(hunger)
	playersCached[player.UserId].hunger = hunger
end

--- Gets the hunger of the given player
function PlayerModule.GetHunger(player: Player)
	local hunger = normalizeHunger(playersCached[player.UserId].hunger)
	return hunger
end

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(function(_)
		local data = ds:GetAsync(player.UserId)
		if not data then
			data = PLAYER_DEFAULT_DATA
		end

		playersCached[player.UserId] = data
		-- Player is fully Loaded
		PlayerLoaded:Fire(player)

		PlayerHungerUpdated:FireClient(player, PlayerModule.GetHunger(player))
		PlayerInventoryUpdated:FireClient(player, PlayerModule.GetInventory(player))
	end)
end

local function onPlayerRemoving(player: Player)
	PlayerUnloaded:Fire(player)
	ds:SetAsync(player.UserId, playersCached[player.UserId])
	playersCached[player.UserId] = nil
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

return PlayerModule
