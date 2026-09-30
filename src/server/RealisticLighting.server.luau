local Lighting = game:GetService("Lighting")

-- 1. Configure Engine Rendering Tier to Future (High-End Real-Time Shadows & Reflections)
Lighting.Technology = Enum.LightingTechnology.Future
Lighting.GlobalShadows = true
Lighting.Brightness = 2.5
Lighting.ClockTime = 14.5 -- Golden hour afternoon sunlight
Lighting.GeographicLatitude = 45

-- 2. Purge default effects if existing
for _, child in ipairs(Lighting:GetChildren()) do
    child:Destroy()
end

-- 3. Inject Next-Gen Post-Processing FX (Fortnite-Style Stylized Realism)
local atmosphere = Instance.new("Atmosphere")
atmosphere.Density = 0.3
atmosphere.Offset = 0.25
atmosphere.Color = Color3.fromRGB(180, 200, 240)
atmosphere.Decay = Color3.fromRGB(50, 60, 90)
atmosphere.Glare = 0.4
atmosphere.Haze = 1.5
atmosphere.Parent = Lighting

local bloom = Instance.new("BloomEffect")
bloom.Intensity = 0.4
bloom.Size = 24
bloom.Threshold = 1.2
bloom.Parent = Lighting

local depthOfField = Instance.new("DepthOfFieldEffect")
depthOfField.FarIntensity = 0.1
depthOfField.FocusDistance = 50
depthOfField.InFocusRadius = 30
depthOfField.NearIntensity = 0.05
depthOfField.Parent = Lighting

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Brightness = 0.05
colorCorrection.Contrast = 0.15
colorCorrection.Saturation = 0.2 -- Vibrant stylized coloring
colorCorrection.TintColor = Color3.fromRGB(255, 245, 235)
colorCorrection.Parent = Lighting

print("[System] Realistic Lighting Pipeline Activated: Future Technology & Post-Processing Stack Engaged.")
