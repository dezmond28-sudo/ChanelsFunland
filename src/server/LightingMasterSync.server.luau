local Lighting = game:GetService("Lighting")

print("[System] Synchronizing Master Lighting Profile...")

-- Purge all conflicting lighting children to ensure 100% consistency between Edit and Play modes
for _, child in ipairs(Lighting:GetChildren()) do
    child:Destroy()
end

-- 1. Establish Clean, Professional Fortnite-Style Atmosphere
Lighting.Technology = Enum.LightingTechnology.Future
Lighting.GlobalShadows = true
Lighting.Brightness = 2.0
Lighting.ClockTime = 14.5 -- Crisp, bright afternoon sun with balanced shadows
Lighting.GeographicLatitude = 25

local atmosphere = Instance.new("Atmosphere")
atmosphere.Density = 0.25
atmosphere.Offset = 0.25
atmosphere.Color = Color3.fromRGB(200, 220, 250)
atmosphere.Decay = Color3.fromRGB(50, 60, 90)
atmosphere.Glare = 0.4
atmosphere.Haze = 1.2
atmosphere.Parent = Lighting

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Brightness = 0.02
colorCorrection.Contrast = 0.15
colorCorrection.Saturation = 0.4 -- Vibrant, clean colors without artificial blue tinting
colorCorrection.TintColor = Color3.fromRGB(255, 252, 248)
colorCorrection.Parent = Lighting

print("[System] Lighting Master Sync Complete: Viewport and Play mode are now fully unified.")
