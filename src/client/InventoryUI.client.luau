local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InventoryUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainBoard = Instance.new("Frame")
mainBoard.Size = UDim2.new(0.4, 0, 0.6, 0)
mainBoard.Position = UDim2.new(0.3, 0, 0.2, 0)
mainBoard.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainBoard.Visible = false
mainBoard.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
title.TextColor3 = Color3.fromRGB(150, 0, 255)
title.Text = "YOUR SQUISHY VAULT"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.Parent = mainBoard

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.9, 0, 0.75, 0)
scrollFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
scrollFrame.Parent = mainBoard

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)

local function refreshInventory()
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    local inventory = player:FindFirstChild("SquishyInventory")
    if not inventory then return end
    
    local count = 0
    for _, asset in ipairs(inventory:GetChildren()) do
        count += 1
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, 0, 0, 50)
        itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        itemFrame.LayoutOrder = count
        itemFrame.Parent = scrollFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0.05, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = asset.Name
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = itemFrame
        
        local equipBtn = Instance.new("TextButton")
        equipBtn.Size = UDim2.new(0.3, 0, 0.8, 0)
        equipBtn.Position = UDim2.new(0.65, 0, 0.1, 0)
        equipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        equipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        equipBtn.Text = "EQUIP"
        equipBtn.Font = Enum.Font.GothamBlack
        equipBtn.TextScaled = true
        equipBtn.Parent = itemFrame
        
        local assetName = asset.Name
        equipBtn.MouseButton1Click:Connect(function()
            local event = ReplicatedStorage:WaitForChild("EquipAssetEvent", 5)
            if event then
                event:FireServer(assetName)
                equipBtn.Text = "EQUIPPED"
                task.wait(1)
                equipBtn.Text = "EQUIP"
            end
        end)
    end
end

-- Expose global visibility listener for the top navigation bar
mainBoard:GetPropertyChangedSignal("Visible"):Connect(function()
    if mainBoard.Visible then
        refreshInventory()
    end
end)
