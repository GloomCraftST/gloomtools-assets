local DataStore = game:GetService("DataStoreService")
local WinsLeaderboard = DataStore:GetOrderedDataStore("WinsLeaderboard")
local WinsLeaderboardG = DataStore:GetOrderedDataStore("WinsLeaderboardG")
local Dont = false

local function updateLeaderboardG()
	local success, errorMessage = pcall(function()
		local Data = WinsLeaderboard:GetSortedAsync(false, 100)
		local WinsPage = Data:GetCurrentPage()
		for Rank, data in ipairs(WinsPage) do 
			local userName = game.Players:GetNameFromUserIdAsync(tonumber(data.key))
			local Name = userName
			local Wins = data.value 
			local isOnLeaderboard = false 
			for i, v in pairs(game.Workspace.LeaderboardA.LeaderPart.Leader.leaderboardgui.Holder:GetChildren()) do 
				if v.name.Text == Name then 
					isOnLeaderboard = true 
					break
				end
			end
				if Wins and isOnLeaderboard == false then 
						local newLbFrame = game.ReplicatedStorage:WaitForChild("LeaderboardFrameG"):Clone()
						local sds = Instance.new("UIListLayout")
						sds.Parent = game.Workspace.LeaderboardA.LeaderPart.Leader.leaderboardgui.Holder
						newLbFrame.name.Text = Name
						newLbFrame.MelvinHeads.Text = Wins
						newLbFrame.number.Text = "#"..Rank
						newLbFrame.Position = UDim2.new(0,0, newLbFrame.Position.Y.Scale + (.08 * #game.Workspace.LeaderboardA.LeaderPart.Leader.leaderboardgui.Holder:GetChildren()), 0)
						newLbFrame.Parent = game.Workspace.LeaderboardA.LeaderPart.Leader.leaderboardgui.Holder
					end
				end
			end)

	if not success then 
		print(errorMessage)
	end
end

while true do 
	print("Whatdu")
	for _, player in pairs(game.Players:GetPlayers()) do
				WinsLeaderboard:SetAsync(player.UserId, player.leaderstats:FindFirstChild(script:GetAttribute("ValName")).Value)
		end
	for _, frame in pairs(game.Workspace.LeaderboardA.LeaderPart.Leader.leaderboardgui.Holder:GetChildren()) do 
		frame:Destroy()
	end
	updateLeaderboardG()
	print("Updated")
	
	task.wait(30)
end
