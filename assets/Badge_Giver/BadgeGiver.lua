
local BadgeID = nil
local RS = game:GetService("ReplicatedStorage")
local Event_Connection = script:GetAttribute("Event_Connection")
local BS = game:GetService("BadgeService")

local CF = RS:WaitForChild("BadgeEvent (Connection)")
local Event = CF:WaitForChild(Event_Connection)

Event.OnServerEvent:Connect(function(plr, ID)
	BadgeID = ID
	print(plr.Name.." has gotten this badge "..BadgeID)
	BS:AwardBadge(plr.UserId, BadgeID)
end)
