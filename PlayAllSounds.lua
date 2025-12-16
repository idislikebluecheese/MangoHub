-- plays all sounds
-- DONT SKID!!
local SS = game:GetService("SoundService")
local core
if not SS.RespectFilteringEnabled then
    for _, i in ipairs(game:GetDescendants()) do
        if i:IsA("Sound") then
            i:Play()
        end
    end
else
    local core = game:GetService("StarterGui")
    core:SetCore(
        "SendNotification",
        {
            Title = "Game Not Supported",
            Text = "Try Another Game",
            Duration = 5
        }
    )
end
