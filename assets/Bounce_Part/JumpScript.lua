local JumpPart = script.Parent

JumpPart.Touched:Connect(function(TouchedPart)
	if TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid") then 
		TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid").JumpPower = 75
		TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid").Jump = true
	end
	TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid").JumpPower = 50
end)
