local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. Universal Leaderstats & Waves Architecture
Players.PlayerAdded:Connect(function(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player
        
        local stage = Instance.new("IntValue")
        stage.Name = "Stage"
        stage.Value = 1
        stage.Parent = leaderstats
        
        local coins = Instance.new("IntValue")
        coins.Name = "Coins"
        coins.Value = 500
        coins.Parent = leaderstats
        
        local waves = Instance.new("IntValue")
        waves.Name = "Waves"
        waves.Value = 0
        waves.Parent = leaderstats
    end
end)

-- 2. Wave Progression Hook
local waveEvent = ReplicatedStorage:FindFirstChild("WaveUpdateEvent")
if not waveEvent then
    waveEvent = Instance.new("RemoteEvent")
    waveEvent.Name = "WaveUpdateEvent"
    waveEvent.Parent = ReplicatedStorage
end

-- Allow server systems to broadcast wave increments to all players
waveEvent.OnServerEvent:Connect(function(player, newWave)
    -- Security validation could be placed here
end)
