local Players = game:GetService("Players")

local function onPlayerJoin(player)
    -- This prints to the Output window in Roblox Studio
    print("Welcome to Chanel's Infinite Funland, " .. player.Name .. "!")
    
    -- Listen for when their physical 3D character actually spawns into the world
    player.CharacterAdded:Connect(function(character)
        print(player.Name .. "'s avatar has landed in the world.")
    end)
end

-- Connect our custom function to the engine's built-in PlayerAdded event
Players.PlayerAdded:Connect(onPlayerJoin)