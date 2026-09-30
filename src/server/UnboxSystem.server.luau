local Workspace = game:GetService("Workspace")

local UNBOX_COST = 100
local SQUISHY_POOL = {
    {Name = "NeonBerry", Chance = 50},   -- Common: 50%
    {Name = "CyberMint", Chance = 35},   -- Uncommon: 35%
    {Name = "GoldenAura", Chance = 14},  -- Rare: 14%
    {Name = "VoidCore", Chance = 1}      -- Legendary: 1%
}

-- 1. Construct the Physical Terminal
local unboxStation = Instance.new("Part")
unboxStation.Name = "SquishyUnboxer"
unboxStation.Size = Vector3.new(4, 5, 4)
unboxStation.Position = Vector3.new(12, 12.5, 0) -- Positioned near the Stage 1 Safe Hub
unboxStation.Anchored = true
unboxStation.Color = Color3.fromRGB(255, 215, 0) -- Solid Gold
unboxStation.Material = Enum.Material.Neon
unboxStation.Parent = Workspace

-- Modern UI Interaction node
local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Unbox Squishy (100 Coins)"
prompt.ObjectText = "Gacha Machine"
prompt.HoldDuration = 1
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.Parent = unboxStation

-- 2. Transaction & RNG Engine
prompt.Triggered:Connect(function(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    local inventory = player:FindFirstChild("SquishyInventory")
    
    if not leaderstats or not inventory then return end
    
    local coins = leaderstats:FindFirstChild("Coins")
    if coins and coins.Value >= UNBOX_COST then
        -- Deduct Capital
        coins.Value -= UNBOX_COST
        
        -- Execute Probability Roll
        local roll = math.random(1, 100)
        local cumulative = 0
        local wonSquishy = "NeonBerry" -- System Fallback
        
        for _, item in ipairs(SQUISHY_POOL) do
            cumulative += item.Chance
            if roll <= cumulative then
                wonSquishy = item.Name
                break
            end
        end
        
        -- Mint the Asset
        local newAsset = Instance.new("StringValue")
        newAsset.Name = wonSquishy
        newAsset.Value = "Owned"
        newAsset.Parent = inventory
        
        print("[System] Transaction Complete: " .. player.Name .. " unboxed [" .. wonSquishy .. "]")
        
        -- Hardware Feedback Loop (Flashes white upon success)
        unboxStation.Color = Color3.fromRGB(255, 255, 255)
        task.wait(0.2)
        unboxStation.Color = Color3.fromRGB(255, 215, 0)
    else
        print("[System] Override: " .. player.Name .. " has insufficient capital.")
        prompt.ActionText = "Insufficient Funds!"
        task.wait(2)
        prompt.ActionText = "Unbox Squishy (100 Coins)"
    end
end)
