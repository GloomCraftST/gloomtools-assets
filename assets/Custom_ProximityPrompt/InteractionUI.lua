local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer

local playergui = localPlayer:WaitForChild("PlayerGui")
local customPrompt = ReplicatedStorage:WaitForChild("PromptHolder")

local GamepadButtonImage = {
	[Enum.KeyCode.ButtonX] = "rbxasset://textures/ui/Controls/xboxX.png",
	[Enum.KeyCode.ButtonY] = "rbxasset://textures/ui/Controls/xboxY.png",
	[Enum.KeyCode.ButtonA] = "rbxasset://textures/ui/Controls/xboxA.png",
	[Enum.KeyCode.ButtonB] = "rbxasset://textures/ui/Controls/xboxB.png",
	[Enum.KeyCode.DPadLeft] = "rbxasset://textures/ui/Controls/dpadLeft.png",
	[Enum.KeyCode.DPadRight] = "rbxasset://textures/ui/Controls/dpadRight.png",
	[Enum.KeyCode.DPadUp] = "rbxasset://textures/ui/Controls/dpadUp.png",
	[Enum.KeyCode.DPadDown] = "rbxasset://textures/ui/Controls/dpadDown.png",
	[Enum.KeyCode.ButtonSelect] = "rbxasset://textures/ui/Controls/xboxView.png",
	[Enum.KeyCode.ButtonStart] = "rbxasset://textures/ui/Controls/xboxmenu.png",
	[Enum.KeyCode.ButtonL1] = "rbxasset://textures/ui/Controls/xboxLB.png",
	[Enum.KeyCode.ButtonR1] = "rbxasset://textures/ui/Controls/xboxRB.png",
	[Enum.KeyCode.ButtonL2] = "rbxasset://textures/ui/Controls/xboxLT.png",
	[Enum.KeyCode.ButtonR2] = "rbxasset://textures/ui/Controls/xboxRT.png",
	[Enum.KeyCode.ButtonL3] = "rbxasset://textures/ui/Controls/xboxLS.png",
	[Enum.KeyCode.ButtonR3] = "rbxasset://textures/ui/Controls/xboxRS.png",
	[Enum.KeyCode.Thumbstick1] = "rbxasset://textures/ui/Controls/xboxLSDirectional.png",
	[Enum.KeyCode.Thumbstick2] = "rbxasset://textures/ui/Controls/xboxRSDirectional.png",
}
local KeyboardButtonImage = {
	[Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
	[Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
	[Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png",
}
local KeyboardButtonIconMapping = {
	["'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
	[","] = "rbxasset://textures/ui/Controls/comma.png",
	["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
	["."] = "rbxasset://textures/ui/Controls/period.png",
	[" "] = "rbxasset://textures/ui/Controls/spacebar.png",
}
local KeyCodeToTextMapping = {
	[Enum.KeyCode.LeftControl] = "Ctrl",
	[Enum.KeyCode.RightControl] = "Ctrl",
	[Enum.KeyCode.LeftAlt] = "Alt",
	[Enum.KeyCode.RightAlt] = "Alt",
	[Enum.KeyCode.F1] = "F1",
	[Enum.KeyCode.F2] = "F2",
	[Enum.KeyCode.F3] = "F3",
	[Enum.KeyCode.F4] = "F4",
	[Enum.KeyCode.F5] = "F5",
	[Enum.KeyCode.F6] = "F6",
	[Enum.KeyCode.F7] = "F7",
	[Enum.KeyCode.F8] = "F8",
	[Enum.KeyCode.F9] = "F9",
	[Enum.KeyCode.F10] = "F10",
	[Enum.KeyCode.F11] = "F11",
	[Enum.KeyCode.F12] = "F12",
}


local function getScreenGui()
	local screenGui = playergui:FindFirstChild("UIPromptHolder")
	if screenGui == nil then 
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "UIPromptHolder"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = playergui
	end
	return screenGui
end

local function createPrompt(prompt, inputType, gui)
	local promptUI = customPrompt:Clone()
	local InputFrame = promptUI:WaitForChild("InputFrame")
	local buttonImage = promptUI.InputFrame.ButtonImage
	local buttonText = promptUI.InputFrame.ButtonText
	
	local textTable = {buttonText}
	
	local function  updateUIFromPrompt()
		if inputType == Enum.ProximityPromptInputType.Gamepad then 
			if GamepadButtonImage[prompt.GamepadKeyCode] then 
				buttonImage.Image = GamepadButtonImage[prompt.GamepadKeyCode]
			end
		elseif inputType == Enum.ProximityPromptInputType.Touch then 
			buttonImage.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png"
		else 
			-- buttonImage.Image = "rbxasset://textures/ui/Controls/key_single.png"
			local buttonTextString = UserInputService:GetStringForKeyCode(prompt.KeyboardKeyCode)
			
			local buttonTextImage = KeyboardButtonImage[prompt.KeyboardKeyCode]
			if buttonTextImage == nil then 
				buttonTextImage = KeyboardButtonIconMapping[buttonTextString]
			end
			
			if buttonTextImage == nil then 
				local KeyCodeMappedText = KeyCodeToTextMapping[prompt.KeyboardKeyCode]
				if KeyCodeMappedText then 
					buttonTextString = KeyCodeMappedText
				end
			end
			
			if buttonTextImage then 
				buttonImage.Image = buttonTextImage
			elseif buttonTextString ~= nil and buttonTextString ~= '' then
				buttonText.Text = buttonTextString
			else 
				error("ProximityPrompt '"..prompt.Name.."' has an unexpected keycode for rendering UI: " .. tostring(prompt.KeyboardKeyCode))
			end
		end
	end
	
	updateUIFromPrompt()
	
	-- Tween Variables
	local tweenForFadeOut = {}
	local tweenForFadeIn = {}
	local EndtweenForFadeOut = {}
	local EndtweenForFadeIn = {}
	local tweenInfoFast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	-- Text Tweens
	for _, object in ipairs(textTable) do 
		table.insert(EndtweenForFadeOut, TweenService:Create(object, tweenInfoFast, { TextTransparency = 1 }))
		table.insert(EndtweenForFadeIn, TweenService:Create(object, tweenInfoFast, { TextTransparency = 0 }))
	end
	
	for _, object in ipairs(textTable) do 
		table.insert(tweenForFadeOut, TweenService:Create(object, tweenInfoFast, { TextTransparency =  0}))
		table.insert(tweenForFadeIn, TweenService:Create(object, tweenInfoFast, { TextTransparency = 0}))
	end
	
	-- frame Tweens
	table.insert(tweenForFadeOut, TweenService:Create(InputFrame, tweenInfoFast, { Size = UDim2.new(0, 80,0, 80) , Position = UDim2.new(0, 10,0, 10), BackgroundTransparency = 0, Visible = true}))
	table.insert(tweenForFadeIn, TweenService:Create(InputFrame, tweenInfoFast, { Size = UDim2.new(0, 95,0, 95) , Position = UDim2.new(0, 2,0, 2) , BackgroundTransparency = 0, Visible = true }))
	
	table.insert(EndtweenForFadeOut, TweenService:Create(InputFrame, tweenInfoFast, { BackgroundTransparency = 1, Visible = false }))
	table.insert(EndtweenForFadeIn, TweenService:Create(InputFrame, tweenInfoFast, { BackgroundTransparency = 0, Visible = true }))
	
	if inputType == Enum.ProximityPromptInputType.Touch or prompt.ClickablePrompt then 
		local button = Instance.new("TextButton")
		button.BackgroundTransparency = 1
		button.TextTransparency = 1
		button.Size = UDim2.fromScale(1, 1)
		button.Parent = promptUI.InputFrame
		
		local buttonDown = false
		
		button.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and 
				input.UserInputState ~= Enum.UserInputState.Change then
				prompt:InputHoldBegin()
				buttonDown = true 
				print("Yes I have been Touched")
			end
		end)
		button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				if buttonDown then
					buttonDown = false
					prompt:InputHoldEnd()
					print("Yes Touch has ended")
				end
			end
		end)
		
		promptUI.Active = true 
	end
	
	-- Variables for event connections
	local triggeredConnection
	local tiggeredEndedConnection 
	
	-- Connect to events to play tweens when Triggered/Ended
	triggeredConnection = prompt.Triggered:Connect(function()
		for _, tween in ipairs(tweenForFadeOut) do 
			tween:Play()
			
		end
	end)
	
	tiggeredEndedConnection = prompt.TriggerEnded:Connect(function()
		for _, tween in ipairs(tweenForFadeIn) do 
			tween:Play()

		end
	end)
	
	-- Make the Prompt actually show up on screen 
	promptUI.Adornee = prompt.Parent
	promptUI.Parent = gui
	for _, tween in ipairs(EndtweenForFadeIn) do 
		tween:Play()
		InputFrame.UIStroke.Transparency = 0
	end
	
	
	local function cleanupFunction()
		triggeredConnection:Disconnect()
		tiggeredEndedConnection:Disconnect()
		
		for _, tween in ipairs(EndtweenForFadeOut) do 
			tween:Play()
			InputFrame.UIStroke.Transparency = 1
		end
		
		wait(0.2)
		
		promptUI.Parent = nil 
	end
	
	return cleanupFunction
end

ProximityPromptService.PromptShown:Connect(function(prompt, inputType)
	if prompt.Style == Enum.ProximityPromptStyle.Default then 
		return
	end
	
	local gui = getScreenGui()
	
	local cleanupFunction = createPrompt(prompt, inputType, gui)
	
	prompt.PromptHidden:Wait()
	
	cleanupFunction()
end)
