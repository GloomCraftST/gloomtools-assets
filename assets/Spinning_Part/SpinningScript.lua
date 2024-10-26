local RS = game:GetService("RunService")

RS.Heartbeat:Connect(function()
	script.Parent.CFrame = script.Parent.CFrame * CFrame.new(0, 0, 0) * CFrame.fromEulerAnglesXYZ(0, 0.1, 0)
	-- wait()
end)
