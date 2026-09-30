local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Bind 'Q' or 'Shift' for high-speed dash
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.LeftShift then
        local dashEvent = ReplicatedStorage:FindFirstChild("PlayerDashEvent")
        if dashEvent then
            dashEvent:FireServer()
        end
    end
end)
