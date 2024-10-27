return {
    {
        Type = "LocalScript",
        Properties = {
            Source = [[
local RS = game:GetService("ReplicatedStorage")
local CE = RS:WaitForChild("CarEvents")
local PD = CE:WaitForChild("PlayerDriving")
local PSD = CE:WaitForChild("PlayerStoppedDriving")

local TXTSpeed = script.Parent:WaitForChild("Speed")
local DialBar = script.Parent:WaitForChild("DialBar")

PD.OnClientEvent:Connect(function(Speed, MaxSpeed)
	script.Parent.Enabled = true
	if Speed <= MaxSpeed then 
		TXTSpeed.Text = math.floor(Speed).." mph"
		DialBar.UpDownBar.Size = UDim2.new(Speed/MaxSpeed,0,1,0)
	end
end)

PSD.OnClientEvent:Connect(function()
	script.Parent.Enabled = false
end)
            ]],
            Name = "CarClient",  -- Optional: name for the script
            Enabled = true         -- Optional: whether script starts enabled
        }
    }
}
