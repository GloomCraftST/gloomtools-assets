local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local Character = script.Parent

local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")

local AnimID = script:GetAttribute("FlipAnimationID")

local Anim = false

if AnimID ~= "" then
	local Animation = Instance.new("Animation")
	Animation.AnimationId = AnimID
	Anim = true
end

local animation = script:WaitForChild("FilpAnim")
local dance = Humanoid:LoadAnimation(animation)

local DJump = false
local AmountDmax = 1
local AmountD = 0
local debounce = false

local function JumpRequest()
	if DJump and AmountD < AmountDmax and not debounce then 

		local CounterC = 0
		debounce = true 				
		local PDH = Character.PrimaryPart.Position.Y - 1
		if Anim then dance:Play() end
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		AmountD += 1 

		wait(0.4)
		debounce = false
	end
end

spawn(function()
	while true do 
		wait(0.1)
		if Humanoid.FloorMaterial == Enum.Material.Air then 
			DJump = true 
			print(DJump)
		else 
			DJump = false
			print(DJump)
			AmountD = 0
		end
	end
end)

UIS.InputBegan:Connect(function(input, GPE)
	if input.KeyCode == Enum.KeyCode.Space then 
		JumpRequest()
	end
end)
