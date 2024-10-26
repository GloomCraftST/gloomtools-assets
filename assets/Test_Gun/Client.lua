local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local GunTool = script.Parent
local GunFireE = GunTool:WaitForChild("GunFireEvent")
local Bool = GunTool:WaitForChild("Shoot")
local Sounds = GunTool:WaitForChild("Sounds")
local GunShot = Sounds:WaitForChild("Gun Shot")
local ReloadS = Sounds:WaitForChild("Reload")
local MaxAmmo = GunTool:GetAttribute("MaxAmmo")
local Ammo = GunTool:GetAttribute("Ammo")
local GunUI = Player.PlayerGui.GunUI
local debounce = false

task.spawn(function()
	while true do 
		wait(0.1)
		if Ammo > 0 then 
			GunUI.ReloadMessage.Visible = false
			GunUI["Ammo/MaxAmmo"].Text = Ammo.."/"..MaxAmmo
			GunUI["Ammo/MaxAmmo"].TextColor3 = Color3.fromRGB(0, 0, 0)
		elseif Ammo <= 0 then 
			GunUI.ReloadMessage.Visible = true
			GunUI["Ammo/MaxAmmo"].Text = Ammo.."/"..MaxAmmo
			GunUI["Ammo/MaxAmmo"].TextColor3 = Color3.fromRGB(255, 0, 4)
		end
	end
end)

GunTool.Unequipped:Connect(function()
	GunUI["Ammo/MaxAmmo"].Visible = false
end)

GunTool.Equipped:Connect(function()
	GunUI["Ammo/MaxAmmo"].Visible = true
end)

UIS.InputBegan:Connect(function(input, GPE)
	if input.KeyCode == Enum.KeyCode.R and Ammo ~= MaxAmmo then 
		Ammo = MaxAmmo
		ReloadS:Play()
	end
end)

GunTool.Activated:Connect(function()
		GunUI["Ammo/MaxAmmo"].Visible = true
		if Bool.Value == true and Ammo > 0 then 
			local Mouse = Player:GetMouse()
			local target = Mouse.Origin.Position
			
			local Num = Mouse.UnitRay.Direction * 300
			GunFireE:FireServer(Num, target)
			print("shoot")
			Ammo -= 1
			GunShot:Play()
		elseif Ammo <= 0 then 
			wait(0.5)
			
			Ammo = MaxAmmo
			ReloadS:Play()
		end
end)
