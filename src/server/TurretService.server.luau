local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TURRET_COST = 150
local RANGE = 40

-- 1. Forge Turret Template in ReplicatedStorage
local turretVault = ReplicatedStorage:FindFirstChild("TurretVault")
if not turretVault then
    turretVault = Instance.new("Folder")
    turretVault.Name = "TurretVault"
    turretVault.Parent = ReplicatedStorage
    
    local turretBase = Instance.new("Part")
    turretBase.Name = "AutoTurret"
    turretBase.Size = Vector3.new(2, 3, 2)
    turretBase.Position = Vector3.new(50, 11, 0) -- Placed in the Survival Arena
    turretBase.Anchored = true
    turretBase.Material = Enum.Material.Metal
    turretBase.Color = Color3.fromRGB(100, 100, 110)
    turretBase.Parent = turretVault
    
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Deploy Turret (150 Coins)"
    prompt.ObjectText = "Defense Sentry"
    prompt.HoldDuration = 1
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.Parent = turretBase
end

local template = turretVault:FindFirstChild("AutoTurret")

-- 2. Deployment Logic & Autonomous Targeting Loop
if template then
    local prompt = template:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        prompt.Triggered:Connect(function(player)
            local leaderstats = player:FindFirstChild("leaderstats")
            local coins = leaderstats and leaderstats:FindFirstChild("Coins")
            
            if coins and coins.Value >= TURRET_COST then
                coins.Value -= TURRET_COST
                
                -- Spawn deployed turret at player's current position
                local character = player.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local deployed = template:Clone()
                    deployed.Position = hrp.Position + (hrp.CFrame.LookVector * 4)
                    deployed.Parent = Workspace.SurvivalArena
                    
                    -- Remove prompt on active clone
                    local p = deployed:FindFirstChildOfClass("ProximityPrompt")
                    if p then p:Destroy() end
                    
                    -- Autonomous Targeting Daemon
                    task.spawn(function()
                        while deployed and deployed.Parent do
                            local arena = Workspace:FindFirstChild("SurvivalArena")
                            local targetZombie = nil
                            local shortestDist = RANGE
                            
                            if arena then
                                for _, obj in ipairs(arena:GetChildren()) do
                                    if obj.Name == "SurvivalZombie" then
                                        local torso = obj.PrimaryPart or obj:FindFirstChild("Torso")
                                        if torso then
                                            local dist = (torso.Position - deployed.Position).Magnitude
                                            if dist < shortestDist then
                                                shortestDist = dist
                                                targetZombie = torso
                                            end
                                        end
                                    end
                                end
                            end
                            
                            -- Fire Projectile if Target Acquired
                            if targetZombie then
                                deployed.CFrame = CFrame.new(deployed.Position, targetZombie.Position)
                                
                                local bullet = Instance.new("Part")
                                bullet.Size = Vector3.new(0.3, 0.3, 1.5)
                                bullet.Color = Color3.fromRGB(0, 255, 255)
                                bullet.Material = Enum.Material.Neon
                                bullet.Anchored = false
                                bullet.CanCollide = false
                                bullet.CFrame = deployed.CFrame
                                bullet.Velocity = (targetZombie.Position - deployed.Position).Unit * 250
                                bullet.Parent = Workspace
                                
                                bullet.Touched:Connect(function(hit)
                                    local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
                                    if hum and hit.Parent.Name == "SurvivalZombie" then
                                        hum:TakeDamage(25)
                                        bullet:Destroy()
                                    end
                                end)
                                
                                task.delay(2, function()
                                    if bullet and bullet.Parent then bullet:Destroy() end
                                end)
                            end
                            
                            task.wait(1) -- Firing cadence (1 shot per second)
                        end
                    end)
                end
                print("[System] Defense Sentry deployed by " .. player.Name)
            else
                print("[System] Insufficient funds to deploy turret.")
            end
        end)
    end
end
