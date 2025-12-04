-- LocalScript to save ALL chat to a .txt file
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Generate unique filename with timestamp
local function generateFilename()
    local timestamp = os.date("%Y-%m-%d_%H-%M-%S")
    return "chat_log_" .. timestamp .. ".txt"
end

-- Function to write to file
local function writeToFile(filename, content)
    if writefile then
        writefile(filename, content)
        print("Chat saved to: " .. filename)
        return true
    else
        -- Alternative method for some executors
        local success, result = pcall(function()
            return appendfile(filename, content)
        end)
        if success then
            print("Chat saved to: " .. filename)
            return true
        else
            print("Error: writefile function not available")
            return false
        end
    end
end

-- Function to dump channel history to string
local function getChannelHistory(channel)
    local historyText = ""
    
    if channel and channel:IsA("TextChannel") then
        historyText = historyText .. "=== CHANNEL: " .. channel.Name .. " ===\n"
        
        local success, messages = pcall(function()
            return channel:GetMessageHistory(500) -- Get up to 500 messages
        end)
        
        if success and messages and #messages > 0 then
            for i, message in ipairs(messages) do
                if message.TextSource then
                    local speaker = message.TextSource.DisplayName or "Unknown"
                    local text = message.Text or ""
                    local timestamp = os.date("%Y-%m-%d %H:%M:%S", message.Timestamp / 1000)
                    
                    historyText = historyText .. string.format("[%s] %s: %s\n", timestamp, speaker, text)
                end
            end
        else
            historyText = historyText .. "No messages in this channel\n"
        end
        historyText = historyText .. "\n"
    end
    
    return historyText
end

-- Main function to save all chat
local function saveAllChatToFile()
    local filename = generateFilename()
    local allChatText = ""
    
    allChatText = allChatText .. "ROBLOX CHAT LOG\n"
    allChatText = allChatText .. "Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
    allChatText = allChatText .. "Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "\n"
    allChatText = allChatText .. "Place ID: " .. game.PlaceId .. "\n"
    allChatText = allChatText .. "=" .. string.rep("=", 50) .. "\n\n"
    
    -- Wait for chat to load
    wait(2)
    
    -- Get all existing channels
    local channelNames = {"RBXGeneral", "RBXSystem", "RBXTeam", "RBXWhisper", "System", "General"}
    
    for _, channelName in pairs(channelNames) do
        local channel = TextChatService:FindFirstChild(channelName)
        if channel then
            allChatText = allChatText .. getChannelHistory(channel)
        end
    end
    
    -- Also search for any other text channels
    for _, item in pairs(TextChatService:GetChildren()) do
        if item:IsA("TextChannel") then
            local alreadyProcessed = false
            for _, knownName in pairs(channelNames) do
                if item.Name == knownName then
                    alreadyProcessed = true
                    break
                end
            end
            
            if not alreadyProcessed then
                allChatText = allChatText .. getChannelHistory(item)
            end
        end
    end
    
    -- Save to file
    if writeToFile(filename, allChatText) then
        return filename
    else
        return nil
    end
end

-- Execute and save
print("Starting chat export...")
local savedFile = saveAllChatToFile()

if savedFile then
    print("✅ Chat successfully saved to: " .. savedFile)
    
    -- Try to read back to verify
    if readfile then
        local content = readfile(savedFile)
        local lineCount = select(2, string.gsub(content, "\n", ""))
        print("📊 Lines saved: " .. lineCount)
    end
else
    print("❌ Failed to save chat to file")
end