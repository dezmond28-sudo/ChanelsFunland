local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Main Screen Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UnifiedHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. Top-Center Navigation Bar Container
local navBar = Instance.new("Frame")
navBar.Size = UDim2.new(0, 520, 0, 50)
navBar.Position = UDim2.new(0.5, -260, 0.02, 0)
navBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
navBar.BackgroundTransparency = 0.2
navBar.BorderSizePixel = 0
navBar.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = navBar

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 10)
layout.Parent = navBar

-- Helper function to style clean unified buttons
local function createNavButton(name, color, targetGuiName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 155, 0, 38)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = navBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local targetGui = playerGui:FindFirstChild(targetGuiName)
        if targetGui then
            -- Find the inner frame and toggle visibility
            for _, child in ipairs(targetGui:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = not child.Visible
                    -- If opening inventory, trigger refresh if available
                    if child.Name == "InventoryUI" and child.Visible then
                        -- Refresh handled by internal logic
                    end
                end
            end
        end
    end)
end

-- Generate Clean Docked Buttons
createNavButton("Inventory", Color3.fromRGB(150, 0, 255), "InventoryUI")
createNavButton("Trading Hub", Color3.fromRGB(255, 0, 150), "SquishyTradingHub")
createNavButton("Shop & Utility", Color3.fromRGB(0, 200, 255), "CosmeticShopHub")
