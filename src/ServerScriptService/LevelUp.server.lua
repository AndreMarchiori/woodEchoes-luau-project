-- Services
local ProximityPromptService = game:GetService("ProximityPromptService")

-- Members
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerModule = require(ServerStorage.Modules.PlayerModule)
local PlayerLevelUp:RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerLevelUp
local PlayerInventoryUpdated: RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerInventoryUpdated
local particleTemplate = ReplicatedStorage:WaitForChild("Particulas")
local Placa = game.Workspace.Home.Sign

-- Constant
local PROXIMITY_ACTION = "Upgrade"
local LEVEL_CAP = 3
local RESOURCES_REQUIRED = {
    [1] = {
        Stone = 50,
        Copper = 10,
        Wood = 100
    },
    [2] = {
        Stone = 500,
        Copper = 200,
        Wood = 400
    }
}

-- Detect when prompt is triggered
local function onPromptTriggered(promptObject:ProximityPrompt, player:Player)
    if promptObject.Name ~= PROXIMITY_ACTION then return end

    local inventory = PlayerModule.GetInventory(player)
    local level = PlayerModule.GetLevel(player)

    local require = RESOURCES_REQUIRED[level] 

    if not inventory.Stone or not inventory.Copper or not inventory.Wood or level == 3 then return end
    if inventory.Stone <= require.Stone then
        print("Not Enough Stone")
        return
    end

    if inventory.Copper <= require.Copper then
        print("Not Enough Copper")
        return
    end

    if inventory.Wood >= require.Wood then
        print("Not Enough Wood")
        return
    end

    inventory.Stone -= require.Stone
    inventory.Copper -= require.Copper
    inventory.Wood -= require.Wood

    PlayerModule.SetLevel(player, level + 1)
    PlayerLevelUp:FireClient(player, PlayerModule.GetLevel(player))
    PlayerInventoryUpdated:FireClient(player, PlayerModule.GetInventory(player))

    if particleTemplate then
        local newParticle = particleTemplate:Clone()
        newParticle.Parent = Placa
        newParticle.Enabled = true
        delay(1, function()
            newParticle.Enabled = false
            task.wait(1)
            newParticle:Destroy()
        end)
    end
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)