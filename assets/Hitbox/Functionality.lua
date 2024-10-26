local Tool = script.Parent
local Hitpoint = Tool:WaitForChild("Pickaxe")

local SwipeAnim = script:WaitForChild("PickSwipe")

local CS = game:GetService("CollectionService")

local Damage = Tool:GetAttribute("Damage")
local MaxDistance = Tool:GetAttribute("Max_Distance")

local Debounce = false 
local Debounce2 = false
local Hit = false

local Character = nil

Tool.Activated:Connect(function()
	if not Debounce then 
		Debounce = true 
		print("Hit")
		Character = Tool.Parent
		if Character:FindFirstChild("Humanoid") then 
			local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
			local AnimPlay = Humanoid:LoadAnimation(SwipeAnim)
			AnimPlay:Play()
		end
		Hit = true
		task.wait(1.6)
		Debounce = false
	end
end)

task.spawn(function()
	while true do 
		wait(0.1)
		for i, object in pairs(CS:GetTagged("Breakable_Object")) do 
			local Distance = (object.Position - Hitpoint.Position).Magnitude
			if MaxDistance > Distance then 
				if not Debounce2 and Debounce then 
					Debounce2 = true 
					local Health = object:GetAttribute("Health")
					local Calc = Health - Damage 
					object:SetAttribute("Health", Calc)
					task.wait(1.6)
					Debounce2 = false
				end
			end
		end
	end
end)
