local animation = script:WaitForChild('WalkAnim')
local humanoid = script.Parent:WaitForChild('Humanoid')
local WalkAnim = humanoid:LoadAnimation(animation)

local animation2 = script:WaitForChild('IdleAnim')
local humanoid2 = script.Parent:WaitForChild('Humanoid')
local IdleAnim = humanoid:LoadAnimation(animation2)

local Zombie = script.Parent

Zombie.Humanoid.Running:Connect(function(speed)
	if speed > 0.1 then
		WalkAnim:Play()
		IdleAnim:Stop()
	else 
		WalkAnim:Stop()
		IdleAnim:Play()
	end
end)
