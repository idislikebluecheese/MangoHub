-- LEGACY VERSION ONLY!!!
-- open source
-- scripted entirly by 620_h
-- this script was lowkey rushed
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Mango Hub Jenga", "DarkTheme")
local main = Window:NewTab("Main")
local mainSec = main:NewSection("Main Functions")
local troll = Window:NewTab("Trolling")
local trollS = troll:NewSection("Sounds Section")
local plr = game.Players.LocalPlayer
local lis = {}
function esp(switch)
	for _,i in ipairs(game.workspace:GetChildren()) do
		if i:IsA("Highlight") and i.Name == "plr" then i:Destroy() end
	end
	for _,i in ipairs(lis) do
		if i.Connected then i:Disconnect() end
	end
	table.clear(lis)
	if not switch then return end
	local function highlight(part, color)
		if not part or not part:IsA("Model") and not part:IsA("Part") and not part:IsA("MeshPart") then
			return
		end
		local h,s,v = color:ToHSV()
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
		highlight.Parent = workspace
	end
	local function track(plr)
		if plr.Character then
			if plr.Character:FindFirstChild("Highlight") then plr.Character.Highlight:Destroy() end
			highlight(plr.Character,plr.Team.TeamColor.Color)
		end
		local respawn = plr.CharacterAdded:Connect(function(char)
			if game.Players:GetPlayerFromCharacter(char).Team == game.Teams.Towers then
				local oldHighlight = char:WaitForChild("Highlight")
				oldHighlight:Destroy()
				task.wait(0.01)
			end
			highlight(char,plr.Team.TeamColor.Color)
		end)
		--[[local team = plr:GetPropertyChangedSignal("Team"):Connect(function(tm)
			if tm ~= game.Teams.Towers then
				local char = plr.Character or plr.CharacterAdded:Wait()
				highlight(char,plr.Team.TeamColor.Color)
			end
		end)]]
		table.insert(lis, respawn)
	end
	for _,i in ipairs(game.Players:GetPlayers()) do
		if i ~= game.Players.LocalPlayer then track(i) end
	end
	local PA = game.Players.PlayerAdded:Connect(function(plr)
		track(plr)
	end)
	table.insert(lis,PA)
end
function tp(cframe, back)
	if not plr.Character or plr.Team == game.Teams.Spectating then return end
	local hrp = plr.Character:WaitForChild("HumanoidRootPart")
	local ogpos = hrp.CFrame
	hrp.CFrame = cframe
	if back then
		wait(0.25)
		hrp.CFrame = ogpos
		game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	end
end
mainSec:NewButton("End Game (MUST BE IN GAME)", "", function()
    tp(workspace.Map.Classic.Button.CFrame, true)
end)
mainSec:NewButton("Remove Projectiles", "", function()
	local pro = workspace:FindFirstChild("Projectiles")
    if pro then pro:Destroy() end 
end)

mainSec:NewButton("Remove Kill Part", "", function()
	workspace.Map.Classic.KillBrick:Destroy()
end )
mainSec:NewButton("Teleport To Destroyer (MUST BE IN GAME)", "", function()
	tp(CFrame.new(222, 100, 32))
end)
trollS:NewButton("Play All Sounds (FE)", "", function()
	for _,i in ipairs(game:GetDescendants()) do
		if i:IsA("Sound") then i:Play() end
	end
end)
mainSec:NewToggle("Player ESP", "", function(state)
    if state then
        esp(true)
    else
       esp(false)
    end
end)
