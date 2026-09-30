local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- 1. Infinite Mutation Profiles
local THEMES = {
    {Name = "Neon Cyberpunk", Color = Color3.fromRGB(0, 255, 255), Material = Enum.Material.Neon, Gravity = 196.2},
    {Name = "Zero-G Void", Color = Color3.fromRGB(150, 0, 255), Material = Enum.Material.Glass, Gravity = 60.0},
    {Name = "Magma Forge", Color = Color3.fromRGB(255, 50, 0), Material = Enum.Material.Slate, Gravity = 220.0},
    {Name = "Quantum Crystal", Color = Color3.fromRGB(0, 255, 100), Material = Enum.Material.Ice, Gravity = 150.0}
}

-- 2. Stage Mutation Daemon
Players.PlayerAdded:Connect(function(player)
    local leaderstats = player:WaitForChild("leaderstats", 5)
    local stage = leaderstats and leaderstats:WaitForChild("Stage", 5)
    
    if stage then
        stage.GetPropertyChangedSignal("Stage"):Connect(function()
            local currentStage = stage.Value
            if currentStage > 0 and currentStage % 50 == 0 then
                local themeIndex = math.floor(currentStage / 50) % #THEMES + 1
                local selectedTheme = THEMES[themeIndex]
                
                -- Mutate Environment Physics
                Workspace.Gravity = selectedTheme.Gravity
                
                -- Broadcast mutation event
                print("[Infinite Engine] SEED MUTATION TRIGGERED at Stage " .. currentStage)
                print("[Infinite Engine] Active Theme: " .. selectedTheme.Name .. " | Gravity: " .. selectedTheme.Gravity)
                
                -- Mutate active obby environment in Workspace
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name:find("StagePart") or obj.Name:find("Platform") then
                        obj.Color = selectedTheme.Color
                        obj.Material = selectedTheme.Material
                    end
                end
            end
        end)
    end
end)

print("[System] Infinite Procedural Seed Mutation Daemon Active.")
