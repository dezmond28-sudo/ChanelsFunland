local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Purge legacy standalone UI layers that duplicate the top nav bar
local legacyGuis = {"InventoryUI", "SquishyTradingHub", "CosmeticShopHub"}
for _, guiName in ipairs(legacyGuis) do
    local gui = playerGui:FindFirstChild(guiName)
    if gui then
        -- Instead of destroying the entire GUI (which breaks their internal frames),
        -- locate the toggle buttons inside them and make them invisible.
        for _, child in ipairs(gui:GetChildren()) do
            if child:IsA("TextButton") and (child.Text:find("Inventory") or child.Text:find("Trade") or child.Text:find("Shop")) then
                child:Destroy()
            end
        end
    end
end

print("[System] Legacy bottom UI buttons purged. Viewport cleaned.")
