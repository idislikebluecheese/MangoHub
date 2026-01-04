-- game name: "just impossible obby"
--game id: 9315244790
-- scripted by 620_h
local plr = game.Players.LocalPlayer
local rm = game:GetService("ReplicatedStorage").PushEvent
local tool = Instance.new("Tool")
tool.Name = "Push tool"
tool.RequiresHandle = false
tool.Parent = plr.Backpack
tool.Activated:Connect(function()
	local mouse = plr:GetMouse()
	local char = mouse.Target:FindFirstAncestorOfClass("Model")
	if char then
		local targ = game.Players:GetPlayerFromCharacter(char)
		rm:FireServer(targ)
	end
	end)
