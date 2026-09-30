local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

print("[System] Deploying Cinematic Visual Overhaul...")

-- 1. Purge boring default lighting properties
for _, child in ipairs(Lighting:GetChildren()) do
    child:Destroy()
end

-- 2. Next-Gen Atmosphere & Sky Stacking
Lighting.Technology = Enum.LightingTechnology.Future
Lighting.GlobalShadows = true
Lighting.Brightness = 3.2
Lighting.ClockTime = 17.5 -- Dramatic sunset golden hour with long shadows
Lighting.GeographicLatitude = 15

local atmosphere = Instance.new("Atmosphere")
atmosphere.Density = 0.35
atmosphere.Offset = 0.5
atmosphere.Color = Color3.fromRGB(120, 150, 220)
atmosphere.Decay = Color3.fromRGB(40, 30, 70)
atmosphere.Glare = 0.6
atmosphere.Haze = 2.0
atmosphere.Parent = Lighting

local sunRays = Instance.new("SunRaysEffect")
sunRays.Intensity = 0.25
sunRays.Spread = 0.8
sunRays.Parent = Lighting

local bloom = Instance.new("BloomEffect")
bloom.Intensity = 0.8
bloom.Size = 32
bloom.Threshold = 0.9
bloom.Parent = Lighting

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Brightness = 0.05
colorCorrection.Contrast = 0.3 -- High contrast for punchy, non-boring visuals
colorCorrection.Saturation = 0.5 -- Deep, vivid color grading
colorCorrection.TintColor = Color3.fromRGB(255, 240, 220)
colorCorrection.Parent = Lighting

-- 3. Dynamic Particle FX Generator for the Arena & Spawn
local function spawnAmbientParticles(parentPart)
    if not parentPart:FindFirstChild("CinematicDust") then
        local particles = Instance.new("ParticleEmitter")
        particles.Name = "CinematicDust"
        particles.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 150))
        particles.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
        particles.Texture = "rbxassetid://243660364"
        particles.Rate = 25
        particles.Speed = NumberRange.new(1, 3)
        particles.Lifetime = NumberRange.new(4, 7)
        particles.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)})
        particles.Parent = parentPart
    end
end

-- Apply to spawn or primary workspace parts
for _, part in ipairs(Workspace:GetChildren()) do
    if part:IsA("Part") and part.Anchored then
        spawnAmbientParticles(part)
    end
end

print("[System] Cinematic Visual Overhaul Engaged: High-Contrast Golden Hour & Volumetric Effects Active.")
