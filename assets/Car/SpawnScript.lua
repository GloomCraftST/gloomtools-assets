local RS = game:GetService("ReplicatedStorage")
local Cars = RS:WaitForChild("Cars")

local Car = Cars:WaitForChild("Car_Template")

local SPPart = script.Parent:WaitForChild("SPPart")

local SpawnCar = false

local Spawn_Duration = script:GetAttribute("SpawnDuration")

while true do 
	task.wait(Spawn_Duration)
	if game.Workspace:FindFirstChild("Car_Template") then 
		SpawnCar = false
	else 
		SpawnCar = true
	end
	if SpawnCar then
		local CarClone = Car:Clone()
		CarClone.Parent = game.Workspace
		CarClone:MoveTo(SPPart.Position)
	end
end
