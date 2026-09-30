local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local rewardEvent = ReplicatedStorage:WaitForChild("ClaimDailyEvent", 5)
if not rewardEvent then return end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DailyRewardUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local modal = Instance.new("Frame")
modal.Size = UDim2.new(0.35, 0, 0.4, 0)
modal.Position = UDim2.new(0.325, 0, 0.3, 0)
modal.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
modal.Visible = false
modal.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.25, 0)
title.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Text = "DAILY LOGIN REWARD"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.Parent = modal

local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(0.9, 0, 0.3, 0)
desc.Position = UDim2.new(0.05, 0, 0.3, 0)
desc.BackgroundTransparency = 1
desc.TextColor3 = Color3.fromRGB(255, 255, 255)
desc.Text = "Claim your daily stipend:\n+500 Coins & GoldenAura Squishy!"
desc.Font = Enum.Font.GothamBold
desc.TextSize = 16
desc.Parent = modal

local claimBtn = Instance.new("TextButton")
claimBtn.Size = UDim2.new(0.8, 0, 0.2, 0)
claimBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
claimBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
claimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
claimBtn.Text = "CLAIM REWARD"
claimBtn.Font = Enum.Font.GothamBlack
claimBtn.TextScaled = true
claimBtn.Parent = modal

claimBtn.MouseButton1Click:Connect(function()
    rewardEvent:FireServer("Claim")
    claimBtn.Text = "CLAIMED!"
    claimBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    task.wait(2)
    modal.Visible = false
end)

rewardEvent.OnClientEvent:Connect(function(statusType, canClaim)
    if statusType == "CheckStatus" and canClaim then
        modal.Visible = true
    elseif statusType == "ClaimSuccess" then
        modal.Visible = false
    end
end)
