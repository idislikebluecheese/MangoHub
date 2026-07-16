--[[
i have made open source
i have updated this on 7/15/2026
everything was done by 620_h
if you are skidding you are a stupid retard
]]
local plr = game.Players.LocalPlayer
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Mango Hub - Wizard Tycoon", "BloodTheme")
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local but = Instance.new("TextButton")
local CU = Instance.new("UICorner")
local preToggle = game.CoreGui:FindFirstChild("toggle")
if preToggle then
	preToggle:Destroy()
end
frame.Size = UDim2.new(0,100,0,50)
gui.Parent = game.CoreGui
but.Parent = frame
but.Text = "Toggle"
but.Font = "GothamBold"
but.BackgroundTransparency = 0.2
--but.Position = UDim2.new(0.5, -100, 0.5, -100)
but.TextScaled = true
CU.Parent = but
CU.CornerRadius = UDim.new(0,12)
but.Size = UDim2.new(0, 100, 0, 50)
gui.ResetOnSpawn = false -- false
frame.Visible = true
frame.Parent = gui
gui.Name = "toggle"
frame.BackgroundTransparency = 1
but.BorderSizePixel = 0
but.ZIndex = 9999999
but.MouseButton1Click:Connect(function()
	Library:ToggleUI()
end)
local TT = Window:NewTab("Targeting 💀")
local PT = Window:NewTab("Player")
local MT = Window:NewTab("Misc")
local SE = Window:NewTab("Settings")
local SET = SE:NewSection("Settings")
SET:NewKeybind("Toggle Keybind", "", Enum.KeyCode.LeftControl, function()
	Library:ToggleUI()
end)
function alert(a,b,c)
    local core = game:GetService("StarterGui")
    core:SetCore(
        "SendNotification",
        {
            Title = a,
            Text = b,
            Duration = c
        }
    )
end
local TS = TT:NewSection("Functions Targeted To A Selected Player")
local PS = PT:NewSection("Player Tab")
PS:NewButton("Get All Available Tools", "", function()
	GetAll()
end)
PS:NewButton("Modify Wand (BUFF)", "", function()
    mod()
end)
PS:NewSlider("WalkSpeed", "", 200, 16, function(s)
   plr.Character.Humanoid.WalkSpeed = s
end)
TS:NewButton("Kill Red Team", "", function()
    killTeam("Red")
end)
TS:NewButton("Kill Blue Team", "", function()
    killTeam("Blue")
end)
TS:NewButton("Kill Yellow Team", "", function()
    killTeam("Yellow")
end)
TS:NewButton("Kill Green Team", "", function()
    killTeam("Green")
end)
TS:NewButton("Kill White Team", "", function()
    killTeam("For Hire")
end)
TS:NewButton("Kill All", "", function()
    for _,i in next,game.Players:GetPlayers() do
		if i ~= plr and i.Team ~= plr.Team then
			kill(i)
		end
	end
end)
TS:NewButton("Kill Tool", "", function()
	local tool = Instance.new("Tool",plr.Backpack)
	tool.Name = "Kill tool"
	tool.RequiresHandle = false
	tool.Activated:Connect(function()
		local mouse = plr:GetMouse()
		local char = mouse.Target:FindFirstAncestorOfClass("Model")
		if char then
			local target = game.Players:GetPlayerFromCharacter(char)
			kill(target)
		end
	end)
end)
local MS = MT:NewSection("Misc Tab")
MS:NewButton("Fire Cannons (Kinda not working 😭)", "", function()
	for _,i in ipairs(workspace["berezaa's Tycoon Kit"]:QueryDescendants('ClickDetector')) do
		if i.Parent.Name == 'Switch' then
			fireclickdetector(i)
		end
	end
end)
MS:NewButton("Play All Sounds (FE)", "", function()
    for _,i in ipairs(game:QueryDescendants('Sound')) do
		i:Play()
	end
end)
--functions
function shoot(start,goal,speed) -- vector3 vector3 int, def 100
    local tool = plr.Character:FindFirstChild("Wand")
    if not tool then
        plr.Character:WaitForChild("Humanoid"):EquipTool(plr.Backpack.Wand)
        tool = plr.Character.Wand
    end
    tool.Fire:FireServer(CFrame.new(start, goal),speed,5,tool,1,plr.Character)
end
function kill(targ)
	if targ.Team == plr.Team then
		alert('Could Not Kill' .. targ.DisplayName,'Player is on same team',3)
		return
	end
    if targ.Character:FindFirstChildWhichIsA("ForceField") then
		alert("Could Not Kill " .. targ.DisplayName, "Player Has Forcefield",2)
		return
	end
    local hrp = targ.Character:WaitForChild("HumanoidRootPart")
    local hum = targ.Character:WaitForChild("Humanoid")
    local t = os.clock()
    repeat
        shoot(hrp.CFrame.p + (hrp.CFrame.LookVector * 2),hrp.CFrame.p + (hrp.Velocity / 5),750)
        task.wait(.05)
    until hum.Health == 0 or os.clock() - t >= 5
end
function mod()
	local tool = plr.Character:FindFirstChild("Wand")
	if not tool then
		plr.Character:WaitForChild("Humanoid"):EquipTool(plr.Backpack.Wand)
		tool = plr.Character.Wand
	end
	local toolscript = tool:FindFirstChild("ToolScript")
	if toolscript then toolscript:Destroy() end
	tool.Activated:Connect(function()
		local mouse = plr:GetMouse()
		tool.Handle.Fire:Play()
		shoot(tool.Handle.CFrame.Position,mouse.Hit.Position,500)
	end)
end
function killTeam(T) -- str
	if plr.Team.Name == T then alert('Cant kill team','Cant kill your own team',3) return end
	for _,i in ipairs(game.Players:GetPlayers()) do
		if i ~= plr and i.Team.Name == T then
			kill(i)
		end
	end
end
function GetAll()
	local char = plr.Character
	if char then
		local hrp = char:WaitForChild('HumanoidRootPart')
		for _,i in ipairs(workspace["berezaa's Tycoon Kit"]:QueryDescendants('Part')) do
			if string.find(i.Name,'Staff') then firetouchinterest(hrp,i,0) end
		end
	end
end
--functions
