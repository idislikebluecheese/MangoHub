-- scripted by 620_h
-- please no skidding
local fol = game:GetService("ReplicatedStorage").Markers
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
function main()
	local start = os.clock()
	task.defer(function()
		local CT = os.clock() - start
		print(string.format("%.9f", CT / 1000))
	end)
	local data = game:GetService("ReplicatedStorage").PackagedRepStorage.PackagedEvents.GetMarkerdexData:Invoke()
	local hfol = workspace:FindFirstChild("HF")
	if hfol then
		hfol:ClearAllChildren()
	end
	for _,i in ipairs(fol:GetChildren()) do
		local marker = i.Value
		if not marker then continue end
		local clr = Color3.new(0,1,0)
		for _,j in ipairs(data) do
			if i.Name == j then
				clr = Color3.new(1,0,0)
				break
			end
		end
		highlight(marker,clr)
	end
end
pcall(function()
  main()
  end)
