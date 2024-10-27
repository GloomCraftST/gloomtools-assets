return {
    {
        Type = "Script",
        Properties = {
            Source = [[
local LW = script.Parent.Parent.LeftWheel
local LW2 = script.Parent.Parent.LeftWheel2
local RW = script.Parent.Parent.RightWheel
local RW2 = script.Parent.Parent.RightWheel2

local Steer = script.Parent.Parent.Steer

local Vehicle = script.Parent

local RS = game:GetService("ReplicatedStorage")
local CE = RS:WaitForChild("CarEvents")
local PD = CE:WaitForChild("PlayerDriving")
local PSD = CE:WaitForChild("PlayerStoppedDriving")

local speed = 80

local Player = nil

task.spawn(function()
	while true do 
		wait(0.1)
		if Player ~= nil then 
			PD:FireClient(Player, Vehicle.AssemblyLinearVelocity.Magnitude*0.62620743779080167979, speed)
		end
	end
end)

Vehicle.Touched:Connect(function(TouchedPart)
	if TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid") then 
		local Char = TouchedPart.Parent
		wait(1)
		print(Char.Humanoid.Sit)
		if Char.Humanoid.Sit == true then  
			Player = game.Players:GetPlayerFromCharacter(Char)
		end
	end
end)

Vehicle.TouchEnded:Connect(function(TouchedPart)
	if TouchedPart.Parent:FindFirstChildWhichIsA("Humanoid") then 
		local Char = TouchedPart.Parent
		if Player and Char.Humanoid.Sit == false then 
			Player = nil 
			task.wait(0.15)
			PSD:FireClient(game.Players:GetPlayerFromCharacter(Char))
		end
	end
end)

script.Parent.Changed:Connect(function(property)
	print("dasad")
	LW.AngularVelocity = speed * script.Parent.Throttle
	LW2.AngularVelocity = speed * script.Parent.Throttle
	RW.AngularVelocity = speed * -script.Parent.Throttle
	RW2.AngularVelocity = speed * -script.Parent.Throttle
	Steer.TargetAngle = 15 * script.Parent.Steer
end)
            ]],
            Name = "CarScript",  -- Optional: name for the script
            Enabled = true         -- Optional: whether script starts enabled
        }
    }
}
