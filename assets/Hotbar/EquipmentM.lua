local RS = game:GetService("ReplicatedStorage")
local InvEvents = RS:WaitForChild("InvEvents")
local ToolEquipE = InvEvents:WaitForChild("ToolEquip")


ToolEquipE.OnServerEvent:Connect(function(plr, Tool) 
	if Tool ~= nil then 
		if Tool.Parent == plr.Backpack then 
			plr.Character:FindFirstChildWhichIsA("Humanoid"):UnequipTools()
			plr.Character:FindFirstChildWhichIsA("Humanoid"):EquipTool(Tool)
		elseif Tool.Parent == plr.Character then 
			plr.Character:FindFirstChildWhichIsA("Humanoid"):UnequipTools()
		end
	end
end)
