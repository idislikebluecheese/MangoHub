-- scripted by 620_h
-- please no skidding!
local fol = game:GetService("ReplicatedStorage").Markers
local char = game.Players.LocalPlayer.Character
function getAll()
	if char then
		local hrp = char.HumanoidRootPart
		for _,i in ipairs(fol:GetChildren()) do
			local marker = i.Value
			if not marker then continue end
			for _,j in ipairs(marker:GetChildren()) do
				if j:IsA("Part") and j:FindFirstChildWhichIsA("TouchTransmitter") then
					j.CanCollide = false
					hrp.Velocity = Vector3.zero
					hrp.CFrame = j.CFrame
					task.wait(.1)
					char.Humanoid.PlatformStand = false
					char.Humanoid:MoveTo(j.CFrame.Position)
					task.wait(.15)
					break
				end
			end
		end
	end
end
pcall(function()
getAll()
end)
