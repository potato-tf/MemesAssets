local function chatMessage(string)
	local allPlayers = ents.GetAllPlayers()
	for _, player in pairs(allPlayers) do
		player:AcceptInput("$DisplayTextChat", string)
	end

end