-- Services
local PlayerHungerUpdated: RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerHungerUpdated
local  Players = game:GetService("Players")

-- CONSTANTS

-- Members
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("HUD")
local statusBar:Frame = hud:WaitForChild("StatusBar")
local hungerUi:Frame = statusBar:WaitForChild("Hunger")
local hungerBar:Frame = hungerUi:WaitForChild("Bar")

PlayerHungerUpdated.OnClientEvent:Connect(function(hunger: number)
    -- updates the hunger bar X axis size
    hungerBar.Size = UDim2.fromScale(hunger/100, hungerBar.Size.Y.Scale)
end)