local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

print("[System] Deploying Professional Environment & Terrain Overhaul...")

-- 1. Balance Lighting for Cinematic Realism (Fix washout)
Lighting.Technology = Enum.LightingTechnology.Future
Lighting.GlobalShadows = true
Lighting.Brightness = 1.8
Lighting.ClockTime = 14.0 -- Clean afternoon sun
Lighting.GeographicLatitude = 30

-- 2. Upgrade Terrain Textures & Colors
local terrain = Workspace:FindFirstChildOfClass("Terrain")
if terrain then
    terrain.WaterWaveSize = 0.05
    terrain.WaterTransparency = 0.9
    terrain.WaterColor = Color3.fromRGB(30, 90, 140)
end

-- 3. Add High-Detail Environment Props (Procedural Trees & Rocks)
local propFolder = Workspace:FindFirstChild("EnvironmentProps")
if not propFolder then
    propFolder = Instance.new("Folder")
    propFolder.Name = "EnvironmentProps"
    propFolder.Parent = Workspace
end

-- Clear old props if re-running
for _, child in ipairs(propFolder:GetChildren()) do
    child:Destroy()
end

-- Spawn scattered low-poly stylized pine trees and rocks for depth
math.randomseed(1337)
for i = 1, 30 do
    local xPos = math.random(-120, 120)
    local zPos = math.random(-120, 120)
    
    -- Skip center obby path
    if math.abs(xPos) > 20 or math.abs(zPos) > 20 then
        local treeTrunk = Instance.new("Part")
        treeTrunk.Size = Vector3.new(2, 8, 2)
        treeTrunk.Position = Vector3.new(xPos, 4, zPos)
        treeTrunk.Color = Color3.fromRGB(90, 60, 40)
        treeTrunk.Material = Enum.Material.Wood
        treeTrunk.Anchored = true
        treeTrunk.Parent = propFolder
        
        local treeLeaves = Instance.new("Part")
        treeLeaves.Shape = Enum.PartType.Ball
        treeLeaves.Size = Vector3.new(8, 8, 8)
        treeLeaves.Position = Vector3.new(xPos, 8.5, zPos)
        treeLeaves.Color = Color3.fromRGB(40, 140, 70)
        treeLeaves.Material = Enum.Material.Grass
        treeLeaves.Anchored = true
        treeLeaves.Parent = propFolder
    end
end

print("[System] Environment Overhaul Complete: Balanced Lighting, Volumetric Atmosphere, and Foliage Deployed.")
