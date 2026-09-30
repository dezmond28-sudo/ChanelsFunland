local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. Establish Local AI Network Bridge
local aiEvent = ReplicatedStorage:FindFirstChild("QueryLocalAI")
if not aiEvent then
    aiEvent = Instance.new("RemoteEvent")
    aiEvent.Name = "QueryLocalAI"
    aiEvent.Parent = ReplicatedStorage
end

-- 2. Endpoint Configuration for Local Inference (Ollama / MLX Local Daemon)
local LOCAL_AI_URL = "http://127.0.0.1:11434/api/generate"

aiEvent.OnServerEvent:Connect(function(player, promptText)
    if not promptText or promptText == "" then return end
    
    task.spawn(function()
        local requestData = {
            model = "deepseek-r1:latest", -- Or local model loaded on Apple Silicon
            prompt = "You are the Sovereign AI Director of Chanel's Infinite Funland. Respond briefly and tactically to the player: " .. promptText,
            stream = false
        }
        
        local success, response = pcall(function()
            return HttpService:PostAsync(LOCAL_AI_URL, HttpService:JSONEncode(requestData), Enum.HttpContentType.ApplicationJson)
        end)
        
        if success then
            local decoded = HttpService:JSONDecode(response)
            local aiResponse = decoded.response or "System nominal."
            
            -- Broadcast AI response back to the player's client UI
            aiEvent:FireClient(player, "AIResponse", aiResponse)
            print("[Local AI Bridge] Response generated for " .. player.Name .. ": " .. aiResponse)
        else
            warn("[Local AI Bridge] Local inference offline. Ensure Ollama/MLX daemon is running on localhost.")
            aiEvent:FireClient(player, "AIResponse", "Neural link offline. Operating on autonomous backup matrix.")
        end
    end)
end)

print("[System] Cutting-Edge Local AI Inference Bridge Initialized.")
