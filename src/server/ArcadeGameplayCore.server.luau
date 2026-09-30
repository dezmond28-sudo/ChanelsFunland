local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("[Arcade Core] Initializing High-Velocity Gameplay Mechanics...")

-- 1. Create Combat & Movement Remotes
local dashEvent = ReplicatedStorage:FindFirstChild("PlayerDashEvent")
if not dashEvent then
    dashEvent = Instance.new("RemoteEvent")
    dashEvent.Name = "PlayerDashEvent"
    dashEvent.Parent = ReplicatedStorage
end

-- 2. Handle High-Speed Dash Physics on Server
dashEvent.OnServerEvent:Connect(function(player)
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local forwardVector = hrp.CFrame.LookVector
        hrp.Velocity = (forwardVector * 120) + Vector3.new(0, 50, 0)
        print("[Arcade Core] Dash Executed: " .. player.Name)
    end
end)

-- 3. Dynamic Hazard Spawner (Moving Laser Beams & Rotating Obstacles)
local function spawnHazardGrid()
    local hazardFolder = Workspace:FindFirstChild("ActiveHazards")
    if not hazardFolder then
        hazardFolder = Instance.new("Folder")
        hazardFolder.Name = "ActiveHazards"
        hazardFolder.Parent = Workspace
    end
    
    -- Spawn rotating danger blades in the arena
    for i = 1, 3 do
        local hazard = Instance.new("Part")
        hazard.Name = "DangerBlade"
        hazard.Size = Vector3.new(12, 1, 3)
        hazard.Position = Vector3.new(math.random(-30, 30), 2, math.random(-30, 30))
        hazard.Color = Color3.fromRGB(255, 0, 50)
        hazard.Material = Enum.Material.Neon
        hazard.Anchored = true
        hazard.CanCollide = true
        hazard.Parent = hazardFolder
        
        -- Continuous rotation loop via task.spawn
        task.spawn(function()
            while hazard and hazard.Parent do
                hazard.CFrame = hazard.CFrame * CFrame.Angles(0, 0.05, 0)
                task.wait(0.03)
            end
        end)
    end
end

spawnHazardGrid()
print("[Arcade Core] Dynamic Hazards & High-Speed Movement Operational.")
