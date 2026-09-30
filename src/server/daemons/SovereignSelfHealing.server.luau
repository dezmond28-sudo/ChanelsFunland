local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

print("[Sovereign Daemon] Initializing Self-Healing & Memory Optimization Engine...")

-- Background Autonomous Garbage Collection & Physics Optimization
task.spawn(function()
    while true do
        task.wait(30) -- Run hygiene audit every 30 seconds
        
        local purgedCount = 0
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            -- Purge stray, unanchored parts that fell out of bounds
            if descendant:IsA("Part") and not descendant.Anchored and descendant.Position.Y < -50 then
                descendant:Destroy()
                purgedCount += 1
            end
        end
        
        if purgedCount > 0 then
            print("[Sovereign Daemon] Self-Healing Protocol: Purged " .. purgedCount .. " out-of-bounds legacy artifacts.")
        end
    end
end)

print("[Sovereign Daemon] Autonomous Self-Healing Pipeline Active.")
