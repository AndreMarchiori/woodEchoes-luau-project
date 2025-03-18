-- Services
local PlayerHungerUpdated: RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerHungerUpdated
local  Players = game:GetService("Players")

-- CONSTANTS

-- Members
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("HUD")
--TODO 13min
PlayerHungerUpdated.OnClientEvent:Connect(function(hunger: number)
    
end)