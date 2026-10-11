--[[
hide and seek source
i made open source because im nice😊😊😊😊😊
DONT SKID🤬🤬🤬😡😡😡
]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Mango Hub V1.31",
    SubTitle = "by 620_h",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})
function alert(a,b,c)
	local d = 3
	local cc = c
	if type(c) == "number" then
		d = c
		cc = ""
	end
	Fluent:Notify({
        	Title = a,
        	Content = b,
        	SubContent = cc,
        	Duration = d
	})
end
local Options = Fluent.Options
local plr = game.Players.LocalPlayer
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
}
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
	game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.LeftControl,false,game)
	game:GetService("VirtualInputManager"):SendKeyEvent(false,Enum.KeyCode.LeftControl,false,game)
end)
local hide = Tabs.Main:AddSection("Hider")
local seek = Tabs.Main:AddSection("Seeker")
local ijtoggle = false
local UIS = game:GetService("UserInputService")
local JR = UIS.JumpRequest:Connect(function() -- short for jump request
	if not game.Players.LocalPlayer.Character or not ijtoggle then
		return
	end
	game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
seek:AddButton({
    Title = "KILL ALL (must be it)",
    Description = "",
    Callback = function()
		if not plr.Character or plr.PlayerData.It.Value == false then return end
		local hrp = plr.Character:WaitForChild("HumanoidRootPart")
		local ogpos = hrp.CFrame
		for _,i in ipairs(game.Players:GetPlayers()) do
			if i.Character ~= game.Players.LocalPlayer then
				hrp.CFrame = i.Character:WaitForChild("HumanoidRootPart").CFrame
				task.wait(0.05)
			end
		end
		hrp.CFrame = ogpos
    end
})
seek:AddButton({
    Title = "ESP",
    Description = "",
    Callback = function()
		if getgenv()['esp_loaded'] then 
			warn('ESP Already Loaded!')
			return
		end
		getgenv()['esp_loaded'] = true
		--#VARS#
		local die = Color3.new(0.2,0.2,0.2)
		local fol = workspace:FindFirstChild("fol") or Instance.new("Folder",workspace)
		fol.Name = "fol"
		function getClr(a) if a then return Color3.new(1,0,0) else return Color3.new(0,1,0) end end
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
			local seeker = char:GetAttribute('IsSeekerCharacter')
			local h = highlight(char,getClr(seeker))
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
				local seeker = char:GetAttribute('IsSeekerCharacter')
				h = highlight(newchar,getClr(seeker))
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
    end
})
hide:AddButton({
    Title = "Get All Coins",
    Description = "",
    Callback = function()
		if not plr.Character then return end
		local hrp = plr.Character:WaitForChild("HumanoidRootPart")
		local ogpos = hrp.CFrame
		local count = 0
		for _,i in ipairs(workspace.GameObjects:GetChildren()) do
			if i.Name == "Credit" then
				hrp.CFrame = i.CFrame
				task.wait(0.05)
				count+=1
			end
		end
		if count == 0 then
			alert("NO COINS WERE FOUND!", "Someone Stole Took All The Coins:(")
		end
		hrp.CFrame = ogpos
    end
})
local infjumpT = hide:AddToggle("Infinite Jump", 
{
    Title = "Infinite Jump", 
    Description = "",
    Default = false,
    Callback = function(state)
	if state then
	    ijtoggle = true
	else
	    ijtoggle = false
        end
    end 
})
local speedS = hide:AddSlider("Slider", 
{
    Title = "Player Speed",
    Description = "",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value end
    end
})
local audio = Tabs.Main:AddSection("Boombox Control")
audio:AddParagraph({
    Title = "Just the boombox BUT for free",
    Content = "IMPORTANT!\nboombox can only play when you are in game"
})
local ID = nil
local Input = audio:AddInput("Input", {
    Title = "Boombox audio id",
    Description = "",
    Default = "",
    Placeholder = "123456789",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
		ID = Value
    end
})
audio:AddButton({
    Title = "Play Sound",
    Description = "",
    Callback = function()
		if not plr.Character or not ID then return end
        game:GetService("ReplicatedStorage").AnimationReplication.PlaySoundBoombox:FireServer(tostring(ID))
    end
})
audio:AddButton({
    Title = "Stop All Sounds",
    Description = "",
    Callback = function()
		if plr.Character then
			for _,i in ipairs(plr.Character:WaitForChild("HumanoidRootPart"):GetChildren()) do
				if i.Name == "BoomboxSound" then
					i:Stop()
					i:Destroy()
				end
			end
		else
			game:GetService("ReplicatedStorage").AnimationReplication.StopSoundBoombox:FireServer()
		end
    end
})
audio:AddButton({
    Title = "Play Sound (Louder)",
    Description = "DONT SPAM! YOU WILL BE RATE LIMITED",
    Callback = function()
		if not plr.Character or not ID then return end
        for i=0,20 do
			game:GetService("ReplicatedStorage").AnimationReplication.PlaySoundBoombox:FireServer(tostring(ID))
		end
    end
})
audio:AddButton({
    Title = "LOUD SCREAMING AUDIO",
    Description = "DONT SPAM! YOU WILL BE RATE LIMITED",
    Callback = function()
		if not plr.Character then return end
        for i=0,25 do
			game:GetService("ReplicatedStorage").AnimationReplication.PlaySoundBoombox:FireServer("91563254723413")
			task.wait(0.05)
		end
    end
})
audio:AddButton({
    Title = "LOUD SCREAMING AUDIO 500x (REALLY LOUD)",
    Description = "DONT SPAM! YOU WILL BE RATE LIMITED",
    Callback = function()
		if not plr.Character then return end
        for i=0,500 do
			game:GetService("ReplicatedStorage").AnimationReplication.PlaySoundBoombox:FireServer("91563254723413")
			task.wait(0.05)
		end
    end
})
Window:SelectTab(1)
