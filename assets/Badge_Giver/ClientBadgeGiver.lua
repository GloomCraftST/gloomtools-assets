local BadgeID = script:GetAttribute("BadgeID")
local Event_Connection = script:GetAttribute("Event_Connection")

local RS = game:GetService("ReplicatedStorage")
local FC = RS:WaitForChild("BadgeEvent (Connection)")
local Event = FC:WaitForChild(Event_Connection)

Event:FireServer(BadgeID)
