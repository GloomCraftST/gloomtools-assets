return {
    {
        Type = "Script",
        Properties = {
            Source = [[
local JumpPart = script.Parent

JumpPart.Touched:Connect(function(TouchedPart)
	if TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid") then 
		TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid").JumpPower = 75
		TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid").Jump = true
	end
	TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid").JumpPower = 50
end)
            ]],
            Name = "BadgeScript",  -- Optional: name for the script
            Enabled = true         -- Optional: whether script starts enabled
        }
    }
}
