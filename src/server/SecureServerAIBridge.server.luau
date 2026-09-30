local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Ensure RemoteEvent exists in ReplicatedStorage
local aiEvent = ReplicatedStorage:FindFirstChild("QueryLocalAI")
if not aiEvent then
    aiEvent = Instance.new("RemoteEvent")
    aiEvent.Name = "QueryLocalAI"
    aiEvent.Parent = ReplicatedStorage
end

local LOCAL_AI_URL = "http://127.0.0.1:11434/api/generate"

-- Handle requests securely on the server
aiEvent.OnServerEvent:Connect(function(player, promptText)
    if not promptText or promptText == "" then return end
    
    local success, response = pcall(function()
        local requestData = {
            model = "deepseek-r1:latest",
            prompt = "You are the Sovereign AI Director of Chanel's Infinite Funland. Respond briefly: " .. promptText,
            stream = false
        }
        return HttpService:PostAsync(LOCAL_AI_URL, HttpService:JSONEncode(requestData), Enum.HttpContentType.ApplicationJson)
    end)
    
    if success then
        local decoded = HttpService:JSONDecode(response)
        local aiResponse = decoded.response or "System nominal."
        aiEvent:FireClient(player, aiResponse)
    else
        aiEvent:FireClient(player, "Neural link offline. Operating on backup matrix.")
    end
end)

print("[System] Secure Server-Side AI Bridge Initialized.")
