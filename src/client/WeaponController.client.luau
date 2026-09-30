local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local canFire = true
local fireCooldown = 0.25 -- 4 shots per second rate limit

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if humanoid and humanoid.Health > 0 and character:FindFirstChild("NeonBlaster") then
            if canFire then
                canFire = false
                local event = ReplicatedStorage:FindFirstChild("FireBlasterEvent")
                if event then
                    event:FireServer(mouse.Hit.Position)
                end
                task.wait(fireCooldown)
                canFire = true
            end
        end
    end
end)
