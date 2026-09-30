local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local function onPlayerAdded(player)
    -- 1. Construct the Leaderstats Data Structure
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local stage = Instance.new("IntValue")
    stage.Name = "Stage"
    stage.Value = 1
    stage.Parent = leaderstats

    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 500 -- Starting economic baseline
    coins.Parent = leaderstats

    -- 2. Intercept Avatar Spawning
    player.CharacterAdded:Connect(function(character)
        task.wait(0.1)
        
        local currentStage = stage.Value
        local obbyFolder = Workspace:WaitForChild("ProceduralObby", 5)
        
        if obbyFolder then
            local targetPlatform = obbyFolder:FindFirstChild("Stage_" .. currentStage)
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            
            if targetPlatform and hrp then
                hrp.CFrame = targetPlatform.CFrame + Vector3.new(0, 3, 0)
            end
        end
        
        -- 3. Dynamic Checkpoint Detection & Economic Reward
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Touched:Connect(function(hit)
                if hit.Parent == obbyFolder and hit.Name:match("Stage_") then
                    local hitStageNum = tonumber(hit.Name:match("%d+"))
                    if hitStageNum and hitStageNum > stage.Value and hit.Color == Color3.fromRGB(0, 255, 255) then
                        stage.Value = hitStageNum
                        -- Inject capital upon progression
                        coins.Value += 50
                    end
                end
            end)
        end
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
