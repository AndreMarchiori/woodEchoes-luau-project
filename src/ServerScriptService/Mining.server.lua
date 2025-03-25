-- Services
local ContentProvider = game:GetService("ContentProvider")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- Constant
local PROXIMITY_ACTION = "Mining"
local PICKAXE_SOUNDS = {"rbxassetid://7650230644", "rbxassetid://7650226201", "rbxassetid://7650220708", "rbxassetid://7650217335", "Pato"}

-- Members
local PlayerModule = require(game.ServerStorage.Modules.PlayerModule)
local PlayerInventoryUpdated:RemoteEvent = game.ReplicatedStorage.Network.PlayerInventoryUpdated
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://111600220704261"
local isPressing = false

ContentProvider:PreloadAsync({animation})

local function playPickaxeSound(promptObject:ProximityPrompt)
    local pickaxeSound = Instance.new("Sound", game:GetService("Workspace"))
    pickaxeSound.SoundId = PICKAXE_SOUNDS[math.random( 1, 4)]

    pickaxeSound.Parent = promptObject.Parent
    pickaxeSound:Play()
end

local function onPromptTriggered(promptObject:ProximityPrompt, player:Player)
    if promptObject.Name ~= PROXIMITY_ACTION then return end
    
    local miningModel = promptObject.Parent
    local miningValue = miningModel:FindFirstChildWhichIsA("NumberValue")
    PlayerModule.AddToInventory(player, miningValue.Name, miningValue.Value)
    PlayerInventoryUpdated:FireClient(player, PlayerModule.GetInventory(player))
end

local function onPromptHoldBegan(promptObject:ProximityPrompt, player:Player)
    if promptObject.Name ~= PROXIMITY_ACTION then
        return
    end
    isPressing = true

    local character = player.Character
    local humanoid = character.Humanoid

    local humanoidAnimator:Animator = humanoid.Animator
    local animationTrack:AnimationTrack = humanoidAnimator:LoadAnimation(animation)

    while isPressing do
        animationTrack:Play(nil, nil, 2.5)
        task.delay(.2, function()
            --playPickaxeSound(promptObject)
        end)

        wait(.5)
    end
end

local function onPromptHoldEnded(promptObject:ProximityPrompt, player:Player)
    if promptObject.Name ~= PROXIMITY_ACTION then
        return
    end
    isPressing = false
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)
ProximityPromptService.PromptButtonHoldBegan:Connect(onPromptHoldBegan)
ProximityPromptService.PromptButtonHoldEnded:Connect(onPromptHoldEnded)