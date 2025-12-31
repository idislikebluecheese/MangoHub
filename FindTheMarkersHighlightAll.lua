-- scripted by 620_h
-- please no skidding
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
