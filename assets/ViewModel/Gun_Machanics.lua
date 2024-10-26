local tool = script.Parent
local players = game:GetService("Players")
local player = players.LocalPlayer
local mouse = player:GetMouse()
local debris = game:GetService("Debris")
local camera = workspace.CurrentCamera

local UIS = game:GetService("UserInputService")

local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("SoundService")

local GS = SS:WaitForChild("Gun_Sounds")
local GR = GS:WaitForChild("Gun Reload")

local GunModels = RS:WaitForChild("GunModels")

local GunRig = GunModels:WaitForChild("Pistol")

-- Configuration
local damage = 10
local bulletRange = 500 -- Range of the bullet in studs
local bulletHoleSize = Vector3.new(0.8, 0.8, 0.01) -- Size of the bullet hole
local bulletHoleLifetime = 10 -- Lifetime of the bullet hole in seconds
local soundId = "rbxassetid://9117401200" -- Replace with your sound asset ID
local bulletHoleTextureId = "http://www.roblox.com/asset/?id=113742165"

local Debounce = false

local Barrel_Max_Ammo = tool:GetAttribute("Ammo")

-- Function to handle shooting
local function shoot()
	print(Debounce)
	if tool:GetAttribute("Ammo") > 0 and not Debounce then 
		Debounce = true
		local origin = tool.Muzzle.Position
		local direction = (mouse.Hit.p - origin).unit * bulletRange

		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {player.Character}
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

		local result = workspace:Raycast(origin, direction, raycastParams)

		if result then
			local hitPart = result.Instance
			local hitPosition = result.Position

			-- Apply damage if the hit part belongs to a player
			local character = hitPart.Parent
			local humanoid = character:FindFirstChild("Humanoid")

			if humanoid then
				humanoid:TakeDamage(damage)
			else
				-- Create a bullet hole
				local decal = Instance.new("Decal")
				local bulletHole = Instance.new("Part")
				bulletHole.Size = bulletHoleSize
				bulletHole.Shape = Enum.PartType.Block
				bulletHole.Material = Enum.Material.Metal
				bulletHole.Transparency = 1
				bulletHole.CFrame = CFrame.new(hitPosition)
				bulletHole.Anchored = true
				bulletHole.CanCollide = false
				bulletHole.Parent = workspace
				decal.Name = "Hole"
				decal.Texture = bulletHoleTextureId 
				decal.Parent = bulletHole
				debris:AddItem(bulletHole, bulletHoleLifetime)

				-- Make bullet hole face the surface it hit
				local normal = result.Normal
				bulletHole.CFrame = CFrame.new(hitPosition, hitPosition + normal) * CFrame.new(0, 0, -bulletHole.Size.Z / 2)
			end
		end

		-- Play shooting sound
		local sound = Instance.new("Sound")
		sound.SoundId = soundId
		sound.Parent = tool.Muzzle
		sound:Play()

		tool.Muzzle.FlashVFX.Enabled = true

		task.spawn(function()
			tool.Muzzle.LightFlash.Enabled = true 
			tool.Muzzle.FlashVFX.Enabled = true
			task.wait(0.25)
			tool.Muzzle.LightFlash.Enabled = false 
			tool.Muzzle.FlashVFX.Enabled = false
		end)

		local ShootingAnim = Instance.new("Animation")
		ShootingAnim.AnimationId = "rbxassetid://"..tool:GetAttribute("Shooting_ID")
		ShootingAnim.Parent = camera.ViewModel

		local AnimPlayer = camera.ViewModel:FindFirstChild("Humanoid"):LoadAnimation(ShootingAnim)
		AnimPlayer:Play()

		-- Check if sound loaded successfully
		sound.Loaded:Connect(function()
			sound:Play()
		end)

		-- Cleanup sound after it finishes playing
		sound.Ended:Connect(function()
			sound:Destroy()
			ShootingAnim:Destroy()
		end)

		local Calc = tool:GetAttribute("Ammo") - 1
		print(Calc)
		tool:SetAttribute("Ammo", Calc)
		player.PlayerGui.GunUI.Ammo_In_Barrel.Text = tostring(tool:GetAttribute("Ammo"))
		Debounce = false
	elseif not Debounce then
		Debounce = true
		if tool:GetAttribute("Ammo_Left") > 0 then 
			local Calc = Barrel_Max_Ammo - tool:GetAttribute("Ammo")
			local Calc2 = tool:GetAttribute("Ammo_Left") - Calc
			tool:SetAttribute("Ammo_Left", Calc2)
			player.PlayerGui.GunUI.Ammo_Left.Text = tostring(tool:GetAttribute("Ammo_Left"))
			GR:Play()
			
			local ReloadAnim = Instance.new("Animation")
			ReloadAnim.AnimationId = "rbxassetid://"..tool:GetAttribute("Reload_ID")
			ReloadAnim.Parent = camera.ViewModel

			local AnimPlayer = camera.ViewModel:FindFirstChild("Humanoid"):LoadAnimation(ReloadAnim)
			AnimPlayer:Play()
			
			GR.Ended:Wait()
			tool:SetAttribute("Ammo", Barrel_Max_Ammo)
			player.PlayerGui.GunUI.Ammo_In_Barrel.Text = tostring(tool:GetAttribute("Ammo"))
		end
		Debounce = false
	end
end

UIS.InputBegan:Connect(function(Input, GPE)
	if Input.KeyCode == Enum.KeyCode.R and tool.Parent == player.Character then 
		if tool:GetAttribute("Ammo") < Barrel_Max_Ammo then 
			local Calc = Barrel_Max_Ammo - tool:GetAttribute("Ammo")
			local Calc2 = tool:GetAttribute("Ammo_Left") - Calc
			tool:SetAttribute("Ammo_Left", Calc2)
			player.PlayerGui.GunUI.Ammo_Left.Text = tostring(tool:GetAttribute("Ammo_Left"))
			GR:Play()
			
			local ReloadAnim = Instance.new("Animation")
			ReloadAnim.AnimationId = "rbxassetid://"..tool:GetAttribute("Reload_ID")
			ReloadAnim.Parent = camera.ViewModel

			local AnimPlayer = camera.ViewModel:FindFirstChild("Humanoid"):LoadAnimation(ReloadAnim)
			AnimPlayer:Play()
			
			tool:SetAttribute("Ammo", Barrel_Max_Ammo)
			player.PlayerGui.GunUI.Ammo_In_Barrel.Text = tostring(tool:GetAttribute("Ammo"))
		end
	end
end)

-- Connect the tool activation to the shoot function
tool.Activated:Connect(shoot)

local function RemoveGunRig()
	camera:FindFirstChild("ViewModel").Weapon:ClearAllChildren()
	player.Character:FindFirstChild("CharacterFirstPersonVisual"):SetAttribute("RunAnimationID", 18247406221)
	player.Character:FindFirstChild("CharacterFirstPersonVisual"):SetAttribute("IdleAnimationID", 18248051641)
end

local function AddGunRig()
	local ClonedGunRig = GunRig:Clone()
	camera:FindFirstChild("ViewModel").RightHand.GunGrip.Part1 = ClonedGunRig.GunGrip
	for _, parts in pairs(ClonedGunRig:GetChildren()) do 
		if parts:IsA("Part") then
			parts.Parent = camera:FindFirstChild("ViewModel").Weapon
		end
	end
	ClonedGunRig:Destroy()
	player.Character:FindFirstChild("CharacterFirstPersonVisual"):SetAttribute("RunAnimationID", 18419354428)
	player.Character:FindFirstChild("CharacterFirstPersonVisual"):SetAttribute("IdleAnimationID", 18477652921)
end

tool.Unequipped:Connect(function()
	RemoveGunRig()
	player.PlayerGui.GunUI.Enabled = false
	mouse.Icon = ""
end)

tool.Equipped:Connect(function()
	mouse.Icon = "rbxassetid://18209926479"
	player.PlayerGui.GunUI.Enabled = true
	player.PlayerGui.GunUI.Ammo_Left.Text = tool:GetAttribute("Ammo_Left")
	player.PlayerGui.GunUI.Ammo_In_Barrel.Text = tool:GetAttribute("Ammo")
	AddGunRig()
end)

for _, tool_part in pairs(tool:GetChildren()) do 
	if tool_part:IsA("Part") or tool_part:IsA("MeshPart") or tool:IsA("UnionOperation") then 
		tool_part.Transparency = 1
	end
end
