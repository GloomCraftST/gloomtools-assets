local KillPart = script.Parent

KillPart.Touched:Connect(function(TouchedPart)
	if TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid") then
		TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid").Health = 0
	end
end)
