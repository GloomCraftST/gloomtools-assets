local zombie = script.Parent
local root = zombie:WaitForChild('HumanoidRootPart')
local humanoid = zombie:WaitForChild('Humanoid')
local players = game:GetService('Players')
local debounce = false

local animation = script:WaitForChild('AttackAnim')
local humanoid = script.Parent:WaitForChild('Humanoid')
local AttackAnim = humanoid:LoadAnimation(animation)

local function nearestPlayer()
	local temp = nil 
	local distance = 50
	for _,plr in pairs(players:GetPlayers()) do 
		if plr then 
			local character = plr.Character
			if character  then 
				local h = character:FindFirstChildWhichIsA('Humanoid')
				if h and h.Health > 0 then 
					local r = character:FindFirstChild('HumanoidRootPart')
					if r then 
						local dist = (r.Position - root.Position).Magnitude
						if dist < distance then 
							distance = dist
							temp = r 
						end
					end
				end
			end
		end
	end
	return temp
end

humanoid.Touched:Connect(function(hit)
	if hit.Parent.Name == "Zombie" then
		
	elseif zombie.Humanoid.Health > 0 then
		local h = hit.Parent:FindFirstChildWhichIsA("Humanoid")
		if h and h.Health > 0 and not debounce then 
			
			debounce = true
			h:TakeDamage(10)
			AttackAnim:Play()
			wait(0.8)
			debounce = false
		end 
	end
end)

while true do 
	wait(0.2)
	game:GetService('RunService').Heartbeat:Wait()
	local r = nearestPlayer()
	if zombie.Humanoid.Health <= 0 then
		zombie:Destroy()
	end
	if r then 
		humanoid:MoveTo(r.Position)
	end
end
