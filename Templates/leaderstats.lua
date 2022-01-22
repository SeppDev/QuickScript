local DataStoreService = game:GetService('DataStoreService')
local DataStore = DataStoreService:GetDataStore('DataStore')

local DefaultStats = {
['Example'] = 100,
}

local With_DataStores = true
local Save_Cooldown = 10

function Save(Player)
	if With_DataStores == true then
		local StatsData = {}

		for i, v in pairs(Player:FindFirstChild('leaderstats'):GetChildren()) do
			if DefaultStats[v.Name] then
				table.insert(StatsData,1,{

					['Name'] = v.Name,
					['Value'] = v.Value

				})
			end

		end

		DataStore:SetAsync(Player.UserId,StatsData)
	end
end

game.Players.PlayerAdded:Connect(function(Player)
	local Leaderstats = Instance.new('Folder',Player)
	Leaderstats.Name = 'leaderstats'

	local Data = DefaultStats

	for Name, Value in pairs(DefaultStats) do
		local NumberValue = Instance.new('NumberValue',Leaderstats)
		NumberValue.Name = tostring(Name)


		NumberValue.Value = tonumber(Value)
	end
	
	if With_DataStores == true then
		for _, Value in pairs(Leaderstats:GetChildren()) do
			Data = DataStore:GetAsync(Player.UserId)

			if With_DataStores == true then
				for _, DataValue in pairs(Data) do
					if DataValue['Name'] == Value.Name then
						Value.Value = DataValue['Value']
					end
				end
			end
		end
	end
	
	if With_DataStores == true then
	    repeat wait(math.max(6,Save_Cooldown))
		   Save(Player)
		until Player.Parent == nil
	end
end)

game.Players.PlayerRemoving:Connect(function(Player)
	Save(Player)
end)
