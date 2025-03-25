-- Services
local Players = game:GetService("Players")
local SocialService = game:GetService("SocialService")

-- CONSTANTS

-- Members
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local hud:ScreenGui = PlayerGui:WaitForChild("HUD")
local inviteFriends:TextButton = hud:WaitForChild("InviteFriends")

-- Function to check whether the player can send an invite
local function canSendGameInvite(sendingPlayer)
	local success, canSend = pcall(function()
		return SocialService:CanSendGameInviteAsync(sendingPlayer)
	end)
	return success and canSend
end



inviteFriends.Activated:Connect(function()
    local canInvite = canSendGameInvite(player)
    if canInvite then
        SocialService:PromptGameInvite(player)
    end    
end)