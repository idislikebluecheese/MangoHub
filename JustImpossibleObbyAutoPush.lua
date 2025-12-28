-- game name: "just impossible obby"
--game id: 9315244790
-- scripted by 620_h
while true do
	for _,i in ipairs(game.Players:GetPlayers()) do
		if i ~= game.Players.LocalPlayer then
			game:GetService("ReplicatedStorage").PushEvent:FireServer(i)
			task.wait(0.005)
		end
	end
	task.wait(1)
end
