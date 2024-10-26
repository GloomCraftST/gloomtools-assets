local DataStore = game:GetService("DataStoreService")
local PlayerTimeData = DataStore:GetDataStore("PlayerTimeData")
local PlayerData = DataStore:GetDataStore("PlayerData")

local Time = 86400
local HourWait = 24

game.Players.PlayerAdded:Connect(function(player)
	if PlayerData:GetAsync(player.UserId.."-HasSeen") then
		wait()
	else
		print("You Have Not Joined Before")
	end
end)

game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Parent = player
	leaderstats.Name = "leaderstats"
	
	local Money = Instance.new("IntValue")
	Money.Parent = leaderstats
	Money.Name = "Money"
	
	local TimeNow = os.time()
	
	local dataTime

	local data

	local success, err = pcall(function()
		data = PlayerData:GetAsync("playerdata"..player.UserId)
	end)
	if data and success then
		print(player.Name.." Has Joined Before")
	else
		print(player.Name.." Has Joined For The First Time")
	end
	pcall(function()
		dataTime = PlayerTimeData:GetAsync(player.UserId.."-Rewards")
		print("Getting Data")
	end)
	
	if success then
		print("Success")
		if data then
			print("Data Is Being Collected")

			Money.Value = data[1]

		else

		end
	else
		warn(err)
	end
	
	if dataTime ~= nil then 
		local TimeSinceLastClaim = TimeNow - dataTime
		local TargetData = TimeNow + (Time - TimeSinceLastClaim)
		
		print("Time since last "..TimeSinceLastClaim)
		if player then wait(1) end
		game.ReplicatedStorage.RewardEvents.SetTime:FireClient(player, 510, TargetData)
		
		if (TimeSinceLastClaim / 3600) >= HourWait then 
			local reward = math.random(5, 100)
			local connection 
			connection = game.ReplicatedStorage.RewardEvents.RewardEvent.OnServerEvent:Connect(function(Player)
				if Player == player then 
					print("Player gets a reward")
					PlayerTimeData:SetAsync(player.UserId.."-Rewards", os.time())
					Player.leaderstats.Money.Value += reward
					game.ReplicatedStorage.RewardEvents.SetTime:FireClient(player, 510, TargetData)
					connection:Disconnect()
				end
			end)
		else
			game.ReplicatedStorage.RewardEvents.SetTime:FireClient(player, 510, TargetData)
			print("Player is not ready for this reward yet")
		end
	else
		print("New Player")
		local reward = math.random(5, 100)
		local connection 
		connection = game.ReplicatedStorage.RewardEvents.RewardEvent.OnServerEvent:Connect(function(Player)
			if Player == player then 
				local SetTime = os.time()
				local TimeSinceLastClaim = 1
				local TargetData = SetTime + (Time - TimeSinceLastClaim)
				print("Player gets a reward")
				PlayerTimeData:SetAsync(player.UserId.."-Rewards", os.time())
				Player.leaderstats.Money.Value += reward
				game.ReplicatedStorage.RewardEvents.SetTime:FireClient(player, 510, TargetData)
				connection:Disconnect()
			end
		end)
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	print("Player is leaving the game")
	local leaderstats = player.leaderstats
	local Money = leaderstats.Money


	local data = {
		Money.Value,
	}
	
	print("Organizing Data")

	local success, err = pcall(function()
		print("Data found")
		PlayerData:SetAsync("playerdata"..player.UserId, data)
		print("Data sent")
	end)
	
	if success then
		print("data saved")
	else
		player:Kick("There Was An Error Loading Your Data")
		warn(err)
	end
end)
