local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local ObbyConfig = {
    Stages = 20,
    PlatformSize = Vector3.new(8, 1, 8),
    StartPos = Vector3.new(0, 10, 0),
    GapDistance = 12,
    HeightIncrease = 3,
    KillBlockChance = 0.3,
    MovingPlatformChance = 0.25, -- 25% chance a safe platform will oscillate
}

local function attachHazardLogic(platform)
    platform.Touched:Connect(function(hit)
        local character = hit.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            humanoid.Health = 0
        end
    end)
end

local function attachMovingLogic(platform)
    task.spawn(function()
        local originalPos = platform.Position
        local speed = math.random(2, 4) -- Randomized oscillation frequency
        local distance = math.random(6, 12) -- Travel distance in studs
        
        while platform and platform.Parent do
            local timeElapsed = os.clock() * speed
            local offset = math.sin(timeElapsed) * distance
            
            -- Smoothly shift the platform along the X-axis while preserving Y and Z geometry
            platform.CFrame = CFrame.new(originalPos + Vector3.new(offset, 0, 0))
            RunService.Stepped:Wait()
        end
    end)
end

local function generateObby()
    print("[System] Initializing Advanced Procedural Obby (Kinematic Oscillations Enabled)...")
    
    -- Purge old generation if reloading
    local existing = Workspace:FindFirstChild("ProceduralObby")
    if existing then existing:Destroy() end

    local obbyFolder = Instance.new("Folder")
    obbyFolder.Name = "ProceduralObby"
    obbyFolder.Parent = Workspace

    for i = 1, ObbyConfig.Stages do
        local platform = Instance.new("Part")
        platform.Name = "Stage_" .. i
        platform.Size = ObbyConfig.PlatformSize
        platform.Anchored = true
        
        local zOffset = (i - 1) * ObbyConfig.GapDistance
        local yOffset = (i - 1) * ObbyConfig.HeightIncrease
        platform.Position = ObbyConfig.StartPos + Vector3.new(0, yOffset, zOffset)
        
        -- Hazard vs Safe vs Moving Logic Matrix
        if i > 1 and math.random() <= ObbyConfig.KillBlockChance then
            platform.Material = Enum.Material.Neon
            platform.Color = Color3.fromRGB(255, 0, 50) -- Danger Red
            attachHazardLogic(platform)
        else
            platform.Material = Enum.Material.Neon
            platform.Color = Color3.fromRGB(0, 255, 255) -- Safe Cyan
            
            -- Check for moving platform mutation (Stage 1 is always static)
            if i > 2 and math.random() <= ObbyConfig.MovingPlatformChance then
                platform.Color = Color3.fromRGB(255, 165, 0) -- Dynamic Orange Indicator
                attachMovingLogic(platform)
            end
        end
        
        platform.Parent = obbyFolder
    end
    print("[System] Advanced Obby Generation Complete. " .. ObbyConfig.Stages .. " stages compiled.")
end

generateObby()
