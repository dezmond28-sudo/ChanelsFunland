local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. The Asset Vault (Stored in ReplicatedStorage so Client and Server can access it)
local vault = Instance.new("Folder")
vault.Name = "SquishyVault"
vault.Parent = ReplicatedStorage

local function forgeSquishy(name, color)
    local squishy = Instance.new("Part")
    squishy.Name = name
    squishy.Shape = Enum.PartType.Ball
    squishy.Size = Vector3.new(1.5, 1.5, 1.5)
    squishy.Color = color
    squishy.Material = Enum.Material.SmoothPlastic
    squishy.Reflectance = 0.25
    
    -- Inject custom physics to make it literally bounce like a squishy
    local phys = PhysicalProperties.new(0.1, 0.3, 1.2, 1, 1)
    squishy.CustomPhysicalProperties = phys
    
    -- Keep it anchored while in the vault so physics don't calculate until it spawns
    squishy.Anchored = true 
    squishy.Parent = vault
end

print("[System] Forging 3D Squishy Templates...")
forgeSquishy("NeonBerry", Color3.fromRGB(255, 0, 150))
forgeSquishy("CyberMint", Color3.fromRGB(0, 255, 150))
forgeSquishy("GoldenAura", Color3.fromRGB(255, 200, 0))

-- 2. Player Inventory Architecture
Players.PlayerAdded:Connect(function(player)
    local inventory = Instance.new("Folder")
    inventory.Name = "SquishyInventory"
    inventory.Parent = player
    
    -- Grant the starter asset
    local starterAsset = Instance.new("StringValue")
    starterAsset.Name = "NeonBerry"
    starterAsset.Value = "Owned"
    starterAsset.Parent = inventory
end)
