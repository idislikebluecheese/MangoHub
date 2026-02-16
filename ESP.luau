--[[
	DONT FUCKING SKID
	scripted by 620_h
]]
if getgenv()['esp_loaded'] then 
	warn('ESP Already Loaded!')
	return
end
getgenv()['esp_loaded'] = true
--#VARS#
local clr = Color3.new(1,0,0)
local die = Color3.new(0.2,0.2,0.2)
local fol = workspace:FindFirstChild("fol") or Instance.new("Folder",workspace)
fol.Name = "fol"

local function highlight(part, color)
	if not part or not part:IsA("Model") and not part:IsA("Part") and not part:IsA("MeshPart") then
		return
	end
	local h,s,_ = color:ToHSV()
	local highlight = Instance.new("Highlight")
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = color
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Name = "plr"
	highlight.FillColor = Color3.fromHSV(h, s, 1)
	if part ~= nil and part ~= game.workspace then
		highlight.Adornee = part
	end
	highlight.Parent = fol
	return highlight
end
local function listen(plr)
	local char = plr.Character or plr.CharacterAdded:Wait()
	local h = highlight(char,clr)
	local died = function()
		local hum = char:WaitForChild("Humanoid")
		hum.Died:Connect(function()
			local hue,s,_ = die:ToHSV()
			h.FillColor = Color3.fromHSV(hue, s, 1)
			h.OutlineColor = die
			print('die')
		end)
	end
	local l = plr.CharacterAdded:Connect(function(newchar)
		char = newchar
		h:Destroy()
		h = highlight(newchar,clr)
		died()
	end)
	died()
	plr.AncestryChanged:Connect(function(_,_)
		h:Destroy()
		l:Disconnect()
	end)
end
for _,i in ipairs(game.Players:GetPlayers()) do
	if i ~= game.Players.LocalPlayer then listen(i) end
end
game.Players.PlayerAdded:Connect(listen)
