-- Services
local Players = game:GetService("Players")

--Members
local ServerStorage = game:GetService("ServerStorage")
local PlayerModule = require(ServerStorage.Modules.PlayerModule)
local PlayerInventoryUpdated: RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerInventoryUpdated

local function onCharacterAdded(character)
    local humanoid = character:FindFirstChild("Humanoid")

    if humanoid then
        humanoid.Died:Connect(function()
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                local inventory = PlayerModule.GetInventory(player)

                inventory.Stone -= math.round(inventory.Stone*.1)
                inventory.Copper -= math.round(inventory.Copper*.1)
                inventory.Wood -= math.round(inventory.Wood*.1)
                PlayerModule.SetInventory(player, inventory)
                PlayerInventoryUpdated:FireClient(player, PlayerModule.GetInventory())
            end
        end)
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(onPlayerAdded)