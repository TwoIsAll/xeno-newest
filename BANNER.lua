-- Place this in a LocalScript in StarterPlayerScripts
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

-- Message chunks
local messageChunks = {
    "I am here to check for Hacker/Exploiters who are using an Unofficial Version of the Roblox Client.",
    "I'm currently detecting and listing all executors, Lua scripts, and exploits being used.",
    "This includes monitoring for any scamming attempts in the server.",
    "To prevent joining the same server repeatedly, I'm blocking two people per server.",
    "Statistics show that blocking two people per server is the most effective method to avoid rejoining the same server.",
    "Most common scam attempt: 'Join me to steal a Brainrot for a Free [VALUABLE ITEM]' - Don't fall for it!",
    "🔍👀 I WILL ALSO OBSERVE THE CHAT AND PLAYER MOVEMENT TO DETERMINE MY FINAL ANSWER. ⚠️",
    "My apologies if I have spammed the messages. I will learn from this!",
	"Reported users.",
	"Blocked Users."
}

-- Create the main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MessageChunkerGui"
screenGui.ResetOnSpawn = false

-- Create the main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 400)  -- Increased height for clear button
frame.Position = UDim2.new(0.8, 0, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add corner radius
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

-- Add title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "📢 Anti-Exploit Messages"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- Create a scrolling frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -100)  -- Adjusted for clear button
scrollFrame.Position = UDim2.new(0, 5, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
scrollFrame.Parent = frame

-- Create UIListLayout for the buttons
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = scrollFrame

-- Function to send a message
local function sendMessage(message)
    -- Try new chat system first
    local success = pcall(function()
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(message)
    end)
    
    -- Fallback to legacy chat
    if not success then
        local chatService = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chatService then
            local sayMessage = chatService:FindFirstChild("SayMessageRequest")
            if sayMessage then
                sayMessage:FireServer(message, "All")
            end
        end
    end
end

-- Create message buttons
for i, message in ipairs(messageChunks) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.95, 0, 0, 40)
    button.Position = UDim2.new(0.025, 0, 0, (i-1) * 45)
    button.BackgroundColor3 = i == 7 and Color3.fromRGB(80, 30, 30) or Color3.fromRGB(45, 45, 45)
    button.Text = "Chunk " .. i .. (i == 7 and " ⚠️" or " ➔")
    button.TextColor3 = i == 7 and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = scrollFrame
    
    -- Add message preview
    local preview = Instance.new("TextLabel")
    preview.Size = UDim2.new(1, -10, 1, -10)
    preview.Position = UDim2.new(0, 5, 0, 5)
    preview.BackgroundTransparency = 1
    preview.Text = string.sub(message, 1, 30) .. (string.len(message) > 30 and "..." or "")
    preview.TextColor3 = i == 7 and Color3.fromRGB(255, 180, 180) or Color3.fromRGB(200, 200, 200)
    preview.Font = Enum.Font.Gotham
    preview.TextSize = 10
    preview.TextXAlignment = Enum.TextXAlignment.Left
    preview.TextYAlignment = Enum.TextYAlignment.Bottom
    preview.Parent = button
    
    -- Add button hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = i == 7 and Color3.fromRGB(100, 40, 40) or Color3.fromRGB(60, 60, 60)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = i == 7 and Color3.fromRGB(80, 30, 30) or Color3.fromRGB(45, 45, 45)
        }):Play()
    end)
    
    -- Send message when clicked
    button.MouseButton1Click:Connect(function()
        sendMessage(message)
    end)
end

-- Create clear button
local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0.6, 0, 0, 40)
clearButton.Position = UDim2.new(0.2, 0, 1, -50)
clearButton.AnchorPoint = Vector2.new(0, 1)
clearButton.BackgroundColor3 = Color3.fromRGB(30, 120, 30)  -- Green color
clearButton.Text = "CLEAR"
clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clearButton.Font = Enum.Font.GothamBold
clearButton.TextSize = 14
clearButton.Parent = frame

-- Add corner radius to clear button
local clearButtonCorner = Instance.new("UICorner")
clearButtonCorner.CornerRadius = UDim.new(0, 6)
clearButtonCorner.Parent = clearButton

-- Clear button hover effect
clearButton.MouseEnter:Connect(function()
    TweenService:Create(clearButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 160, 40)
    }):Play()
end)

clearButton.MouseLeave:Connect(function()
    TweenService:Create(clearButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(30, 120, 30)
    }):Play()
end)

-- Clear button click handler
clearButton.MouseButton1Click:Connect(function()
    -- Send the clear message to chat
    sendMessage("CLEAR NOTHING FOUND WRONG.")
    
    -- Close the GUI
    screenGui:Destroy()
    
    -- Leave the game after a short delay
    task.delay(0.5, function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end)
end)

-- Update canvas size based on content
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- Make the frame draggable
local UserInputService = game:GetService("UserInputService")
local dragging
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == UserInputService:GetMouseLocation() and dragging then
        update(input)
    end
end)

-- Add the GUI to the player's screen
screenGui.Parent = PlayerGui