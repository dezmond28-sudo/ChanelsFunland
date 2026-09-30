local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

print("[AI Director] Initializing Adaptive Threat Engine...")

-- 1. AI Director Core Loop
task.spawn(function()
    while true do
        task.wait(15) -- Evaluate combat telemetry every 15 seconds
        
        local arena = Workspace:FindFirstChild("SurvivalArena")
        if not arena then continue end
        
        -- Gather Player Power Metrics
        local activePlayers = 0
        local totalFirepower = 0
        
        for _, player in ipairs(Players:GetPlayers()) do
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                activePlayers += 1
                -- Check if player is wielding advanced gear (NeonBlaster, Auras)
                if character:FindFirstChild("NeonBlaster") or player:FindFirstChild("SquishyInventory") then
                    totalFirepower += 2
                else
                    totalFirepower += 1
                end
            end
        end
        
        if activePlayers == 0 then continue end
        
        -- Dynamic Director Adjustments based on Telemetry
        local mutationTier = math.ceil(totalFirepower / activePlayers)
        
        for _, obj in ipairs(arena:GetChildren()) do
            if obj.Name == "SurvivalZombie" then
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                local torso = obj.PrimaryPart or obj:FindFirstChild("Torso")
                
                if humanoid and torso then
                    if mutationTier >= 2 and humanoid.MaxHealth == 50 then
                        -- Mutate Zombie into Elite Alpha variant
                        humanoid.MaxHealth = 120
                        humanoid.Health = 120
                        humanoid.WalkSpeed = 18 -- Faster pursuit
                        torso.BrickColor = BrickColor.new("Bright red")
                        torso.Size = Vector3.new(2.5, 3.5, 1.5)
                        print("[AI Director] Threat Escalation: Upgraded Zombie to Elite Alpha Variant.")
                    end
                end
            end
        end
    end
end)
