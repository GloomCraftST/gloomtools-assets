local Character = script.Parent
local UIS = game:GetService("UserInputService")
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")


UIS.InputBegan:Connect(function(Input, GPE)
	if Input.KeyCode == Enum.KeyCode.LeftShift and Humanoid.MoveDirection.Magnitude > 0 then 
		Humanoid.WalkSpeed += 10
		
		repeat task.wait() until not UIS:IsKeyDown(Enum.KeyCode.LeftShift) or Humanoid.MoveDirection.Magnitude <= 0 
		
		Humanoid.WalkSpeed -= 10
	end
end)
