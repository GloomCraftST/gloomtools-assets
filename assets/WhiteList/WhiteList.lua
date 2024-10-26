local allowedPlayers = {"Player1", "Player2", "Player3"}

game:GetService("Players").PlayerAdded:Connect(function(player)
	local allowed = false

	for i, name in ipairs(allowedPlayers) do
		if name == player.Name then allowed = true print(player.Name.." has access to join the game!") end
	end

	if not allowed then player:Kick(player.Name.." is not allowed to join this game!") end
end)
