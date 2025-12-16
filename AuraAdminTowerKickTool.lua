-- DONT SKID!!!!!
-- scripted by 620_h
-- GAMEID: 9223443716
-- Name: Aura Admin Tower
local tool = Instance.new("Tool")
local backpack = game.Players.LocalPlayer:WaitForChild("Backpack")
tool.RequiresHandle = false
tool.Parent = backpack
tool.Name = "Kick Tool"
local plr = game.Players.LocalPlayer
local GUI = game:GetService("StarterGui")
tool.Activated:Connect(function()
	local mouse = plr:GetMouse().Target
	local plr = game.Players:GetPlayerFromCharacter(mouse.Parent)
	if plr then
		GUI:SetCore("SendNotification", {
    		Title = "Player Kicked";
    		Text = plr.Name .. " has been kicked";
    		Duration = 3.5; 
		})
		game:GetService("ReplicatedStorage").KickPlayerRemote:FireServer(plr)
	end
end)
GUI:SetCore("SendNotification", {
    Title = "Kick Tool Loaded";
    Text = "scripted by 620_h";
    Duration = 3.5; 
})
