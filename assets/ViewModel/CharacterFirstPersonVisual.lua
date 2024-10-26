local RS = game:GetService("RunService")
local PS = game:GetService("PhysicsService")

local CurrentCamera = workspace.CurrentCamera

if CurrentCamera:FindFirstChild("ViewModel") then 
	CurrentCamera:FindFirstChild("ViewModel"):Destroy()
end

local Character = script.Parent
local Animator = Character:WaitForChild("Humanoid"):WaitForChild("Animator")

local ViewModel = game.ReplicatedStorage.ViewModels.TexturedCharacter

local NewViewModel = ViewModel:Clone()
NewViewModel.Parent = CurrentCamera
NewViewModel.Name = "ViewModel"

NewViewModel.Shirt.ShirtTemplate = Character.Shirt.ShirtTemplate 
local BodyColors = Character:FindFirstChildWhichIsA("BodyColors"):Clone()
BodyColors.Parent = NewViewModel

if Character:FindFirstChildWhichIsA("Humanoid") then 
	local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
	
	NewViewModel.Humanoid.RigType = Humanoid.RigType

	for _, Value in Humanoid:GetChildren() do
		if Value:IsA("NumberValue") then 
			local ClonedValue = Value:Clone()
			ClonedValue.Parent = NewViewModel.Humanoid
		end
	end

	local IdleAnim = "rbxassetid://"..script:GetAttribute("IdleAnimationID")
	local RunAnim = "rbxassetid://"..script:GetAttribute("RunAnimationID")
	
	-- 18247406221
	
	print(RunAnim)

	local Animation = Instance.new("Animation", NewViewModel)
	Animation.Name = "RunAnim"
	Animation.AnimationId = RunAnim

	local Animation2 = Instance.new("Animation", NewViewModel)
	Animation2.Name = "IdleAnim"
	Animation2.AnimationId = IdleAnim
	
	local IdleAnimation = NewViewModel.Humanoid:LoadAnimation(Animation2)
	local RunAnimation = NewViewModel.Humanoid:LoadAnimation(Animation)
	
	IdleAnimation:Play()

	local RunAnimTwo = "RunAnim"
	local IdleAnimTwo = "Animation1"
	Animator.AnimationPlayed:Connect(function(AnimationTrack)
		print(AnimationTrack.Name)
		if AnimationTrack.Name == RunAnimTwo then 
			if not RunAnimation.IsPlaying then
				print(RunAnim)
				RunAnimation:Play()
				IdleAnimation:Stop()
				print("Playing Walk Anim")
			end
		elseif AnimationTrack.Name == IdleAnimTwo then 
			if RunAnimation.IsPlaying then
				RunAnimation:Stop()
				IdleAnimation:Play()
				print("Stopping Walk Anim")
			end
		end
	end)

	RS.RenderStepped:Connect(function()
		NewViewModel.PrimaryPart.CFrame = (CurrentCamera.CFrame * CFrame.new(0, -2.2, -1.5))
	end)
	
	script.AttributeChanged:Connect(function(AttributeName)
		if AttributeName == "RunAnimationID" then
			local AnimPlaying = false
			if RunAnimation.IsPlaying then AnimPlaying = true end 
			RunAnimation:Stop()
			RunAnim = "rbxassetid://"..script:GetAttribute("RunAnimationID")
			Animation.AnimationId = RunAnim
			RunAnimation = NewViewModel.Humanoid:LoadAnimation(Animation)
			if AnimPlaying then 
				RunAnimation:Play()
			end
		end
		if AttributeName == "IdleAnimationID" then 
			IdleAnimation:Stop()
			IdleAnim = "rbxassetid://"..script:GetAttribute("IdleAnimationID")
			Animation2.AnimationId = IdleAnim
			IdleAnimation = NewViewModel.Humanoid:LoadAnimation(Animation2)
			if not RunAnimation.IsPlaying then 
				IdleAnimation:Play()
			end
		end
	end)
end
