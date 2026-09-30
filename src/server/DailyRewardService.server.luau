local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local DailyDataStore = DataStoreService:GetDataStore("FunlandDaily_v1")
local COOLDOWN_SECONDS = 86400 -- 24 Hours in seconds

-- 1. Establish Network Bridge
local rewardEvent = ReplicatedStorage:FindFirstChild("ClaimDailyEvent")
if not rewardEvent then
    rewardEvent = Instance.new("RemoteEvent")
    rewardEvent.Name = "ClaimDailyEvent"
    rewardEvent.Parent = ReplicatedStorage
end

Players.PlayerAdded:Connect(function(player)
    local userId = tostring(player.UserId)
    local success, lastClaimTime = pcall(function()
        return DailyDataStore:GetAsync(userId)
    end)
    
    local currentTime = os.time()
    local canClaim = false
    
    if not success or not lastClaimTime or (currentTime - lastClaimTime >= COOLDOWN_SECONDS) then
        canClaim = true
    end
    
    -- Send status to client upon joining
    task.wait(2) -- Yield briefly to allow player UI to load
    rewardEvent:FireClient(player, "CheckStatus", canClaim)
end)

-- 2. Handle Claim Request
rewardEvent.OnServerEvent:Connect(function(player, action)
    if action ~= "Claim" then return end
    
    local userId = tostring(player.UserId)
    local currentTime = os.time()
    
    local success, lastClaimTime = pcall(function()
        return DailyDataStore:GetAsync(userId)
    end)
    
    if success and lastClaimTime and (currentTime - lastClaimTime < COOLDOWN_SECONDS) then
        print("[System] Daily Reward Denied: Cooldown active for " .. player.Name)
        return
    end
    
    -- Update Timestamp
    pcall(function()
        DailyDataStore:SetAsync(userId, currentTime)
    end)
    
    -- Grant Rewards: 500 Coins + Rare Squishy (GoldenAura)
    local leaderstats = player:FindFirstChild("leaderstats")
    local coins = leaderstats and leaderstats:FindFirstChild("Coins")
    local inventory = player:FindFirstChild("SquishyInventory")
    
    if coins then
        coins.Value += 500
    end
    
    if inventory and not inventory:FindFirstChild("GoldenAura") then
        local rewardAsset = Instance.new("StringValue")
        rewardAsset.Name = "GoldenAura"
        rewardAsset.Value = "Owned"
        rewardAsset.Parent = inventory
    end
    
    print("[System] Daily Reward Claimed by " .. player.Name .. " (+500 Coins, +GoldenAura)")
    rewardEvent:FireClient(player, "ClaimSuccess")
end)
