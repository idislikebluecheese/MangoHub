--[[
i have worked so hard on this script
please dont FUCKING skid this
you can modify it but at least give me credit

note: i will be constantly adding updates
- "620_h"
]]
local chatremove
local loopfb
local nameespnt
local ogChar
local clone
local circleChanged
local flyspeed = 1
local spinSpeed = 1
local cam = workspace.Camera
local iip
local ffc
local ewrc = false
local bp = 'Torso'
local circle
local cr = 1
function inCircle(worldPos,circle)
	local pos,vis = cam:WorldToViewportPoint(worldPos)
	if not vis then return false end
	local rad = circle.Radius
	local cpos = circle.Position
	if (pos.X >= cpos.X - rad and pos.X <= cpos.X + rad) and (pos.Y >= cpos.Y - rad and pos.Y <= cpos.Y + rad) then return true end
	return false
end
function getPos(a,vol)
	local char = a.Character
	if bp == 'Head' then part = 'Head' else part = 'HumanoidRootPart' end
	if char then
		local hrp = char:FindFirstChild(part)
		if hrp then if vol then return hrp.CFrame.Position + Vector3.new(hrp.Velocity.X / 5,hrp.Velocity.Y / 9,hrp.Velocity.Z / 5) else return hrp.CFrame.Position end end
	end
end
function lookAtCam(p)
	if p then
		cam.CFrame = CFrame.lookAt(cam.CFrame.Position, p)
	end
end
local serv = setmetatable({}, {
	__index = function(_,i)
		local s,v = pcall(function()
			return game:GetService(i)
		end)
		if s then return v end
	end
})
local collection = serv.CollectionService
local lighting = serv.Lighting
local ts = serv.TeleportService
local plr = serv.Players.LocalPlayer
local uis = serv.UserInputService
local runservice = serv.RunService
local tcs = serv.TextChatService
local right = false
local rightEnum = Enum.UserInputType.MouseButton2
local legacyChat = tcs.ChatVersion == Enum.ChatVersion.LegacyChatService
function chat(msg)
	if legacyChat then
		game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,'All')
	else
		tcs.TextChannels.RBXGeneral:SendAsync(msg)
	end
end
uis.InputBegan:Connect(function(input,g)
	--if g then return end
	if input.UserInputType == rightEnum then right = true end
end)
uis.InputEnded:Connect(function(input,g)
	--if g then return end
	if input.UserInputType == rightEnum then right = false end
end)
function lookWithCam(hrp)
	if hrp then
		local pos = hrp.CFrame.Position
		return CFrame.lookAt(pos,pos + cam.CFrame.LookVector)
	end
end
local keys = {W = false,A = false,S = false,D = false,E = false,Q = false}
function toMod(s)
	speed = (s + 10) * 10
	local modifier = {X = 0,Y = 0,Z = 0}
	local function boolToNum(b)
		if b then return 1 else return 0 end
	end
	modifier.X = modifier.X + (speed * boolToNum(keys.D))
	modifier.X = modifier.X - (speed * boolToNum(keys.A))
	modifier.Y = modifier.Y - (speed * boolToNum(keys.Q))
	modifier.Y = modifier.Y + (speed * boolToNum(keys.E))
	modifier.Z = modifier.Z + (speed * boolToNum(keys.S))
	modifier.Z = modifier.Z - (speed * boolToNum(keys.W))
	return Vector3.new(modifier.X,modifier.Y,modifier.Z)
end
local allowed = {'W','A','S','D','E','Q'}
uis.InputBegan:Connect(function(input,gp)
	if gp or not table.find(allowed,input.KeyCode.Name) then return end
	keys[input.KeyCode.Name] = true
end)
uis.InputEnded:Connect(function(input,gp)
	if gp or not table.find(allowed,input.KeyCode.Name) then return end
	keys[input.KeyCode.Name] = false
end)
function getFlyLoop()
	local char = plr.Character
	local hrp = char:WaitForChild('HumanoidRootPart')
	local hum = char:WaitForChild('Humanoid')
	local pos = hrp.CFrame.Position
	local function newLoop()
		local char = plr.Character
		local hrp = char:WaitForChild('HumanoidRootPart')
		return runservice.Heartbeat:Connect(function(dt)
				local rotation = lookWithCam(hrp)
				local mod = toMod(flyspeed) * dt
				local worldMove = rotation:VectorToWorldSpace(mod)
				pos += worldMove
				hrp.CFrame = CFrame.new(pos) * rotation.Rotation
				--hrp.Anchored = false -- doesnt show for other players if true
				hrp.Velocity = Vector3.zero
				hum.PlatformStand = true
			end)
	end
	local loop = newLoop()
	local loops
	loops = {loop,plr.CharacterAdded:Connect(function()
		loop:Disconnect()
		loop = newLoop()
		table.insert(loops,loop)
	end)}
	return loops
end
function noclipTick()
	for _, child in pairs(plr.Character:GetDescendants()) do
		if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
			child.CanCollide = false
		end
	end
end
function turnLoop()
	local char = plr.Character or plr.CharacterAdded:Wait()
	local hrp = char:WaitForChild('HumanoidRootPart')
	local amount = 0
	local function turnFunc(dt)
		amount += (dt * 150) * spinSpeed
		if amount > 360 then amount = 0 end
		hrp.CFrame = CFrame.Angles(0,math.rad(amount),0) + hrp.CFrame.Position
	end
	local loop = runservice.RenderStepped:Connect(turnFunc)
	local loops
	loops = {loop,plr.CharacterAdded:Connect(function(char)
		loop:Disconnect()
		hrp = char:WaitForChild('HumanoidRootPart')
		loop = runservice.RenderStepped:Connect(turnFunc)
		table.insert(loops,loop)
	end)}
	return loops
end
local platform = uis:GetPlatform()
local devices = {OSX = 'PC/Mac'; Windows = 'PC/Windows'; IOS = 'Mobile/IPhone'; Android = 'Mobile/Android'; XBoxOne = 'Console/XBOX'; PS4 = 'Console/Playstation 4'; PS5 = 'Console/Playstation 5'}
function getPing() return plr:GetNetworkPing() * 1000 end
local fpsTotal = 0
local fpsDisplay = 0
local counter = runservice.RenderStepped:Connect(function()
    fpsTotal = fpsTotal + 1
end)
task.spawn(function()
    while task.wait(1) do
        fpsDisplay = math.floor(fpsTotal)
        fpsTotal = 0
    end
end)
function lookAt(pos)
    local char = plr.Character
    if char then
        local hum = char:FindFirstChild('HumanoidRootPart')
        if hum then hum.CFrame = CFrame.lookAt(hum.CFrame.Position, CFrame.new(pos.X, hum.CFrame.Position.Y, pos.Z).Position) end
    end
end
function getPlayTime()
	local function formatNum(n)
		local nString = tostring(math.floor(n))
		local prefix = ''
		local len = 2 - #nString
		for i=1,len do prefix = prefix .. '0' end
		return prefix .. nString
	end
	local t = time()
	local min = t / 60
	local hour = min / 60
	local sec = t % 60
	return ('%s:%s:%s'):format(formatNum(hour),formatNum(min % 60),formatNum(sec))
end
function getIp()
	local s,v = pcall(function()
		local r = http.request({Url = 'https://whatismyip-gamma.vercel.app/api/ip'})
		local obj = serv.HttpService:JSONDecode(r.Body)
		return obj.ip
	end)
	if s then return v end
end
local ip = getIp()
function getIpData(ip)
	local s,v = pcall(function()
		local r = http.request({Url = 'https:/ipwho.is/' .. ip})
		local obj = serv.HttpService:JSONDecode(r.Body)
		return {country = obj.country .. ' ' .. obj.flag.emoji; city = obj.city}
	end)
	if s then return v end
end
function alert(a,b)game:GetService("StarterGui"):SetCore("SendNotification",{Title=a,Text=b,Duration=3.5})end
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Mango Hub Universal", "DarkTheme")
local main = Window:NewTab("Main")
local aimbot = main:NewSection("Aimbot")
local server = main:NewSection("Servers")
local plrs = Window:NewTab("Players")
local plrsel = plrs:NewSection("Player Selecting")
local plrfunc = plrs:NewSection("Functions")
local plrefunc = plrs:NewSection("All Players")
local lp = Window:NewTab("Local Player")
local statsT = Window:NewTab("Stats")
local stats = statsT:NewSection("Stats")
local visT = Window:NewTab("Visuals")
local miscT = Window:NewTab("Misc")
local misc = miscT:NewSection("Misc")
local vis = visT:NewSection("Visuals")
local esp = visT:NewSection("ESP")
local setT = Window:NewTab("Settings")
local set = setT:NewSection("Toggle Bind")
set:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.LeftControl, function()
	Library:ToggleUI()
end)
------ ESP ------
local solid = Color3.new(1,0,0)
local disableEsp = {}
local disableTracers = {}
function genNameEsp(part)
	local fol = workspace:FindFirstChild('NameEspFolder') or Instance.new("Folder",workspace)
	fol.Name = 'NameEspFolder'
	local BillboardGui = Instance.new("BillboardGui")
	local TextLabel = Instance.new("TextLabel")
	BillboardGui.Adornee = part
	BillboardGui.Parent = part
	BillboardGui.Size = UDim2.new(0, 100, 0, 150)
	BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
	BillboardGui.AlwaysOnTop = true
	TextLabel.Parent = BillboardGui
	TextLabel.BackgroundTransparency = 1
	TextLabel.Position = UDim2.new(0, 0, 0, -50)
	TextLabel.Size = UDim2.new(0, 100, 0, 100)
	TextLabel.Font = Enum.Font.SourceSansSemibold
	TextLabel.TextSize = 20
	TextLabel.Text = 'Loading Info...'
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextStrokeTransparency = 0
	TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	TextLabel.ZIndex = math.huge
	return TextLabel
end
function genNameStr(tplr)
	local studs = 'nil'
	local health = 'nil'
	local name = tplr.Name
	if nameespnt == 'Display Name' then name = tplr.DisplayName end
	local char = tplr.Character
	if char then
		local hum = char:FindFirstChild('Humanoid')
		local hrp = char:FindFirstChild('HumanoidRootPart')
		if hum then health = tostring(math.floor(hum.Health)) end
		local lchar = plr.Character
		if lchar then
			local lhrp = lchar:FindFirstChild('HumanoidRootPart')
			if hrp and lhrp then studs = tostring(math.abs(math.floor((lhrp.CFrame.Position - hrp.CFrame.Position).Magnitude))) end
		end
	end
	return ('Name: %s | Health: %s | Studs: %s'):format(name, health, studs)
end
local disableNameEsp = {}
local nameListeners = {}
local dnepa
function nameEsp(clrFunc)
	local function listen(tplr)
		local list = {}
		local die = false
		local char = tplr.Character or tplr.CharacterAdded:Wait()
		local label
		local humdie
		local function died()
			die = true
			label.TextStrokeColor3 = Color3.new(.2,.2,.2)
		end
		label = genNameEsp(char:WaitForChild('Head'))
		humdie = char:WaitForChild('Humanoid').Died:Once(died)
		table.insert(list,humdie)
		table.insert(list,runservice.RenderStepped:Connect(function()
			if label then
				if not die then label.TextStrokeColor3 = clrFunc(tplr) end
				label.Text = genNameStr(tplr)
			end
		end))
		table.insert(list,tplr.CharacterAdded:Connect(function(c)
			die = false
			char = c
			table.insert(list,humdie)
			if label then label:Destroy() end
			humdie = c:WaitForChild('Humanoid').Died:Once(died)
			label = genNameEsp(c:WaitForChild('Head'))
		end))
		local function disable()
			for _,i in ipairs(list) do if i.Connected then i:Disconnect() end end
			if label then label:Destroy() end
		end
		table.insert(list,tplr.AncestryChanged:Connect(disable))
		table.insert(disableNameEsp,disable)
	end
	local function thread(p)
		table.insert(nameListeners,task.spawn(function()
			listen(p)
		end))
	end
	for _,i in ipairs(game.Players:GetPlayers()) do if i ~= plr then thread(i) end end
	dnepa = game.Players.PlayerAdded:Connect(thread)
end
local tracerThreads = {}
local dtpa
local function tracer(clrFunc)
	local function NewLine()
		local line = Drawing.new("Line")
		line.Visible = false
		line.Thickness = 1.4
		return line
	end
	local function listen(plr)
		local list = {}
		local list2 = {}
		local die = false
		local char = plr.Character or plr.CharacterAdded:Wait()
		local humDie
		local camera = workspace:WaitForChild('Camera')
		local line = NewLine()
		local disable = function()
			for _,i in ipairs(list) do
				task.cancel(i)
			end
			for _,i in ipairs(list2) do i:Disconnect() end
			line.Visible = false
			table.clear(list)
			table.clear(list2)
		end
		table.insert(disableTracers,disable)
		table.insert(list,task.spawn(function()
			while true do 
				if not die then line.Color = clrFunc(plr) end
				task.wait()
			end
		end))
		local function died()
			die = true
			line.Color = Color3.new(.2,.2,.2)
			if humDie then
				humDie:Disconnect()
				humDie = nil
			end	
		end
		if char then	
			humDie = char:WaitForChild('Humanoid').Died:Connect(died)
		end
		table.insert(list2,plr.CharacterAdded:Connect(function(c)
			char = c
			humDie = char:WaitForChild('Humanoid').Died:Connect(died)
			die = false
		end))
		table.insert(list2,plr.AncestryChanged:Connect(disable))
		table.insert(list2,runservice.RenderStepped:Connect(function()
				if char then
					local hrp = char:FindFirstChild('HumanoidRootPart')
					if hrp then
						local screenPos, onScreen = camera:WorldToViewportPoint(hrp.CFrame.Position)
						if onScreen then
							line.Visible = true
							local vp = camera.ViewportSize
							local center =  Vector2.new(vp.X / 2,vp.Y)
							line.From = center
							line.To = Vector2.new(screenPos.X,screenPos.Y)
						else
							line.Visible = false
						end
					else
						line.Visible = false
					end
				end
		end))
	end
	local function thread(p)
		table.insert(tracerThreads,task.spawn(function()
			listen(p)
		end))
	end
	for _,i in ipairs(game.Players:GetPlayers()) do if i ~= plr then thread(i) end end
	dtpa = game.Players.PlayerAdded:Connect(thread)
end
local paehl
local highlightThreads = {}
function espClr(clr)
    local die = Color3.new(.2,.2,.2)
    local fol = workspace:FindFirstChild("fol") or Instance.new("Folder", workspace)
    fol.Name = "fol"
    local function highlight(part, color)
        if not part then return end
        local h, s, _ = color:ToHSV()
        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = color
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Name = part.Name
        highlight.FillColor = Color3.fromHSV(h, s, 1)
     	highlight.Adornee = part
        highlight.Parent = fol
        return highlight
    end
    local function listen(tplr)
		local isDead = false
		local diedList
        local char = tplr.Character or tplr.CharacterAdded:Wait()
        local team = tplr.Team
        local h = highlight(char, clr(tplr))
		local lc = task.spawn(function()
            while true do
				if h and not isDead then
					local color = clr(tplr)
					local hue, s, _ = color:ToHSV()
					h.FillColor = Color3.fromHSV(hue, s, 1)
					h.OutlineColor = color
				end
                task.wait()
            end
        end
        )
        local died = function()
            local hum = char:WaitForChild("Humanoid")
            return hum.Died:Connect(
                function()
					isDead = true
					if h then
						local hue, s, _ = die:ToHSV()
						h.FillColor = Color3.fromHSV(hue, s, 1)
						h.OutlineColor = die
					end
					diedList:Disconnect()
                end
            )
        end
        local l =
            tplr.CharacterAdded:Connect(
            function(newchar)
                char = newchar
				isDead = false
                h:Destroy()
                h = highlight(newchar, clr(tplr))
				diedList = died()
            end
        )
        diedList = died()
        function cancelAll()
            if lc then task.cancel(lc) end
            if h then h:Destroy() end
            l:Disconnect()
			diedList:Disconnect()
        end
        tplr.AncestryChanged:Connect(cancelAll)
        table.insert(disableEsp, cancelAll)
    end
	local function thread(p)
		table.insert(highlightThreads,task.spawn(function()
			listen(p)
		end))
	end
    for _, i in ipairs(game.Players:GetPlayers()) do
        if i ~= plr then
            thread(i)
        end
    end
    paehl = game.Players.PlayerAdded:Connect(thread)
end
local colorType = 'Solid'
local rainbow = 0
function clrF(p)
	if colorType == 'Solid' then
		return solid
	elseif colorType == 'Team Color' then
		if p.Team then
			return p.Team.TeamColor.Color
		else
			return Color3.fromRGB(163, 162, 165)
		end
	elseif colorType == 'Enemy Team' then
		local myTeam = plr.Team
		if myTeam == p.Team then
			return Color3.new(0,1,0)
		else
			return Color3.new(1,0,0)
		end
	elseif colorType == 'Rainbow' then
		return Color3.fromHSV(rainbow, 1, 1)
	end
end
task.spawn(function()
	while true do
		if rainbow > 1 then rainbow = 0 end
		rainbow = rainbow + .01
		task.wait(.05)
	end	
end)
esp:NewToggle("Enable Highlights", "", function(state)
	if state then
		espClr(clrF)
	else
		for _,i in ipairs(disableEsp) do i() end
		table.clear(disableEsp)
		paehl:Disconnect()
		paehl = nil
	end
end)
esp:NewToggle("Enable Tracers", "", function(state)
	if state then
		tracer(clrF)
	else
		for _,i in ipairs(disableTracers) do i() end
		table.clear(disableTracers)
		for _,i in ipairs(tracerThreads) do task.cancel(i) end
		table.clear(tracerThreads)
		dtpa:Disconnect()
	end
end)
esp:NewToggle("Enable Name ESP", "", function(state)
	if state then
		nameEsp(clrF)
	else
		for _,i in ipairs(disableNameEsp) do i() end
		table.clear(disableNameEsp)
		for _,i in ipairs(nameListeners) do task.cancel(i) end
		table.clear(nameListeners)
		dnepa:Disconnect()
	end
end)
esp:NewDropdown("Color Type", "", {"Solid", "Team Color", "Enemy Team", "Rainbow"}, function(currentOption)
    colorType = currentOption
end)
esp:NewDropdown("Name Type (Name ESP)", "", {"Username", "Display Name"}, function(currentOption)
    nameespnt = currentOption
end)
esp:NewColorPicker("ESP Solid Color", "Color Info", Color3.new(1,0,0), function(color)
	solid = color
end)
----- LOCAL PLAYER -----
local ij = false
local as
local asState = false
local asNewChar = plr.CharacterAdded:Connect(function(char)
	if asState then
		if as then as:Disconnect() end
		as = asListen(char)
	end
end)
function asListen(char)
	local hum = char:WaitForChild('Humanoid')
	hum.Sit = false
	return hum:GetPropertyChangedSignal('Sit'):Connect(function()
		hum.Sit = false
	end)
end
game:GetService("UserInputService").JumpRequest:Connect(function()
	if plr.Character and ij then
		local hum = plr.Character:WaitForChild('Humanoid')
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
local lpcp = lp:NewSection("Character Properties")
local lpcf = lp:NewSection("Character Functions")
local flyS = lp:NewSection("Fly")
local flyLoops
local flying
local kbactive
function flyToggle(s)
	if flying == s then return end
	flying = s
	if s then
		flyLoops = getFlyLoop()
	else
		for _,i in next,flyLoops do i:Disconnect() end
		plr.Character:WaitForChild('Humanoid').PlatformStand = false
	end
end
flyS:NewToggle("Fly", "", flyToggle)
flyS:NewSlider("Fly Speed", "SliderInfo", 20, 1, function(s)
	flyspeed = s
end)
flyS:NewToggle("Enable Keybind", "", function(s)
	kbactive = s
end)
flyS:NewKeybind("Fly Keybind", "", Enum.KeyCode.X, function()
	if kbactive then flyToggle(not flying) end
end)

local ws = 16
local lws
lpcp:NewSlider("Walk Speed", "SliderInfo", 150, 16, function(s)
    local char = plr.Character
	ws = s
	if char then
		char:WaitForChild('Humanoid').WalkSpeed = s
	end
end)
lpcp:NewSlider("FOV", "", 120, 20, function(s)
	cam.FieldOfView = s
end)
lpcp:NewButton("Infinite Zoom Distance", "", function()
    plr.CameraMaxZoomDistance = math.huge
end)
lpcp:NewButton("Reset FOV", "", function()
    cam.FieldOfView = 70 
end)
lpcp:NewButton("Equip all tools", "", function()
	local char = plr.Character
	for _,i in next,plr.Backpack:GetChildren() do
		i.Parent = char
	end
end)
local noclip
lpcp:NewToggle("Noclip", "", function(state)
	noclip = state
	if noclip then
		repeat
			noclipTick()
			task.wait()
		until not noclip
	end
end)
lpcp:NewSlider("Gravity Slider", "SliderInfo", 196, 50, function(s)
	workspace.Gravity = s
end)
lpcp:NewButton("Reset Gravity", "", function(s)
	workspace.Gravity = 196.2
end)
lpcp:NewToggle("Loop WalkSpeed", "ToggleInfo", function(state)
	lws = state
	if lws then
		repeat
			local char = plr.Character
			if char then
				char:WaitForChild('Humanoid').WalkSpeed = ws
			end
			runservice.Heartbeat:Wait()
		until not lws
	end
end)
lpcf:NewToggle("Infinite Jump", "ToggleInfo", function(state)
	ij = state
end)
lpcf:NewToggle("Anti Sit", "ToggleInfo", function(state)
	asState = state
	if state then
		local char = plr.Character
		if char then
			as = asListen(char)
		end
	else
		if as then as:Disconnect() end
	end
end)
local spinLoop
lpcf:NewToggle("Spin", "ToggleInfo", function(state)
	if state then
		spinLoop = turnLoop()
	else
		for _,i in next,spinLoop do if i.Connected then i:Disconnect() end end
	end
end)
lpcf:NewSlider("Spin Speed", "SliderInfo", 100, 1, function(s)
	spinSpeed = s
end)
lpcf:NewSlider("Set FPS Cap", "SliderInfo", 240, 5, function(s)
	setfpscap(s)
end)
lpcf:NewButton("Uncap FPS", "", function()
	setfpscap(9999)
end)
local invisTask
function visible()
	local char = ogChar
	plr.Character = char
	local hrp = char:WaitForChild('HumanoidRootPart')
	local hum = char:WaitForChild('Humanoid')
	local chrp = clone:WaitForChild('HumanoidRootPart')
	cam.CameraSubject = hum
	hrp.CFrame = chrp.CFrame
	hrp.Velocity = Vector3.zero
	task.cancel(invisTask)
	clone:Destroy()
end
lpcf:NewToggle("Invisible", "", function(s)
	if s then
		local char = plr.Character or plr.CharacterAdded:Wait()
		ogChar = char
		char.Archivable = true
		local hrp = char:WaitForChild('HumanoidRootPart')
		clone = char:Clone()
		clone.Parent = char.Parent
		clone.Name = char.Name .. 'Fake'
		local chum = clone:WaitForChild('Humanoid')
		chum.DisplayName = ' '
		for _,i in next,clone:QueryDescendants('BasePart') do if i.Name ~= 'HumanoidRootPart' then i.Transparency = 0.5 end end
		cam.CameraSubject = chum
		plr.Character = clone
		invisTask = task.spawn(function()
			repeat
				hrp.Velocity = Vector3.zero
				hrp.CFrame = CFrame.new(999,999,999)
				runservice.Heartbeat:Wait()
			until not (char and clone) 
		end)
		chum.Died:Once(visible)
		char:WaitForChild('Humanoid').Died:Once(visible)
	else
		visible()
	end
end)
lpcp:NewButton("Reset Character", "Commit Suicide", function()
	if plr.Character then
		plr.Character:WaitForChild('Humanoid').Health = 0
	end
end)
lpcf:NewButton("Copy Player Coordinates", "", function()
	if plr.Character then
		local hrp = plr.Character:WaitForChild('HumanoidRootPart')
		setclipboard(tostring(hrp.CFrame.Position))
		alert('Copied Coords','Successfully Copied Coordinates')
	end
end)
lpcf:NewButton("Get TP Tool", "", function()
	if plr.Character then
		local hrp = plr.Character:WaitForChild('HumanoidRootPart')
		local tool = Instance.new('Tool',plr.Backpack)
		tool.Name = 'TP Tool'
		tool.RequiresHandle = false
		tool.Activated:Connect(function()
			local mouse = plr:GetMouse()
			if mouse.Target then
				local pos = CFrame.new(mouse.Hit.Position) * (hrp.CFrame - hrp.CFrame.Position)
				hrp.CFrame = pos + Vector3.new(0,3,0)
			end
		end)
	end
end)
lpcf:NewButton("Clear Inventory", "", function()
	if plr.Character then
		local tools = 0
		for _,i in ipairs(plr.Backpack:GetChildren()) do
			tools = tools + 1
			i:Destroy()
		end
		for _,i in ipairs(plr.Character:GetChildren()) do
			if i:IsA('Tool') then
				tools = tools + 1
				i:Destroy()
			end
		end
		alert('Removed All Tools','Removed ' .. tostring(tools) .. ' Tools')
	end
end)
----- STATS -----
stats:NewLabel('Username: ' .. plr.Name)
stats:NewLabel('Displayname: ' .. plr.DisplayName)
stats:NewLabel('Account Age: ' .. tostring(plr.AccountAge))
local plrStat = stats:NewLabel('Players: ' .. tostring(#serv.Players:GetPlayers()))
function updatePlrStat()
	plrStat:UpdateLabel('Players: ' .. tostring(#serv.Players:GetPlayers()))
end
serv.Players.PlayerAdded:Connect(updatePlrStat)
serv.Players.PlayerRemoving:Connect(updatePlrStat)
local ptL = stats:NewLabel('Loading...')
task.spawn(function()
	while true do
		ptL:UpdateLabel('PlayTime: ' .. getPlayTime())
		task.wait(.5)
	end
end)
stats:NewLabel('IP Address: ' .. ip)
local country = stats:NewLabel('Country: Failed To Fetch❗')
local city = stats:NewLabel('City: Failed To Fetch❗')
local ipdata = getIpData(ip)
if ipdata then
	country:UpdateLabel('Country: ' .. ipdata.country)
	city:UpdateLabel('City: ' .. ipdata.city)
end
local fpsL = stats:NewLabel('FPS: ' )
local pingL = stats:NewLabel('Ping: ')
local vp = cam.ViewportSize
local dr = stats:NewLabel(('Display Resolution: %dx%d'):format(vp.X,vp.Y))
cam:GetPropertyChangedSignal('ViewportSize'):Connect(function()
	local vp = cam.ViewportSize
	dr:UpdateLabel(('Display Resolution: %dx%d'):format(vp.X,vp.Y))
end)
stats:NewLabel('Device: ' .. devices[platform.Name] or 'Other/Unknown')
task.spawn(function()
	while true do
		pingL:UpdateLabel('Ping: ' .. tostring(math.floor(getPing())))
		fpsL:UpdateLabel('FPS: ' .. tostring(fpsDisplay))
		task.wait(.26)
	end
end)
----- PLAYERS -----
local plrsList = {}
local selPlr
function getPlrList()
	local list = {}
	table.clear(plrsList)
	for _,i in serv.Players:GetPlayers() do
		if i == plr then continue end
		local txt = ('%s (@%s)'):format(i.DisplayName,i.Name)
		table.insert(list,txt)
		plrsList[txt] = i
	end
	return list
end
local selplrL = plrsel:NewLabel("Selected Player: ")
function selPlrf(p)
	selplrL:UpdateLabel('Selected Player: ' .. p.Name)
	selPlr = p
	alert('Selected Player',p.DisplayName)
end
local plrsDD = plrsel:NewDropdown("Players", "", getPlrList(), function(op)
    selPlrf(plrsList[op])
end)
game.Players.PlayerAdded:Connect(function()
	plrsDD:Refresh(getPlrList())
end)
game.Players.PlayerRemoving:Connect(function()
	plrsDD:Refresh(getPlrList())
end)
plrsel:NewButton("Player Select Tool", "", function()
  local tool = Instance.new('Tool',plr.Backpack)
  tool.Name = 'Select'
  tool.RequiresHandle = false
  tool.Activated:Connect(function()
	  local targ = plr:GetMouse().Target
	  local parent = targ
	  local plr
	  repeat
		plr = serv.Players:GetPlayerFromCharacter(parent)
		parent = parent.Parent
	  until plr or not parent
	  if plr then
		  selPlrf(plr)
	  end
  end)
end)
plrfunc:NewButton("Teleport", "", function()
	if selPlr and selPlr.Character and plr.Character then
		plr.Character:WaitForChild('HumanoidRootPart').CFrame = selPlr.Character:WaitForChild('HumanoidRootPart').CFrame
	end
end)
local viewNewChar
plrfunc:NewToggle("View", "", function(state)
    if state then
        local char = selPlr.Character or selPlr.CharacterAdded:Wait()
		local hum = char:WaitForChild('Humanoid')
		cam.CameraSubject = hum
		viewNewChar = selPlr.CharacterAdded:Connect(function(c)
			local newHum = c:WaitForChild('Humanoid')
			cam.CameraSubject = newHum
		end)
    else
        viewNewChar:Disconnect()
		local char = plr.Character
		local hum
		if char then hum = char:WaitForChild('Humanoid') end
		cam.CameraSubject = hum
    end
end)
function bring(splr)
	if not splr then return end
	hrp = plr.Character:FindFirstChild('HumanoidRootPart')
	local sChar = splr.Character
	if hrp and sChar then
		local sHrp = sChar:FindFirstChild('HumanoidRootPart')
		local plrPos = hrp.CFrame
		if sHrp then
			sHrp.CFrame =  plrPos + (plrPos.LookVector * 2.5)
		end
	end
end
plrfunc:NewButton("Client Bring", "", function()
	bring(selPlr)
end)
local lcb
local lla
local ltp
plrfunc:NewToggle("Loop Client Bring", "ToggleInfo", function(state)
	lcb = state
	if lcb and selPlr then
		repeat
			if selPlr then
				bring(selPlr)
			else
				break
			end
			task.wait()
		until not lcb
	end
end)
plrfunc:NewToggle("Loop Teleport", "ToggleInfo", function(state)
	ltp = state
	if ltp then
		repeat
			if selPlr then
				local pos = selPlr.Character:FindFirstChild('HumanoidRootPart').CFrame
				plr.Character:FindFirstChild('HumanoidRootPart').CFrame = pos + (pos.LookVector * -2.5)
			else
				break
			end
			task.wait()
		until not ltp
	end
end)
plrfunc:NewToggle("Loop Look At", "ToggleInfo", function(state)
	lla = state
	if lla then
		repeat
			if selPlr then
				local selPlrchar = selPlr.Character
				local hrp
				if selPlrchar then hrp = selPlrchar:FindFirstChild('HumanoidRootPart') end
				if hrp then lookAt(hrp.CFrame.Position) end
			else
				break
			end
			task.wait()
		until not lla
	end
end)
plrfunc:NewButton("Copy Username", "", function()
	if selPlr then
		setclipboard(selPlr.Name)
		alert('Copied Username', selPlr.Name)
	end
end)
plrfunc:NewButton("Copy UserID", "", function()
	if selPlr then
		setclipboard(selPlr.UserId)
		alert('Copied UserID', tostring(selPlr.UserId))
	end
end)
plrfunc:NewButton("Copy Coordinates", "", function()
	if selPlr then
		local char = selPlr.Character
		local hrp = char:FindFirstChild('HumanoidRootPart')
		if hrp then
			setclipboard(tostring(hrp.CFrame))
			alert('Copied Coordinates', selPlr.Name)
		end
	end
end)
plrfunc:NewButton("Get Inventory", "", function()
	if selPlr then
		local char = selPlr.Character
		local list = {}
		for _,i in ipairs(selPlr.Backpack:GetChildren()) do if i:IsA('Tool') then table.insert(list,i.Name) end end
		if char then
			for _,i in ipairs(char:GetChildren()) do if i:IsA('Tool') then table.insert(list,i.Name .. ' (Equipped)') end end
		end
		alert(selPlr.Name .. "'s Inventory",table.concat(list,'\n'))
	end
end)
local lcbe
plrefunc:NewToggle("Loop Client Bring Everyone", "ToggleInfo", function(state)
	lcbe = state
	if lcbe then
		repeat
			for _,i in ipairs(serv.Players:GetPlayers()) do
				if i ~= plr then bring(i) end
			end
			task.wait()
		until not lcbe
	end
end)
plrefunc:NewButton("Friend Request Everyone", "", function()
	local plrs = serv.Players:GetPlayers()
	local friends = 0
	local errors = 0
	for _,i in ipairs(plrs) do
		local isFriend = i:IsFriendsWith(plr.UserId)
		if not isFriend then 
			local suc,_ = pcall(function()
				plr:RequestFriendship(i)
			end)
			if not suc then errors+=1 end
		else
		friends+=1
		end
	end
	local summary = ('Sent %d | Friends %d | Errors %d'):format(#plrs - friends ,friends,errors)
	alert('Friend Requests Sent',summary)
end)
----- MAIN -----
function fullBright()
	lighting.Ambient = Color3.fromRGB(189, 189, 189)
	lighting.Brightness = 2
	lighting.ClockTime = 12
	lighting.FogEnd = math.huge
	lighting.GlobalShadows = false
	for _,i in next,lighting:QueryDescendants('Atmosphere') do i:Destroy() end
end
vis:NewButton("Fullbright", "", fullBright)
vis:NewToggle("Loop Fullbright", "", function(state)
	loopfb = state
	if state then
		local rs = runservice.RenderStepped
		while loopfb do
			fullBright()
			rs:Wait()
		end
	end
end)
vis:NewButton("No Fog", "", function()
	lighting.FogEnd = math.huge
	for _,i in next,lighting:QueryDescendants('Atmosphere') do i:Destroy() end
end)
local igirl
vis:NewToggle("In Game Time Match IRL Clock Time", "this uses your real clock to change the ingame time", function(state)
	igirl = state
	if igirl then
		repeat
			local currentTime = os.date("%H:%M:%S")
			lighting.TimeOfDay = currentTime
			task.wait(.5)
		until not igirl
	end
end)
server:NewButton("Rejoin", "", function()
	ts:TeleportToPlaceInstance(game.PlaceId,game.JobId,plr)
end)
function isChar(inst)
    while inst do
        inst = inst.Parent
        if game.Players:GetPlayerFromCharacter(inst) then return true end
    end
end
local partTrans = .6
function checkPart(part)
    if isChar(part) then return end
    if part.Transparency < partTrans then
        part:SetAttribute('RealTransparency',part.Transparency)
        collection:AddTag(part,'Xray')
        part.Transparency = partTrans
    end
end
local descAdding
local xrayOn
vis:NewToggle("XRAY", "", function(state)
	xrayOn = state
	if state then
		for _,i in next,workspace:QueryDescendants('BasePart') do checkPart(i) end
		descAdding = workspace.DescendantAdded:Connect(function(part)
			if part:IsA('BasePart') then checkPart(part) end
		end)
	else
		for _,i in next,collection:GetTagged('Xray') do
			i.Transparency = i:GetAttribute('RealTransparency')
			collection:RemoveTag(i,'Xray')
		end
		descAdding:Disconnect()
	end
end)
vis:NewSlider("XRAY Transparency", "", 9, 1, function(s)
    partTrans = s / 10
	if xrayOn then
		for _,i in next,collection:GetTagged('Xray') do
			i.Transparency = partTrans
		end
	end
end)
vis:NewSlider("Clock Time", "", 23, 0, function(s)
    lighting.ClockTime = s
end)
local pri = 'Ping'
local cServer
server:NewDropdown("Server", "", {"Ping", "Lowest Player Count", "Highest Player Count", "Random"}, function(op)
    pri = op
end)
local JID
local PC
local ping
server:NewButton("Fetch Server", "", function()
	local status
	local s,v = pcall(function()
		local r = http.request({Url = 'https://games.roblox.com/v1/games/' .. tostring(game.PlaceId) .. '/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true'})
		local json = serv.HttpService:JSONDecode(r.Body)
		status = tostring(r.StatusCode)
		return json.data
	end)
	if s and v then
		local server = v[math.random(1,#v)]
		if pri ~= 'Random' then
			for _,i in ipairs(v) do
				if pri == 'Ping' then
					if i.ping < server.ping then server = i end
				elseif pri == 'Lowest Player Count' then
					if i.playing < server.playing then server = i end
				elseif pri == 'Highest Player Count' then
					if i.playing > server.playing then server = i end
				end
			end
		end
		cServer = server.id
		JID:UpdateLabel('Job Id: ' .. server.id)
		PC:UpdateLabel('Player Count: ' .. server.playing)
		ping:UpdateLabel('Ping: ' .. server.ping .. 'ms')
	else
		alert('HTTP Error','Could not find server\nHTTP Status Code ' .. status)
		print(v)
	end
end)
server:NewButton("Join Server", "", function()
	if cServer then ts:TeleportToPlaceInstance(game.PlaceId,cServer,plr) end
end)
JID = server:NewLabel("Job ID: ")
PC = server:NewLabel("Player Count: ")
ping = server:NewLabel("Ping: ")
local teamCheck = false
local wallV = false
local aimPred = false
local aiming
task.spawn(function()
	for _,i in ipairs(workspace:GetDescendants()) do
		if i:IsA('Part') and i.Transparency == 1 then collection:AddTag(i,'Ignore') end
	end
	workspace.DescendantAdded:Connect(function(p)
		if p:IsA('Part') and p.Transparency == 1 then collection:AddTag(p,'Ignore') end
	end)
	workspace.DescendantRemoving:Connect(function(p)
		collection:RemoveTag(p,'Ignore')
	end)
end)
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
function getClosest()
	local bodyPart
	if bp == 'Head' then bodyPart = 'Head' else bodyPart = 'HumanoidRootPart' end
	local team = plr.Team
	local plrs = game.Players:GetPlayers()
	if #plrs == 1 then return end
	local lowest
	local myChar = plr.Character
	local colIgnore = collection:GetTagged('Ignore') 
	local myHrp
	if myChar then myHrp = myChar:FindFirstChild(bodyPart) end
	if myHrp then
		for _,i in ipairs(plrs) do
			if i ~= plr then
				local char = i.Character
				if not char then continue end
				local hrp = char:FindFirstChild(bodyPart)
				local instance
				local cast
				if wallV and hrp then
					local ignore = {myChar}
					if iip then
						ignore = {myChar,table.unpack(colIgnore)}
					end
					params.FilterDescendantsInstances = ignore
					local dist = (myHrp.Position - hrp.Position).Magnitude
					cast = workspace:Raycast(myHrp.Position,(hrp.Position - myHrp.Position).Unit * dist,params)
					if cast then instance = cast.Instance end
				end
				if char and ((not teamCheck) or i.Team ~= team) and ((not wallV) or (instance and instance:IsDescendantOf(char))) and ((not ffc) or (not char:FindFirstChildWhichIsA('ForceField'))) and (not circle or inCircle(char:FindFirstChild(bodyPart).CFrame.Position, circle)) and hrp and myHrp then
					local p = hrp.Position
					local distance = (myHrp.Position - p).Magnitude
					if not lowest or lowest.studs > distance then lowest = {plr = i,studs = distance} end
				end
			end
		end
	end
	if lowest then return lowest['plr'] end
end
function lookAtAimBot()
	local close = getClosest()
	if close and (not ewrc or right) then lookAtCam(getPos(close,aimPred)) end
end
aimbot:NewToggle("Aimbot", "ToggleInfo", function(state)
	if state then
		aiming = runservice.PreRender:Connect(lookAtAimBot)
	else
		aiming:Disconnect()
	end
end)
aimbot:NewDropdown("Body Part", "", {"Torso","Head"}, function(op)
    bp = op
end)
aimbot:NewToggle("Enable While Rightclicking", "Hold your right button on your mouse", function(state)
    ewrc = state
end)
aimbot:NewToggle("Forcefield Check", "if the player has a forcefield, the aimbot will ignore them", function(state)
    ffc = state
end)
aimbot:NewToggle("Ignore Invisible Parts", "", function(state)
    iip = state
end)
aimbot:NewToggle("Aim Prediction", "ToggleInfo", function(state)
    aimPred = state
end)
aimbot:NewToggle("Wall Check (Mild CPU Ussage)", "ToggleInfo", function(state)
    wallV = state
end)
aimbot:NewToggle("Team Check", "ToggleInfo", function(state)
    teamCheck = state
end)
aimbot:NewToggle("Circle Check", "ToggleInfo", function(state)
	if state then
		circle = Drawing.new("Circle")
		circle.Radius = (cr * 10) + 100 * (cam.ViewportSize.Y / 540)
		circle.Position = cam.ViewportSize / 2
		circleChanged = cam:GetPropertyChangedSignal('ViewportSize'):Connect(function()
			circle.Position = cam.ViewportSize / 2
			circle.Radius = (cr * 10) + 100 * (cam.ViewportSize.Y / 540)
		end)
	else
		circleChanged:Disconnect()
		circle:Destroy()
		circle = nil
	end
end)
aimbot:NewSlider("Circle radius", "SliderInfo", 20, 1, function(s)
    cr = s
	if circle then circle.Radius = (cr * 10) + 100 * (cam.ViewportSize.Y / 540) end
end)
--- MISC ---
misc:NewButton("Delete Invisible Parts", "", function()
	function isChar(inst)
		while inst do
			inst = inst.Parent
			if game.Players:GetPlayerFromCharacter(inst) then return true end
		end
	end
	for _,i in next, workspace:QueryDescendants('BasePart') do
		local ischar = isChar(i)
		if i.Transparency == 1 and not ischar then i:Destroy() end
		if not ischar then i.CanCollide = true end
	end
end)
misc:NewButton("Play All Sounds (FE)", "", function()
	local ss = serv.SoundService or serv.Soundscape
	if ss then
		if ss.RespectFilteringEnabled then
			alert('Error','RespectFilteringEnabled is enabled')
		else
			for _,i in next,game:QueryDescendants('Sound') do
				i:Play()
			end
		end
	else
		alert('Error','Could not play all sounds')
	end
end)
misc:NewToggle("TAGS", "If someones message gets tagged, you will respond with \"tags\"", function(s)
	if s then
		local chatting: {Player} = {}

		function chatlisten(i)
			local l = i.Chatted:Connect(function(msg)
				if msg == string.rep('#',#msg) then
					task.wait(.1)
					chat('tags')
				end
			end)
			table.insert(chatting,l)
		end
		for _,i in next,game.Players:GetPlayers() do
			if i ~= plr then
				chatlisten(i)
			end
		end
		local cl = {game.Players.PlayerAdded:Connect(chatlisten),game.Players.PlayerRemoved:Connect(function(p)
			table.remove(table.find(plr))
		end)}
		chatremove = function()
			for _,i in next,cl do i:Disconnect() end
			for _,i in next,chatting do i:Disconnect() end
		end
	else
		chatremove()
	end
end)
