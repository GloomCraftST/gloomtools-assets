local Proxy = script.Parent:WaitForChild("ProximityPrompt")
local RS = game:GetService("ReplicatedStorage")
local CRE = RS:WaitForChild("RewardEvents")
local SetTimeE = CRE:WaitForChild("SetTime")
local WarnE = CRE:WaitForChild("Warn")
local GroupId = 14304379
local ServerCode = 509

Proxy.Triggered:Connect(function(Player)
	if Player:IsInGroup(GroupId) then 
		print(Player.Name.." is in the group!")
		SetTimeE:FireClient(Player, ServerCode)
	else 
		print(Player.Name.." is not in the group")
		WarnE:FireClient(Player)
	end
end)
