local ObjectsSpawned = game.Workspace:WaitForChild("ObjectsSpawned")

local Spawn_Part = script:GetAttribute("Spawn_Part")

local Objects = script:GetChildren()

local Count = 0 
local MaxCount = script:GetAttribute("Limit")

local MaxDistance = 10 -- Adjust how far each object should be from one another. 

local Position = nil

while true do 
	task.wait(0.5)
	Count = #ObjectsSpawned:GetChildren()
	local SpawnArea = game.Workspace:FindFirstChild(Spawn_Part)
	print(Count)
	if MaxCount > Count then 
		local x = SpawnArea.Position.X + math.random(-SpawnArea.Size.X/2, SpawnArea.Size.X/2)
		local z = SpawnArea.Position.Z + math.random(-SpawnArea.Size.Z/2, SpawnArea.Size.Z/2)
		local y = 3 -- Adjust how high the asset should be
		local Destroyed = false
		Position = Vector3.new(x, y, z)
		for index, object in pairs(ObjectsSpawned:GetChildren()) do
			if Position ~= nil and not object:IsA("Model") then 
				local Distance = (Position - object.Position).Magnitude
				if MaxDistance > Distance then
					Position = nil 
				end
			elseif Position ~= nil and object:IsA("Model") then 
				local Distance = (Position - object:GetPivot().Position).Magnitude
				if MaxDistance > Distance then
					Position = nil 
				end
			end
		end
		if Position ~= nil then 
			for i, v in pairs(Objects) do 
				local ClonedObject = v:Clone()
				ClonedObject.Parent = ObjectsSpawned
				print(y)
				print(Position)
				if v:IsA("Model") then 
					ClonedObject:MoveTo(Position)
				else 
					ClonedObject.Position = Position
				end
			end
		else 
			print("Postition chosen was too close to a tree in the area")
		end
	else 
		print("Tree spawn limit has been reached!")
	end
end
