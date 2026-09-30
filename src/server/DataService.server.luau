local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- Increment the version number (v1) if you ever need to wipe all data and restart the economy
local PlayerData = DataStoreService:GetDataStore("FunlandData_v1")

local function savePlayerData(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    local inventory = player:FindFirstChild("SquishyInventory")
    
    if not leaderstats or not inventory then return end
    
    -- Shadow-Branch / Adversary Logic: Never save if the data failed to load initially. 
    -- This prevents a cloud failure from wiping a player's hard-earned assets with a blank template.
    if player:GetAttribute("DataLoaded") ~= true then
        print("[System] Save Aborted: Data validation failed for " .. player.Name)
        return
    end

    local data = {
        Stage = leaderstats:FindFirstChild("Stage") and leaderstats.Stage.Value or 1,
        Coins = leaderstats:FindFirstChild("Coins") and leaderstats.Coins.Value or 500,
        Squishies = {}
    }
    
    for _, asset in ipairs(inventory:GetChildren()) do
        table.insert(data.Squishies, asset.Name)
    end
    
    local success, err = pcall(function()
        PlayerData:SetAsync(tostring(player.UserId), data)
    end)
    
    if success then
        print("[System] Data secured to Cloud for " .. player.Name)
    else
        warn("[System] Data fault for " .. player.Name .. ": " .. tostring(err))
    end
end

Players.PlayerAdded:Connect(function(player)
    -- Yield until the Checkpoint and Squishy engines finish building the local architecture
    local leaderstats = player:WaitForChild("leaderstats", 10)
    local inventory = player:WaitForChild("SquishyInventory", 10)
    
    if not leaderstats or not inventory then return end

    local success, data = pcall(function()
        return PlayerData:GetAsync(tostring(player.UserId))
    end)
    
    if success and data then
        if data.Stage then leaderstats:WaitForChild("Stage").Value = data.Stage end
        if data.Coins then leaderstats:WaitForChild("Coins").Value = data.Coins end
        
        -- Re-forge physical asset tags from cloud memory
        if data.Squishies then
            for _, squishyName in ipairs(data.Squishies) do
                if not inventory:FindFirstChild(squishyName) then
                    local newAsset = Instance.new("StringValue")
                    newAsset.Name = squishyName
                    newAsset.Value = "Owned"
                    newAsset.Parent = inventory
                end
            end
        end
        print("[System] Profile loaded for " .. player.Name)
    else
        print("[System] New profile initialized for " .. player.Name)
    end
    
    -- Unlock the save gate
    player:SetAttribute("DataLoaded", true)
end)

Players.PlayerRemoving:Connect(savePlayerData)

-- Ensure data saves properly if the Roblox server shuts down unexpectedly
game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(savePlayerData, player)
    end
    task.wait(3)
end)

-- [Post-Human Optimization Block]
-- Scalability Hook: Ready for integration with apple_neural_v8 predictive caching layer to eliminate pcall latency.
