local PlayerInventoryUpdated: RemoteEvent = game:GetService("ReplicatedStorage").Network.PlayerInventoryUpdated

-- Services
local  Players = game:GetService("Players")

-- CONSTANTS

-- Members
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud = PlayerGui:WaitForChild("HUD")
local SideBar:Frame = hud:WaitForChild("SideBar")
local InventoryUi:Frame = SideBar:WaitForChild("Inventory")
local InventoryButton:ImageButton = InventoryUi:WaitForChild("InventoryButton")

local InventoryPanel:Frame = hud:WaitForChild("InventoryPanel")
local InventoryPanelOriginalPosition = InventoryPanel.Position.X.Scale

local FirstPosition = UDim2.fromScale(InventoryPanelOriginalPosition, InventoryPanel.Position.Y.Scale)
local SecondPosition = UDim2.fromScale(-1, InventoryPanel.Position.Y.Scale)

local isVisible = false
InventoryPanel.Position = SecondPosition
InventoryPanel.Visible = true

local stoneNumber:TextLabel = InventoryPanel.Stone.Number
local copperNumber:TextLabel = InventoryPanel.Copper.Number
local woodNumber:TextLabel = InventoryPanel.Wood.Number


InventoryButton.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    if isVisible then
        InventoryPanel:TweenPosition(FirstPosition,  Enum.EasingDirection.Out, Enum.EasingStyle.Sine)
    else
        InventoryPanel:TweenPosition(SecondPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quint)
    end

end)

PlayerInventoryUpdated.OnClientEvent:Connect(function(inventory:table)
    stoneNumber.Text = inventory.Stone and inventory.Stone or 0
    copperNumber.Text = inventory.Copper and inventory.Copper or 0
    woodNumber.Text = inventory.Wood and inventory.Wood or 0
end)
