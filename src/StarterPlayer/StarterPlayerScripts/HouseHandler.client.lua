
--Members
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local homeStorage:Folder = ReplicatedStorage.HomeStorage
local PlayerLevelUp:RemoteEvent = ReplicatedStorage.Network.PlayerLevelUp

local function onPlayerLevelUp(level:number)
    for _, instance:Instance in workspace.Home:GetChildren() do
        if instance.Name == "1" or instance.Name == "Sign" then
            continue
        end
        instance:Destroy()
    end

    local home = homeStorage:FindFirstChild(level):Clone()
    home.Parent = workspace.Home
end

PlayerLevelUp.OnClientEvent:Connect(onPlayerLevelUp)