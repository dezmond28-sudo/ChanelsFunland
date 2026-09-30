local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local shopEvent = ReplicatedStorage:FindFirstChild("ExecutePurchase")
if not shopEvent then
    shopEvent = Instance.new("RemoteEvent")
    shopEvent.Name = "ExecutePurchase"
    shopEvent.Parent = ReplicatedStorage
end

local shopVault = ReplicatedStorage:FindFirstChild("ShopVault")
if not shopVault then
    shopVault = Instance.new("Folder")
    shopVault.Name = "ShopVault"
    shopVault.Parent = ReplicatedStorage
end

-- 1. Asset Geometries
if not shopVault:FindFirstChild("NeonAura") then
    local neonAura = Instance.new("ParticleEmitter")
    neonAura.Name = "NeonAura"
    neonAura.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
    neonAura.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
    neonAura.Texture = "rbxassetid://243660364"
    neonAura.Rate = 40
    neonAura.Speed = NumberRange.new(2, 4)
    neonAura.Parent = shopVault
end

if not shopVault:FindFirstChild("NeonTrail") then
    local neonTrail = Instance.new("Trail")
    neonTrail.Name = "NeonTrail"
    neonTrail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 150))
    neonTrail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
    neonTrail.Lifetime = 0.4
    neonTrail.Parent = shopVault
end

local PRICES = { ["NeonAura"] = 200, ["NeonTrail"] = 350, ["HealthPack"] = 75 }

shopEvent.OnServerEvent:Connect(function(player, itemName)
    local cost = PRICES[itemName]
    if not cost then return end

    local leaderstats = player:FindFirstChild("leaderstats")
    local coins = leaderstats and leaderstats:FindFirstChild("Coins")
    
    if coins and coins.Value >= cost then
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if hrp and humanoid then
            if itemName == "HealthPack" then
                coins.Value -= cost
                humanoid.Health = math.min(humanoid.MaxHealth, humanoid.Health + 50)
                print("[System] Health Restored: " .. player.Name .. " purchased a HealthPack.")
                return
            end
            
            if character:FindFirstChild(itemName) or hrp:FindFirstChild(itemName) then
                print("[System] Purchase Voided: " .. player.Name .. " already has " .. itemName)
                return
            end
            
            coins.Value -= cost
            
            if itemName == "NeonTrail" then
                local att0 = Instance.new("Attachment")
                att0.Name = "TrailAtt0"
                att0.Position = Vector3.new(0, 1, 0)
                att0.Parent = hrp
                
                local att1 = Instance.new("Attachment")
                att1.Name = "TrailAtt1"
                att1.Position = Vector3.new(0, -1.5, 0)
                att1.Parent = hrp
                
                local trailClone = shopVault[itemName]:Clone()
                trailClone.Attachment0 = att0
                trailClone.Attachment1 = att1
                trailClone.Parent = character
            else
                local fxClone = shopVault[itemName]:Clone()
                fxClone.Parent = hrp
            end
            print("[System] Shop Transaction: " .. player.Name .. " purchased [" .. itemName .. "]")
        end
    end
end)
