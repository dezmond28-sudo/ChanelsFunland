local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- 1. Establish Secure Network Bridge
local blasterEvent = ReplicatedStorage:FindFirstChild("FireBlasterEvent")
if not blasterEvent then
    blasterEvent = Instance.new("RemoteEvent")
    blasterEvent.Name = "FireBlasterEvent"
    blasterEvent.Parent = ReplicatedStorage
end

-- 2. Forge Production Weapon Template in ReplicatedStorage
local weaponVault = ReplicatedStorage:FindFirstChild("WeaponVault")
if not weaponVault then
    weaponVault = Instance.new("Folder")
    weaponVault.Name = "WeaponVault"
    weaponVault.Parent = ReplicatedStorage
end

local tool = weaponVault:FindFirstChild("NeonBlaster")
if not tool then
    tool = Instance.new("Tool")
    tool.Name = "NeonBlaster"
    tool.RequiresHandle = true
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 3)
    handle.Color = Color3.fromRGB(0, 255, 255)
    handle.Material = Enum.Material.Neon
    handle.Parent = tool
    
    tool.Parent = weaponVault
end

-- Grant weapon automatically on spawn
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        local backpack = player:FindFirstChild("Backpack")
        if backpack and weaponVault:FindFirstChild("NeonBlaster") then
            if not backpack:FindFirstChild("NeonBlaster") and not character:FindFirstChild("NeonBlaster") then
                local clone = weaponVault.NeonBlaster:Clone()
                clone.Parent = backpack
            end
        end
    end)
end)

-- 3. Robust Ballistics & Damage Server Engine
blasterEvent.OnServerEvent:Connect(function(player, targetPosition)
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Rate limit or validation check can go here
    local spawnPos = hrp.Position + (hrp.CFrame.LookVector * 3) + Vector3.new(0, 1, 0)
    local direction = (targetPosition - spawnPos).Unit
    
    local bullet = Instance.new("Part")
    bullet.Name = "BlasterProjectile"
    bullet.Size = Vector3.new(0.4, 0.4, 2)
    bullet.Color = Color3.fromRGB(255, 0, 150)
    bullet.Material = Enum.Material.Neon
    bullet.Anchored = false
    bullet.CanCollide = false
    bullet.CFrame = CFrame.new(spawnPos, targetPosition)
    bullet.Velocity = direction * 350
    bullet.Parent = Workspace
    
    -- Clean Hit Registration
    bullet.Touched:Connect(function(hit)
        if hit.Parent ~= character and hit.Name ~= "Handle" and hit.Name ~= "BlasterProjectile" then
            local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:TakeDamage(35) -- 35 Damage per shot
            end
            bullet:Destroy()
        end
    end)
    
    -- Auto-cleanup safety timer
    task.delay(3, function()
        if bullet and bullet.Parent then
            bullet:Destroy()
        end
    end)
end)
