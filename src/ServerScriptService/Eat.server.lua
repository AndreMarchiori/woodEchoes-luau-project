-- Services
local ProximityPromptService = game:GetService("ProximityPromptService")

-- Constant
local PROXIMITY_ACTION = "Eat"

-- Members
local PlayerModule = require(game.ServerStorage.Modules.PlayerModule)
local PlayerHungerUpdated: RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerHungerUpdated

local function playEatingSound()
    local eatingSound = Instance.new("Sound", game:GetService("Workspace"))
    eatingSound.SoundId = "rbxassetid://3043029786"
    local random = Random.new()
    local value = random:NextNumber(0.5, 1)

    eatingSound.Pitch = value
    eatingSound.Parent = workspace
    eatingSound:Play()
end

local function onPromptTriggered(promptObject:ProximityPrompt, player:Player)
    if promptObject.Name ~= PROXIMITY_ACTION then return end

    local foodModel = promptObject.Parent
    local foodValue = foodModel:GetAttribute("foodValue")
    
    playEatingSound()

    local currentHunger = PlayerModule.GetHunger(player)
    PlayerModule.SetHunger(player, currentHunger+foodValue)
    PlayerHungerUpdated:FireClient(player, PlayerModule.GetHunger(player))

    foodModel:Destroy()
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)