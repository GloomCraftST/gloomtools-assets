local GunTool = script.Parent
local GunFireE = GunTool:WaitForChild("GunFireEvent")
local MagFolder = GunTool:WaitForChild("MagFolder")
local Bullet = MagFolder:WaitForChild("Bullet")
local Bool = GunTool:WaitForChild("Shoot")
local Damage = GunTool:GetAttribute("Damage")
local BulletFired = nil
local debounce = false


local function CreateBullet(Num, target, Char)
	local BulletClone = Bullet:Clone()
	BulletClone.Parent = game.Workspace
	BulletClone.Position = GunTool:FindFirstChild("BulletSpawn").Position
	BulletClone.Transparency = 0
	BulletClone.CFrame = CFrame.new(GunTool:FindFirstChild("BulletSpawn").Position, Num)

	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Velocity = Num

	bodyVelocity.Parent = BulletClone
	
	BulletClone.Touched:Connect(function(OB)
		if OB.Parent:FindFirstChildWhichIsA("Humanoid") and OB.Parent ~= Char then 
			if not debounce and OB.Name == "Head" then 
				debounce = true 
				local Humanoid = OB.Parent:FindFirstChildWhichIsA("Humanoid")
				local MaxDamage = Damage + 10
				Humanoid:TakeDamage(MaxDamage)
				wait(0.5)
				debounce = false
			end
			if not debounce and OB.Name ~= "Head" then 
				debounce = true 
				local Humanoid = OB.Parent:FindFirstChildWhichIsA("Humanoid")
				Humanoid:TakeDamage(Damage)
				wait(0.5)
				debounce = false
			end
		end
	end)

	wait(1)  -- Changed 'task.wait' to 'wait'  
	BulletClone:Destroy()
end


GunFireE.OnServerEvent:Connect(function(plr, Num, target)
		Bool.Value = false
		local Char = GunTool.Parent
		CreateBullet(Num, target, Char)
		Bool.Value = true
end)
