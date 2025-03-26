--Members
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network:Folder = ReplicatedStorage:WaitForChild("Network")
local InGameTimeUpdated = Network:WaitForChild("InGameTimeUpdated")

InGameTimeUpdated.OnClientEvent:Connect(function(actualTime:number)
    game.Lighting:SetMinutesAfterMidnight(actualTime)
end)