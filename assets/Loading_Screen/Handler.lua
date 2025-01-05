local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local Player = game:GetService("Players").LocalPlayer

local Main = script.Parent:WaitForChild("Main")
local Holder = Main:WaitForChild("Holder")

local SAG = script:GetAttribute("StartAtGame")

ReplicatedFirst:RemoveDefaultLoadingScreen()

local Assets = game:GetDescendants()

if SAG then

	for i = 1, #Assets do
		local Asset = Assets[i]
		local Percentage = math.round(i/#Assets * 100)
		
		ContentProvider:PreloadAsync({Asset})
		
		Holder.AssetsLoaded.Text = "Loading Assets ("..i.."/"..#Assets..")"
		
		TweenService:Create(Holder.Bar, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(Percentage/100, 1)}):Play()
		
		if i % 5 == 0 then
			wait()
		end
		
		if i == #Assets then
			wait(1)
		end
	end
	
	local OutTI = TweenInfo.new(1, Enum.EasingStyle.Quint)
	
	TweenService:Create(Main, OutTI, {BackgroundTransparency = 1}):Play()
	
	for i, ui in pairs(Main:GetChildren()) do
		if ui.ClassName == "Frame" then
			TweenService:Create(ui, OutTI, {BackgroundTransparency = 1}):Play()
			TweenService:Create(ui.Bar, OutTI, {BackgroundTransparency = 1}):Play()
			TweenService:Create(ui.AssetsLoaded, OutTI, {TextTransparency = 1}):Play()
			
		elseif ui.ClassName == "TextLabel" then
			TweenService:Create(ui, OutTI, {TextTransparency = 1}):Play()
		end
		
		if ui:FindFirstChildWhichIsA("UIStroke") then
			local Stroke = ui:FindFirstChildWhichIsA("UIStroke")
			
			TweenService:Create(Stroke, OutTI, {Transparency = 1}):Play()
		end
	end
end
