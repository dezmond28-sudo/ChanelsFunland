local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local tradeEvent = ReplicatedStorage:FindFirstChild("ExecuteTrade")
if not tradeEvent then
    tradeEvent = Instance.new("RemoteEvent")
    tradeEvent.Name = "ExecuteTrade"
    tradeEvent.Parent = ReplicatedStorage
end

-- Server-Side Asset Validation & Execution
tradeEvent.OnServerEvent:Connect(function(sender, targetName, squishyName)
    if type(squishyName) ~= "string" or squishyName == "" then return end
    
    -- Verify Sender actually owns the asset
    local senderInventory = sender:FindFirstChild("SquishyInventory")
    if not senderInventory then return end
    
    local targetAsset = senderInventory:FindFirstChild(squishyName)
    if not targetAsset then
        print("[System] Trade Failed: " .. sender.Name .. " does not own asset [" .. squishyName .. "]")
        return
    end

    -- Verify Target Player exists
    local targetPlayer = Players:FindFirstChild(targetName)
    if targetPlayer and targetPlayer ~= sender then
        local targetInventory = targetPlayer:FindFirstChild("SquishyInventory")
        if targetInventory then
            -- Execute the Atomic Transaction: Move the asset tag to the new owner
            targetAsset.Parent = targetInventory
            print("[System] Trade Executed: " .. sender.Name .. " transferred [" .. squishyName .. "] to " .. targetPlayer.Name)
        end
    else
        print("[System] Trade Failed: Target player '" .. tostring(targetName) .. "' not found.")
    end
end)
