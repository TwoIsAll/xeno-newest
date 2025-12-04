-- PlayerTeleportGUI.lua
-- Draggable, resizable GUI showing player names, coordinates, and teleport buttons

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Create main frame
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerTeleportGUI"
ScreenGui.ResetOnSpawn = false

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200) -- Center of screen
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Player Teleporter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.SourceSansBold

-- Resize handle
local ResizeHandle = Instance.new("Frame")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ResizeHandle.BorderSizePixel = 0

local ResizeIcon = Instance.new("ImageLabel")
ResizeIcon.Name = "ResizeIcon"
ResizeIcon.Size = UDim2.new(1, 0, 1, 0)
ResizeIcon.BackgroundTransparency = 1
ResizeIcon.Image = "rbxassetid://6031302932" -- Diagonal resize icon
ResizeIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)

-- Scroll frame for player list
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollFrame.ScrollBarImageTransparency = 0.5
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

-- List layout
local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 5)

-- Function to create player entry
local function createPlayerEntry(player)
    local entry = Instance.new("Frame")
    entry.Name = player.Name
    entry.Size = UDim2.new(1, 0, 0, 30)
    entry.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    entry.BorderSizePixel = 0
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(0.5, -5, 1, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextSize = 14
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    
    local coordsLabel = Instance.new("TextLabel")
    coordsLabel.Name = "CoordsLabel"
    coordsLabel.Size = UDim2.new(0.3, -5, 1, 0)
    coordsLabel.Position = UDim2.new(0.7, 0, 0, 0)
    coordsLabel.BackgroundTransparency = 1
    coordsLabel.Text = "0, 0, 0"
    coordsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    coordsLabel.TextXAlignment = Enum.TextXAlignment.Right
    coordsLabel.Font = Enum.Font.SourceSans
    coordsLabel.TextSize = 12
    
    local teleportButton = Instance.new("TextButton")
    teleportButton.Name = "TeleportButton"
    teleportButton.Size = UDim2.new(0.15, -5, 0.7, 0)
    teleportButton.Position = UDim2.new(0.5, 0, 0.15, 0)
    teleportButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225) -- Royal Blue
    teleportButton.BorderSizePixel = 0
    teleportButton.Text = "TP"
    teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportButton.TextSize = 12
    teleportButton.Font = Enum.Font.SourceSansBold
    
    -- Teleport functionality
    teleportButton.MouseButton1Click:Connect(function()
        local character = localPlayer.Character
        local targetCharacter = player.Character
        if character and targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
            local targetCFrame = targetCharacter.HumanoidRootPart.CFrame
            character:MoveTo(targetCFrame.Position + Vector3.new(0, 3, 0)) -- Slightly above to prevent getting stuck
        end
    end)
    
    -- Hover effects
    teleportButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(teleportButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 149, 237)}):Play()
    end)
    
    teleportButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(teleportButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 105, 225)}):Play()
    end)
    
    nameLabel.Parent = entry
    coordsLabel.Parent = entry
    teleportButton.Parent = entry
    
    return entry
end

-- Update player positions
local function updatePlayerPositions()
    for _, player in ipairs(Players:GetPlayers()) do
        local entry = ScrollFrame:FindFirstChild(player.Name)
        if entry then
            local coordsLabel = entry:FindFirstChild("CoordsLabel")
            if coordsLabel and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos = player.Character.HumanoidRootPart.Position
                coordsLabel.Text = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            elseif coordsLabel then
                coordsLabel.Text = "N/A"
            end
        end
    end
end

-- Update player list
local function updatePlayerList()
    -- Clear existing entries
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add current players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local entry = createPlayerEntry(player)
            entry.Parent = ScrollFrame
        end
    end
    
    -- Update canvas size
    local listHeight = 0
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            listHeight = listHeight + child.Size.Y.Offset + 5
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, listHeight)
end

-- Dragging functionality
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    MainFrame.Position = newPosition
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Resize functionality
local resizing = false
local initialSize
local initialInput

local function updateSize(input)
    local delta = input.Position - initialInput.Position
    local newSize = UDim2.new(
        initialSize.X.Scale, 
        math.clamp(initialSize.X.Offset + delta.X, 200, 500), -- Min width: 200, Max width: 500
        initialSize.Y.Scale, 
        math.clamp(initialSize.Y.Offset + delta.Y, 200, 600)  -- Min height: 200, Max height: 600
    )
    MainFrame.Size = newSize
end

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        initialSize = MainFrame.Size
        initialInput = input
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
            end
        end)
    end
end)

ResizeHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        initialInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == initialInput and resizing then
        updateSize(input)
    end
end)

-- Close button
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Set up the GUI hierarchy
ResizeIcon.Parent = ResizeHandle
ResizeHandle.Parent = MainFrame
Title.Parent = TitleBar
CloseButton.Parent = TitleBar
TitleBar.Parent = MainFrame
ListLayout.Parent = ScrollFrame
ScrollFrame.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- Initialize player list
updatePlayerList()

-- Set up player added/removed events
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Update positions periodically
game:GetService("RunService").Heartbeat:Connect(updatePlayerPositions)

-- Add toggle key (T for Teleport)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.T then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Parent to PlayerGui
ScreenGui.Parent = playerGui

return ScreenGui