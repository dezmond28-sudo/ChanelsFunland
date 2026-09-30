local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SquishyTradingHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainBoard = Instance.new("Frame")
mainBoard.Size = UDim2.new(0.6, 0, 0.6, 0)
mainBoard.Position = UDim2.new(0.2, 0, 0.15, 0)
mainBoard.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainBoard.Visible = false
mainBoard.Parent = screenGui

local p1Zone = Instance.new("Frame")
p1Zone.Size = UDim2.new(0.45, 0, 0.6, 0)
p1Zone.Position = UDim2.new(0.025, 0, 0.2, 0)
p1Zone.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
p1Zone.Parent = mainBoard

local assetInput = Instance.new("TextBox")
assetInput.Size = UDim2.new(0.8, 0, 0.2, 0)
assetInput.Position = UDim2.new(0.1, 0, 0.4, 0)
assetInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
assetInput.TextColor3 = Color3.fromRGB(0, 0, 0)
assetInput.PlaceholderText = "Squishy Name (e.g. NeonBerry)"
assetInput.Font = Enum.Font.GothamBold
assetInput.TextScaled = true
assetInput.Parent = p1Zone

local p2Zone = Instance.new("Frame")
p2Zone.Size = UDim2.new(0.45, 0, 0.6, 0)
p2Zone.Position = UDim2.new(0.525, 0, 0.2, 0)
p2Zone.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
p2Zone.Parent = mainBoard

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(0.8, 0, 0.2, 0)
targetInput.Position = UDim2.new(0.1, 0, 0.4, 0)
targetInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
targetInput.TextColor3 = Color3.fromRGB(0, 0, 0)
targetInput.PlaceholderText = "Target Player Name"
targetInput.Font = Enum.Font.GothamBold
targetInput.TextScaled = true
targetInput.Parent = p2Zone

local acceptBtn = Instance.new("TextButton")
acceptBtn.Size = UDim2.new(0.4, 0, 0.12, 0)
acceptBtn.Position = UDim2.new(0.3, 0, 0.85, 0)
acceptBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
acceptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
acceptBtn.Text = "EXECUTE TRADE"
acceptBtn.Font = Enum.Font.GothamBlack
acceptBtn.TextScaled = true
acceptBtn.Parent = mainBoard

acceptBtn.MouseButton1Click:Connect(function()
    local target = targetInput.Text
    local squishyName = assetInput.Text
    
    if target ~= "" and squishyName ~= "" then
        local tradeEvent = ReplicatedStorage:WaitForChild("ExecuteTrade", 5)
        if tradeEvent then
            tradeEvent:FireServer(target, squishyName)
            acceptBtn.Text = "TRANSACTION SENT"
            task.wait(1.5)
            acceptBtn.Text = "EXECUTE TRADE"
        end
    else
        acceptBtn.Text = "INVALID INPUT"
        acceptBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
        task.wait(1.5)
        acceptBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        acceptBtn.Text = "EXECUTE TRADE"
    end
end)
