--fuck forsaken
--game id: 7669979046
-- scripted by 620_h
local plr = game.Players.LocalPlayer
local fol = workspace.stuff
local giver
local union = workspace:FindFirstChild("Union")
if union then union:Destroy() end
for _,i in ipairs(fol:GetChildren()) do
	if i:IsA("Part") and i.Name == "Part" and i:FindFirstChild("TouchInterest") then
		giver = i
		break
	end
end
while plr.Character.Humanoid.Health > 0 do
	giver.CFrame = plr.Character.HumanoidRootPart.CFrame
	task.wait(0.05)
end
