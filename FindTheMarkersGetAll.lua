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
function highlight(part, color)
	if not part or not part:IsA("Model") and not part:IsA("Part") and not part:IsA("MeshPart") then
		return
	end
	local hfol = workspace:FindFirstChild("HF")
	if not hfol then
		hfol = Instance.new("Folder")
		hfol.Name = "HF"
		hfol.Parent = workspace
	end
	local h,s,v = color:ToHSV()
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.5
	highlight.OutlineColor = color
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromHSV(h, s, 1)
	if part ~= nil and part ~= game.workspace then
	highlight.Adornee = part
	end
	highlight.Parent = hfol
end
pcall(function()
getAll()
end)
