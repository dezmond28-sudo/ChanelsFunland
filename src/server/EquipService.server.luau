local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. Establish the Network Bridge
local equipEvent = ReplicatedStorage:FindFirstChild("EquipAssetEvent")
if not equipEvent then
    equipEvent = Instance.new("RemoteEvent")
    equipEvent.Name = "EquipAssetEvent"
    equipEvent.Parent = ReplicatedStorage
end

-- Server-side validation and equipping logic
equipEvent.OnServerEvent:Connect(function(player, targetName)
    if type(targetName) ~= "string" or targetName == "" then return end
    
    local inventory = player:FindFirstChild("SquishyInventory")
    if not inventory or not inventory:FindFirstChild(targetName) then
        print("[System] Equip Failed: " .. player.Name .. " does not own [" .. targetName .. "]")
        return
    end
    
    local vault = ReplicatedStorage:FindFirstChild("SquishyVault")
    local template = vault and vault:FindFirstChild(targetName)
    local character = player.Character
    
    if template and character then
        local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
        if not hand then return end
        
        -- Purge currently held asset
        local existing = character:FindFirstChild("EquippedSquishy")
        if existing then existing:Destroy() end
        
        local clone = template:Clone()
        clone.Name = "EquippedSquishy"
        clone.Anchored = false
        clone.CanCollide = false
        clone.Massless = true
        clone.CFrame = hand.CFrame * CFrame.new(0, -1, 0)
        clone.Parent = character
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = hand
        weld.Part1 = clone
        weld.Parent = clone
        
        print("[System] " .. player.Name .. " visually equipped [" .. targetName .. "]")
    end
end)
