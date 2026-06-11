-- Please do not skid this
-- Scripted by 620_h
local wall = false
local loopBring
local aimPred = false
local plr = game.Players.LocalPlayer
function firstDecentant(a,b)
	for _,i in ipairs(a:GetDescendants()) do
		if i.Name == b then return i end
	end
end
function getClosest()
	local team = plr.Team
	local plrs = game.Players:GetPlayers()
	if #plrs == 1 then return end
	local lowest
	local myChar = plr.Character or plr.CharacterAdded:Wait()
	local myHrp = myChar:WaitForChild('HumanoidRootPart')
	for _,i in ipairs(plrs) do
		if i ~= plr then
			local char = i.Character
			local hrp = char:FindFirstChild('HumanoidRootPart')
			local params = RaycastParams.new()
			params.FilterDescendantsInstances = {myChar}
			params.FilterType = Enum.RaycastFilterType.Exclude
			local cast = workspace:Raycast(myHrp.CFrame.Position,(hrp.CFrame.Position - myHrp.CFrame.Position).Unit * 99999,params)
			local instance
			if cast then instance = cast.Instance end
			if char and (i.Team ~= team or #game.Teams:GetChildren() == 0) and (not wall or instance:FindFirstAncestor(char.Name)) then
				if hrp then
					local p = hrp.CFrame.Position
					local distance = (myHrp.Position - p).Magnitude
					if not lowest or lowest.studs > distance then lowest = {plr = i,studs = distance} end
				end
			end
		end
	end
	if lowest then return lowest['plr'] end
end
function shoot(p)
	local char = plr.Character or plr.CharacterAdded:Wait()
	local gun = char:FindFirstChildWhichIsA('Tool')
	if gun and gun:FindFirstChild("GunServer") then
		gun.GunServer.ShootStart:FireServer(1,p)
	else
		local GunServer = firstDecentant(plr.Backpack,'GunServer')
		if not GunServer then return end
		local lgun = GunServer.Parent
		local hum = char:WaitForChild('Humanoid')
		hum:EquipTool(lgun)
		GunServer.ShootStart:FireServer(1,p)
	end
end
function getPos(a,vol)
	local char = a.Character
	if char then
		local hrp = char:WaitForChild('HumanoidRootPart')
		if vol then return hrp.CFrame.Position + Vector3.new(hrp.Velocity.X / 5,hrp.Velocity.Y / 9,hrp.Velocity.Z / 5) else return hrp.CFrame.Position end
	end
end
function gayCube(a)
	local char =  plr.Character
	if not char then return end
	local part = Instance.new("Part",workspace)
	local hue = 0
	part.Size = Vector3.new(1.5,1.5,1.5)
	part.Anchored = true
	local rs = game.RunService.RenderStepped:Connect(function()
		if a.Character then
			part.CFrame = CFrame.new(getPos(a,true))
		end
	end)
	local gay = task.spawn(function()
		while true do
			part.Color = Color3.fromHSV(hue, 1, 1)
			if hue > 1 then hue = 0 else hue = hue + 0.01 end 
			task.wait(.05)
		end
	end)
	char.AncestryChanged:Connect(function(_,_)
		task.cancel(gay)
		rs:Disconnect()
		part:Destroy()
	end)
end
function kill(a)
	local char = plr.Character
	local aChar = a.Character
	if char and aChar then
		local hrp = char:WaitForChild("HumanoidRootPart")
		local ahrp = aChar:WaitForChild('HumanoidRootPart')
		local ogpos = hrp.CFrame
		hrp.CFrame = CFrame.new(getPos(a,false) + (ahrp.CFrame.LookVector * -2))
		task.wait(.2)
		shoot(getPos(a,true))
		task.wait(.25)
		hrp.CFrame = ogpos
	end
end
function chat(str) game.TextChatService.TextChannels.RBXGeneral:SendAsync(str) end
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("MM2 Aim Trainer", "DarkTheme")
local mainT = Window:NewTab("Main")
local main = mainT:NewSection("Main")
getgenv().TrashTalk = false

local toggle = main:NewToggle("Auto Trash Talk", "Info",function(state)
    getgenv().TrashTalk = state
end)
local active
local listeners = {}
local toggle = main:NewToggle("ESP", "Info",function(state)
	active = state
    if state then
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
		local function listen(a)
			local char = a.Character or a.CharacterAdded:Wait()
			local team = a.Team
			local h
			if #game.Teams:GetChildren() == 0 then
				h = highlight(char,clr)
			else
				local myTeam = plr.Team
				if myTeam == team then h = highlight(char,Color3.new(0,1,0)) else h = highlight(char,Color3.new(1,0,0)) end
			end
			local died = function()
				local hum = char:WaitForChild("Humanoid")
				local lis = hum.Died:Connect(function()
					local hue,s,_ = die:ToHSV()
					h.FillColor = Color3.fromHSV(hue, s, 1)
					h.OutlineColor = die
				end)
				table.insert(listeners, lis)
			end
			local l = a.CharacterAdded:Connect(function(newchar)
				char = newchar
				h:Destroy()
				h = highlight(newchar,clr)
				died()
			end)
			table.insert(listeners, l)
			died()
			local lis = a.AncestryChanged:Connect(function(_,_)
				h:Destroy()
				l:Disconnect()
			end)
			table.insert(listeners, lis)
		end
		for _,i in ipairs(game.Players:GetPlayers()) do
			if i ~= game.Players.LocalPlayer then listen(i) end
		end
		local plrAdded = game.Players.PlayerAdded:Connect(listen)
		table.insert(listeners, plrAdded)
		else
			workspace['fol']:Destroy()
			for _,i in ipairs(listeners) do
				if i.Connected then i:Disconnect() end
			end
	end

end)
plr.leaderstats.Kills.Changed:Connect(function()
	local insults = {'ez','EZ GAMEE','IMAGINE DYING LOL', 'YOUR DEAD LOL','HAHA EZ','aired', 'lol ez', 'lol aired'}
	if getgenv().TrashTalk then
		local insult = insults[math.random(1,#insults)]
		task.wait((#insult / 8) + 1)
		chat(insult)
	end
end)
main:NewKeybind("Shoot Closest Player", "", Enum.KeyCode.R, function()
    local a = getClosest()
	if a then shoot(getPos(a,aimPred)) end
end)
main:NewButton("Kill Closest Player (GUN ONLY)", "ButtonInfo", function()
    local a = getClosest()
	if a then kill(a) end
end)
main:NewToggle("Aim Prediction (Recommended)", "ToggleInfo", function(state)
	aimPred = state
end)
main:NewToggle("Wall Check (Recommended)", "Only shoot if user is not behind a wall", function(state)
	wall = state
end)
main:NewToggle("Loop Bring all (Client)", "ToggleInfo", function(state)
	if state then
		loopBring = game.RunService.RenderStepped:Connect(function()
			local plrHrp = plr.Character:FindFirstChild("HumanoidRootPart")
			if plrHrp then
				for _,i in ipairs(game.Players:GetPlayers()) do
					if i ~= plr then
						local char = i.Character
						if char then
							local hrp = char:FindFirstChild('HumanoidRootPart')
							if hrp then
								hrp.Anchored = true
								hrp.CFrame = plrHrp.CFrame + (hrp.CFrame.LookVector * 2.5)
							end
						end
					end
				end
			end
		end)
	else
		loopBring:Disconnect()
		for _,i in ipairs(game.Players:GetPlayers()) do
			if i ~= plr then
				local char = i.Character
				if char then
					local hrp = char:WaitForChild('HumanoidRootPart')
					hrp.Anchored = false
				end
			end
		end
	end
end)

local set = Window:NewTab("Settings"):NewSection("Section Name")
set:NewKeybind("Toggle", "", Enum.KeyCode.LeftControl, function()
	Library:ToggleUI()
end)
