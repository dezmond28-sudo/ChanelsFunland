local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Create Screen Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TelemetryHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. Telemetry Glassmorphism Panel (Top-Left)
local hudPanel = Instance.new("Frame")
hudPanel.Size = UDim2.new(0, 220, 0, 110)
hudPanel.Position = UDim2.new(0.02, 0, 0.02, 0)
hudPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
hudPanel.BackgroundTransparency = 0.3
hudPanel.BorderSizePixel = 0
hudPanel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = hudPanel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 255)
stroke.Transparency = 0.5
stroke.Thickness = 1.5
stroke.Parent = hudPanel

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 6)
layout.Parent = hudPanel

-- Helper function to create telemetry stat rows
local function createStatRow(labelName, initialValue)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.9, 0, 0, 26)
    row.BackgroundTransparency = 1
    row.Parent = hudPanel
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    titleLabel.Text = labelName
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = row
    
    local valLabel = Instance.new("TextLabel")
    valLabel.Name = "Value"
    valLabel.Size = UDim2.new(0.5, 0, 1, 0)
    valLabel.Position = UDim2.new(0.5, 0, 0, 0)
    valLabel.BackgroundTransparency = 1
    valLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    valLabel.Text = tostring(initialValue)
    valLabel.Font = Enum.Font.GothamBlack
    valLabel.TextSize = 14
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = row
    
    return valLabel
end

local coinValLabel = createStatRow("COINS", 0)
local stageValLabel = createStatRow("STAGE", 1)
local waveValLabel = createStatRow("WAVE", 1)

-- 3. Live Leaderstats Binding Loop
task.spawn(function()
    local leaderstats = player:WaitForChild("leaderstats", 10)
    if leaderstats then
        local coins = leaderstats:WaitForChild("Coins", 5)
        local stage = leaderstats:WaitForChild("Stage", 5)
        
        if coins then
            coins.Changed:Connect(function(val)
                coinValLabel.Text = tostring(val)
            end)
            coinValLabel.Text = tostring(coins.Value)
        end
        
        if stage then
            stage.Changed:Connect(function(val)
                stageValLabel.Text = tostring(val)
            end)
            stageValLabel.Text = tostring(stage.Value)
        end
    end
end)

print("[System] Telemetry HUD Panel Initialized.")
