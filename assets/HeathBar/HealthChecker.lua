local HealthUI = script.Parent
local Humanoid = HealthUI.Parent:WaitForChild("Humanoid")
local Greenbar = HealthUI:WaitForChild("GreenBar")

local TS = game:GetService("TweenService")

local HealthTxt = HealthUI:WaitForChild("HealthTXT")

local MaxHealth = Humanoid.MaxHealth

local StartingHealth = Humanoid.Health

HealthTxt.Text = StartingHealth.."/"..MaxHealth

Humanoid.HealthChanged:Connect(function(Health)
	local SmoothAnim = TS:Create(Greenbar, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Size = UDim2.new(Health/MaxHealth,0, 0.6,0)})
	SmoothAnim:Play()
	HealthTxt.Text = Health.."/"..MaxHealth
end)
