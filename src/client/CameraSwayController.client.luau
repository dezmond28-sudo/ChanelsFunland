local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local swayIntensity = 0.03
local bobbingSpeed = 12
local bobbingAmount = 0.05

local lastCameraCFrame = camera.CFrame

RunService.RenderStepped:Connect(function(dt)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end
    
    -- Calculate mouse delta rotation for weapon/camera sway
    local currentCameraCFrame = camera.CFrame
    local delta = currentCameraCFrame:ToObjectSpace(lastCameraCFrame)
    lastCameraCFrame = currentCameraCFrame
    
    -- Apply subtle bobbing when moving
    local velocityMagnitude = hrp.AssemblyLinearVelocity.Magnitude
    if velocityMagnitude > 2 and humanoid.FloorMaterial ~= Enum.Material.Air then
        local timeTick = tick() * bobbingSpeed
        local bobX = math.cos(timeTick) * bobbingAmount
        local bobY = math.sin(timeTick * 2) * bobbingAmount
        
        camera.CFrame = camera.CFrame * CFrame.new(bobX, bobY, 0)
    end
end)

print("[System] Professional Camera Sway & Movement Controller Active.")
