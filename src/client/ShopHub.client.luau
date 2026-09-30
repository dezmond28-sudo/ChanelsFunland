local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CosmeticShopHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainBoard = Instance.new("Frame")
mainBoard.Size = UDim2.new(0.4, 0, 0.8, 0)
mainBoard.Position = UDim2.new(0.3, 0, 0.1, 0)
mainBoard.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainBoard.Visible = false
mainBoard.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.12, 0)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Text = "SHOP & UTILITY"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.Parent = mainBoard

local layout = Instance.new("UIListLayout")
layout.Parent = mainBoard
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)

title.LayoutOrder = 1

local function createShopItem(order, name, displayName, price, btnColor)
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(0.9, 0, 0.18, 0)
    itemFrame.BackgroundTransparency = 1
    itemFrame.LayoutOrder = order
    itemFrame.Parent = mainBoard

    local itemNameLabel = Instance.new("TextLabel")
    itemNameLabel.Size = UDim2.new(0.6, 0, 1, 0)
    itemNameLabel.Position = UDim2.new(0.05, 0, 0, 0)
    itemNameLabel.BackgroundTransparency = 1
    itemNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemNameLabel.Text = displayName .. " (" .. price .. " Coins)"
    itemNameLabel.Font = Enum.Font.GothamBold
    itemNameLabel.TextSize = 18
    itemNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    itemNameLabel.Parent = itemFrame

    local buyBtn = Instance.new("TextButton")
    buyBtn.Size = UDim2.new(0.35, 0, 0.8, 0)
    buyBtn.Position = UDim2.new(0.6, 0, 0.1, 0)
    buyBtn.BackgroundColor3 = btnColor
    buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyBtn.Text = "PURCHASE"
    buyBtn.Font = Enum.Font.GothamBlack
    buyBtn.TextScaled = true
    buyBtn.Parent = itemFrame

    buyBtn.MouseButton1Click:Connect(function()
        local shopEvent = ReplicatedStorage:WaitForChild("ExecutePurchase", 5)
        if shopEvent then
            shopEvent:FireServer(name)
            buyBtn.Text = "BOUGHT"
            task.wait(1.5)
            buyBtn.Text = "PURCHASE"
        end
    end)
end

createShopItem(2, "NeonAura", "Cyan Aura", 200, Color3.fromRGB(0, 200, 100))
createShopItem(3, "NeonTrail", "Pink Trail", 350, Color3.fromRGB(255, 0, 150))
createShopItem(4, "HealthPack", "Health Pack (+50 HP)", 75, Color3.fromRGB(255, 50, 50))
