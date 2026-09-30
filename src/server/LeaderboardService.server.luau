local DataStoreService = game:GetService("DataStoreService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local StageLeaderboard = DataStoreService:GetOrderedDataStore("StageRanking_v1")
local WaveLeaderboard = DataStoreService:GetOrderedDataStore("WaveRanking_v1")

-- 1. Construct Physical Leaderboard Part in World
local boardFolder = Workspace:FindFirstChild("Leaderboards")
if not boardFolder then
    boardFolder = Instance.new("Folder")
    boardFolder.Name = "Leaderboards"
    boardFolder.Parent = Workspace
    
    local boardPart = Instance.new("Part")
    boardPart.Name = "GlobalBoard"
    boardPart.Size = Vector3.new(12, 8, 1)
    boardPart.Position = Vector3.new(0, 15, -15) -- Placed near spawn/safe hub
    boardPart.Anchored = true
    boardPart.Material = Enum.Material.SmoothPlastic
    boardPart.Color = Color3.fromRGB(20, 20, 25)
    boardPart.Parent = boardFolder
    
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Name = "DisplayGui"
    surfaceGui.Face = Enum.NormalId.Front
    surfaceGui.Parent = boardPart
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "ScoreDisplay"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = "Loading Global Leaderboards..."
    textLabel.Parent = surfaceGui
end

-- 2. Periodic Data Sync Loop
task.spawn(function()
    while true do
        -- Save scores for all active players
        for _, player in ipairs(Players:GetPlayers()) do
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                local stage = leaderstats:FindFirstChild("Stage")
                if stage then
                    pcall(function()
                        StageLeaderboard:SetAsync(tostring(player.UserId), stage.Value)
                    end)
                end
            end
        end
        
        -- Fetch Top 5 Stages
        local success, pages = pcall(function()
            return StageLeaderboard:GetSortedAsync(false, 5)
        end)
        
        if success and pages then
            local data = pages:GetCurrentPage()
            local displayText = "--- GLOBAL OBBY LEADERBOARD ---\n"
            
            for rank, entry in ipairs(data) do
                local userId = tonumber(entry.key)
                local successName, name = pcall(function()
                    return Players:GetNameFromUserIdAsync(userId)
                end)
                local username = successName and name or ("User " .. entry.key)
                displayText ..= rank .. ". " .. username .. " - Stage " .. entry.value .. "\n"
            end
            
            local board = Workspace:FindFirstChild("Leaderboards") and Workspace.Leaderboards:FindFirstChild("GlobalBoard")
            local display = board and board:FindFirstChild("DisplayGui") and board.DisplayGui:FindFirstChild("ScoreDisplay")
            if display then
                display.Text = displayText
            end
        end
        
        task.wait(10) -- Refresh every 10 seconds
    end
end)
