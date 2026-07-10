--OPEN SOURCE
local uis = game:GetService("UserInputService")
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Mango Hub Rainbow Friends 2", "DarkTheme")
local mainT = Window:NewTab("Main")
local plrT = Window:NewTab("Player")
local ESP = Window:NewTab("ESP")
local setT = Window:NewTab("Settings")
local set = setT:NewSection("Settings")
local espS = ESP:NewSection("ESP")
local main = mainT:NewSection("Main")
local plrS = plrT:NewSection("Player")
local plr = game.Players.LocalPlayer
monsters = workspace.Monsters
local ignore = workspace.ignore
local validItems = {'Looky','CakeMix','LightBulb','GasCanister'}
function getItems()
	local item = ignore:FindFirstChild('Looky') or workspace:FindFirstChild('CakeMix') or workspace:FindFirstChild('LightBulb') or workspace:FindFirstChild('GasCanister')
	local fol = workspace
	local items = {}
	if item.Name == 'Looky' then fol = ignore end
	for _,i in next,fol:GetChildren() do
		if i.Name == item.Name then table.insert(items,i) end
	end
	return items
end

function esp(part)
	local monsterClrs = {Green = Color3.new(0,1,0),Blue = Color3.new(0,0,1),Bird = Color3.new(1,1,0),Cyan = Color3.new(0,1,1),Purple = Color3.new(1,0,1)}
	local hfol = workspace:FindFirstChild('highlights') or Instance.new("Folder",workspace)
	hfol.Name = 'highlights'
	local function getEsp()
		local bill = Instance.new('BillboardGui',hfol)
		bill.Size = UDim2.new(0, 100, 0, 150)
		bill.StudsOffset = Vector3.new(0, 1, 0)
		bill.AlwaysOnTop = true
		bill.Adornee = part
		local name = Instance.new('TextLabel',bill)
		name.TextStrokeTransparency = 0
		name.ZIndex = 9999
		name.Size = UDim2.new(0, 100, 0, 100)
		name.BackgroundTransparency = 1
		name.TextColor3 = Color3.new(1,1,1)
		local highlight = Instance.new('Highlight',hfol)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Adornee = part
		return name,highlight
	end
	if part.Parent == monsters then
		local name,h = getEsp()
		local clr = monsterClrs[part.Name]
		local hue,s,_ = clr:ToHSV()
		name.TextStrokeColor3 = clr
		if part.Name ~= 'Bird' then
			name.Text = part.Name .. ' | Monster'
		else
			name.Text = 'Yellow | Monster'
		end
		h.FillColor = Color3.fromHSV(hue,s,1)
		h.OutlineColor = clr
	elseif table.find(validItems,part.Name) then
		local name,h = getEsp()
		local clr = Color3.new(0,1,0)
		local hue,s,_ = clr:ToHSV()
		name.TextStrokeColor3 = clr
		name.Text = part.Name .. ' | Item'
		h.FillColor = Color3.fromHSV(hue,s,1)
		h.OutlineColor = clr
	elseif game.Players:GetPlayerFromCharacter(part) then
		local name,h = getEsp()
		local clr = Color3.new(1,0,0)
		local hue,s,_ = clr:ToHSV()
		name.TextStrokeColor3 = clr
		name.Text = '@' .. part.Name .. ' | Player'
		h.FillColor = Color3.fromHSV(hue,s,1)
		h.OutlineColor = clr
		local die = Color3.new(.2,.2,.2)
		local hum = part:WaitForChild('Humanoid')
		hum.Died:Once(function()
			h.OutlineColor = die
			local hue,s,_ = die:ToHSV()
			h.FillColor = Color3.fromHSV(hue,s,1)
			name.TextStrokeColor3 = die
		end)
	end
end
function collectItems()
	for _,i in next,getItems() do
		local part = i:QueryDescendants('TouchTransmitter')[1].Parent
		local char = plr.Character
		if char then
			local hum = char:WaitForChild('HumanoidRootPart')
			firetouchinterest(hum,part,0)
		end
	end
end
local list = {}
function getEspList()
	for _,i in next,monsters:GetChildren() do esp(i) end
	for _,i in next,game.Players:GetPlayers() do
		if i ~= plr then
			esp(i.Character)
			table.insert(list,i.CharacterAdded:Connect(esp))
		end
	end
	table.insert(list,monsters.ChildAdded:Connect(esp))
	table.insert(list,workspace.ChildAdded:Connect(esp))
	table.insert(list,ignore.ChildAdded:Connect(esp))
	for _,i in next,getItems() do esp(i) end
end
function bringCar()
	local car
	for _,i in next,workspace:GetChildren() do
		if i.Name == 'Chassis' and i:FindFirstChild('VehicleSeat') then
			local vs = i:FindFirstChild('VehicleSeat')
			if not vs.Occupant then
				car = i
				break
			end	
		end
	end
	local char = plr.Character
	if char and car then
		local hrp = char:WaitForChild('HumanoidRootPart')
		local hum = char:WaitForChild('Humanoid')
		local vs = car:WaitForChild('VehicleSeat')
		local pp = vs:FindFirstChildWhichIsA('ProximityPrompt')
		local t = tick()
		local ogPos = hrp.CFrame
		repeat
			hrp.CFrame = vs.CFrame - Vector3.new(0,-1,0)
			task.spawn(function()
				fireproximityprompt(pp, 8)
			end)
			task.wait()
		until vs.Occupant == hum or tick() - t > 5
		t = tick()
		repeat
			hrp.CFrame = ogPos
			car:PivotTo(ogPos)
			task.wait()
		until tick() - t > .5
	end
end
main:NewButton("Bring Kart", "ButtonInfo", bringCar)
main:NewButton("Collect All Items", "ButtonInfo", collectItems)
main:NewButton("Collect And Return All Items", "ButtonInfo", function()
	local items = getItems()
	local char = plr.Character
	collectItems()
	task.wait(.1)
	local hrp = char:WaitForChild('HumanoidRootPart')
	local ogPos = hrp.CFrame
	hrp.CFrame = CFrame.new(54, 139, -6)
	task.wait(.05)
	hrp.CFrame = ogPos
end)
local ejList
local ijList
plrS:NewToggle("Enable jump", "ToggleInfo", function(state)
    if state then
        local char = plr.Character
		local hum = char:WaitForChild('Humanoid')
		hum.UseJumpPower = true
		ejList = uis.JumpRequest:Connect(function()
			hum:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		end)
    else
        ejList:Disconnect()
    end
end)
plrS:NewToggle("Infinite jump", "ToggleInfo", function(state)
    if state then
        local char = plr.Character
		local hum = char:WaitForChild('Humanoid')
		hum.UseJumpPower = true
		ijList = uis.JumpRequest:Connect(function()
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end)
    else
        ijList:Disconnect()
    end
end)
local ws = 16
local wsList
plrS:NewSlider("WalkSpeed", "SliderInfo", 100, 16, function(s)
    plr.Character.Humanoid.WalkSpeed = s
	ws = s
end)
local lws
plrS:NewToggle("Loop WalkSpeed", "", function(state)
	lws = state
	if state then
		local char = plr.Character
		if char then
			local hum = char:WaitForChild('Humanoid')
			repeat
				hum.WalkSpeed = ws
				task.wait()
			until not lws
		end
	end
end)
espS:NewToggle("Highlight All", "", function(state)
    if state then
		getEspList()
    else
        for _,i in next,list do if i.Connected then i:Disconnect() end end
		workspace.highlights:Destroy()
    end
end)
set:NewKeybind("Toggle", "KeybindInfo", Enum.KeyCode.LeftControl, function()
	Library:ToggleUI()
end)
