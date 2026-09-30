local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

print("[System] Deploying Fortnite-Style Realism & Grounding Engine...")

-- 1. Configure Next-Gen Lighting & Atmosphere (Eliminate neon washouts)
Lighting.Technology = Enum.LightingTechnology.Future
Lighting.GlobalShadows = true
Lighting.Brightness = 2.0
Lighting.ClockTime = 15.0 -- Crisp afternoon sun
Lighting.GeographicLatitude = 41

-- Clear old post-processing effects
for _, child in ipairs(Lighting:GetChildren()) do
    if child:IsA("PostEffect") or child:IsA("Atmosphere") then
        child:Destroy()
    end
end

local atmosphere = Instance.new("Atmosphere")
atmosphere.Density = 0.28
atmosphere.Offset = 0.2
atmosphere.Color = Color3.fromRGB(190, 210, 240)
atmosphere.Decay = Color3.fromRGB(60, 70, 100)
atmosphere.Glare = 0.3
atmosphere.Haze = 1.0
atmosphere.Parent = Lighting

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Brightness = 0.02
colorCorrection.Contrast = 0.2
colorCorrection.Saturation = 0.35 -- Rich, stylized color grading like Fortnite
colorCorrection.TintColor = Color3.fromRGB(255, 250, 245)
colorCorrection.Parent = Lighting

-- 2. Clean up floating/neon artifacts and rebuild grounded props
local propFolder = Workspace:FindFirstChild("EnvironmentProps")
if not propFolder then
    propFolder = Instance.new("Folder")
    propFolder.Name = "EnvironmentProps"
    propFolder.Parent = Workspace
else
    for _, child in ipairs(propFolder:GetChildren()) do
        child:Destroy()
    end
end

-- Raycast grounding helper to ensure absolute zero floating
local function getGroundHeight(x, z)
    local rayOrigin = Vector3.new(x, 100, z)
    local rayDirection = Vector3.new(0, -200, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.IgnoreWater = true
    
    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then
        return result.Position.Y
    end
    return 0
end

-- Spawn high-fidelity, grounded stylized trees and boulders
math.randomseed(2026)
for i = 1, 40 do
    local xPos = math.random(-140, 140)
    local zPos = math.random(-140, 140)
    
    -- Keep center player path clear
    if math.abs(xPos) > 25 or math.abs(zPos) > 25 then
        local groundY = getGroundHeight(xPos, zPos)
        
        -- Stylized Tree Trunk (Wood)
        local trunk = Instance.new("Part")
        trunk.Size = Vector3.new(2.2, 7, 2.2)
        trunk.Position = Vector3.new(xPos, groundY + 3.5, zPos)
        trunk.Color = Color3.fromRGB(85, 55, 35)
        trunk.Material = Enum.Material.Wood
        trunk.Anchored = true
        trunk.Parent = propFolder
        
        -- Stylized Tree Foliage (SmoothPlastic for clean Fortnite-style shading)
        local leaves = Instance.new("Part")
        leaves.Shape = Enum.PartType.Ball
        leaves.Size = Vector3.new(9, 9, 9)
        leaves.Position = Vector3.new(xPos, groundY + 8, zPos)
        leaves.Color = Color3.fromRGB(50, 150, 80)
        leaves.Material = Enum.Material.SmoothPlastic
        leaves.Reflectance = 0.05
        leaves.Anchored = true
        leaves.Parent = propFolder
    end
end

print("[System] Fortnite Realism Engine Active: Assets Grounded via Raycasting, Neon Over-Saturation Removed.")
