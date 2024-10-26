local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local CRE = RS:WaitForChild("RewardEvents")
local WarnE = CRE:WaitForChild("Warn")

local debounce = false

WarnE.OnClientEvent:Connect(function()
	if not debounce then 
		debounce = true
		script.Parent.WarnMessage.Visible = true
		wait(4)
		script.Parent.WarnMessage.Visible = false
		wait(1)
		debounce = false
	end
end)
