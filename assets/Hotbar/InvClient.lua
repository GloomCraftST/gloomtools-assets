local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local SG = game:GetService("StarterGui")
local SS = game:GetService("SoundService")
local InvEvents = RS:WaitForChild("InvEvents")
local EquipE = InvEvents:WaitForChild("ToolEquip")
local SoundEffectsF = SS:WaitForChild("SoundEffects")
local POP = SoundEffectsF:WaitForChild("button click")
local InvFrame = script.Parent:WaitForChild("InventoryF")
local Slot = script:WaitForChild("Slot")
local Backpack = Player.Backpack
local Char = Player.Character

local CanSound = script:GetAttribute("Sounds")

SG:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

-- Xbox/PS Compatible <-- Means that it also works with Xbox/PS

local AddTo = false
local StartInv = false 
local Selected = 0
local Equiped = {}

local SlotsN = 0

local SlotsT = {}
local ItemsT = {}

local SlotTweenST = false

local NumberToKeyCode = {
	[1] = "One", 
	[2] = "Two",
	[3] = "Three", 
	[4] = "Four",
	[5] = "Five", 
	[6] = "Six",
	[7] = "Seven", 
	[8] = "Eight",
	[9] = "Nine", 
	[10] = "Zero"
}

local normalSize
local biggerSize

local SizeY = Slot.Size.Y.Scale + 0.5
local SizeX = Slot.Size.X.Scale + 0.1
biggerSize = UDim2.new(SizeX, 0, SizeY, 0)

SizeY -= 0.5
SizeX -= 0.1
normalSize = UDim2.new(SizeX, 0, SizeY, 0)

local function tweenBig(Frame)
	Frame:TweenSize(biggerSize, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, .15, true)
	if CanSound then
		POP:Play()
	end
end

local function tweenBack(Frame)
	Frame:TweenSize(normalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, .15, true)
	if CanSound then
		POP:Play()
	end
end

for i, Child in pairs(Backpack:GetChildren()) do 
	if Child ~= nil then 
		local SlotClone = Slot:Clone()
		SlotClone.Button.Text = Child.Name
		if Child.TextureId then 
			SlotClone.ItemImage.Image = Child.TextureId
		end
		SlotClone.Parent = InvFrame 
		table.insert(SlotsT, SlotClone)
		table.insert(ItemsT, Child)
		table.insert(Equiped, false)
		SlotClone.Name = Child.Name
		SlotsN += 1 
		SlotClone:SetAttribute("ToolName", Child.Name)
		SlotClone.Button.Activated:Connect(function()
			local Tool = Child
			EquipE:FireServer(Tool)
		end)
		for i, v in pairs(SlotsT) do
			if i == 10 then 
				SlotClone.Number.Text = "0"
			else 
				SlotClone.Number.Text = tostring(i)
			end
		end
	end
end

local function AddSlot(Child) 
	AddTo = true 
	for i, v in pairs(ItemsT) do 
		if v == Child and AddTo == true then
			AddTo = false
		end
	end
	if Child ~= nil and AddTo then 
		local SlotClone = Slot:Clone()
		SlotClone.Button.Text = Child.Name
		if Child.TextureId then 
			SlotClone.ItemImage.Image = Child.TextureId
		end
		SlotClone.Parent = InvFrame 
		table.insert(SlotsT, SlotClone)
		table.insert(ItemsT, Child)
		table.insert(Equiped, false)
		SlotClone:SetAttribute("ToolName", Child.Name)
		SlotsN += 1 
		SlotClone.Button.Activated:Connect(function()
			local Tool = Child
			EquipE:FireServer(Tool)
		end)
		for i, v in pairs(SlotsT) do
			if i == 10 then 
				SlotClone.Number.Text = "0"
			else 
				SlotClone.Number.Text = tostring(i)
			end
		end
	end
end

local function UpdateHotBar()
	for i, v in pairs(SlotsT) do
		v.Number.Text = i
	end
end

local function CharCheck(Child)
	if Child:IsA("Tool") and Child.Parent == Char then 
		for i, v in pairs(ItemsT) do 
			if v == Child then 
				local Slot = SlotsT[i]
				Equiped[i] = true
				tweenBig(Slot)
			end
		end
	elseif Child:IsA("Tool") and Child.Parent ~= Char then 
		for i, v in pairs(ItemsT) do 
			if v == Child then 
				local Slot = SlotsT[i]				
				Equiped[i] = false
				tweenBack(Slot)
			end
		end
	end
	for i, v in pairs(ItemsT) do
		if v == Child and Equiped[i] == false and Child.Parent ~= Char and Child.Parent ~= Backpack then
			table.remove(ItemsT, i)
			for index, Slot in pairs(SlotsT) do
				if index == i then 
					table.remove(SlotsT, i)
					for get, delslot in pairs(InvFrame:GetChildren()) do 
						if delslot:IsA("Frame") and delslot:GetAttribute("ToolName") == Child.Name then 
							SlotsN -= 1
							delslot:Destroy()
							UpdateHotBar()
						end
					end
				end
			end
		end
	end
end

local function SlotRemoval(Child)
	task.wait(0.5)
	for i, v in pairs(ItemsT) do
		if v == Child and Equiped[i] == false and Child.Parent ~= Char and Child.Parent ~= Backpack then
			table.remove(ItemsT, i)
			for index, Slot in pairs(SlotsT) do
				if index == i then 
					table.remove(SlotsT, i)
					for get, delslot in pairs(InvFrame:GetChildren()) do 
						if delslot:IsA("Frame") and delslot:GetAttribute("ToolName") == Child.Name then 
							SlotsN -= 1
							delslot:Destroy()
							UpdateHotBar()
						end
					end
				end
			end
		end
	end
end

UIS.InputBegan:Connect(function(Input, GPE)
	if UIS.GamepadEnabled == false then 
		for i, v in pairs(ItemsT) do 
			if Input.KeyCode == Enum.KeyCode[NumberToKeyCode[i]] then 
				local Tool = v
				EquipE:FireServer(Tool)
				Selected = i
			end
		end
	else 
		if Selected > SlotsN then 
			Selected = 0
		end
		if Input.KeyCode == Enum.KeyCode.ButtonB then 
			local Tool = ItemsT[Selected]
			EquipE:FireServer(Tool)
		end
		if Input.KeyCode == Enum.KeyCode.ButtonR1 then 
			Selected += 1
			if Selected <= 0 then 
				Selected = SlotsN
			elseif Selected > SlotsN then 
				Selected = 1 
			end
			local Tool = ItemsT[Selected]
			EquipE:FireServer(Tool)
		elseif Input.KeyCode == Enum.KeyCode.ButtonL1 then 
			Selected -= 1
			if Selected <= 0 then 
				Selected = SlotsN
			elseif Selected > SlotsN then 
				Selected = 1 
			end
			local Tool = ItemsT[Selected]
			EquipE:FireServer(Tool)
		end 
	end 
end)

Backpack.ChildAdded:Connect(AddSlot)
Char.ChildAdded:Connect(CharCheck)
Backpack.ChildRemoved:Connect(SlotRemoval)
Char.ChildRemoved:Connect(CharCheck)
