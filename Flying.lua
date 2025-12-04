--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Character setup
local function SetupCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    return character, humanoid, rootPart
end

local character, humanoid, rootPart = SetupCharacter()

-- Variables
local ClipOn = false
local Flying = false
local FlySpeed = 50

local BodyVelocity
local BodyGyro

-- GUI Elements
local Noclip = Instance.new("ScreenGui")
local BG = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local NoclipButton = Instance.new("TextButton")
local FlyButton = Instance.new("TextButton")
local SpeedSliderLabel = Instance.new("TextLabel")
local SpeedTextBox = Instance.new("TextBox")  -- TextBox for fly speed input
local StatusLabel = Instance.new("TextLabel")  -- Combined Status label
local Credit = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")

-- GUI Setup
Noclip.Name = "Noclip"
Noclip.Parent = CoreGui

BG.Name = "BG"
BG.Parent = Noclip
BG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BG.BorderColor3 = Color3.fromRGB(30, 30, 30)
BG.Position = UDim2.new(0.5, -200, 0.5, -150)
BG.Size = UDim2.new(0, 400, 0, 300)
BG.Active = true
BG.Draggable = true

Title.Name = "Title"
Title.Parent = BG
Title.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Title.BorderColor3 = Color3.fromRGB(0, 180, 180)
Title.Size = UDim2.new(0, 400, 0, 50)
Title.Font = Enum.Font.GothamBold
Title.Text = "Noclip & Fly"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 30

NoclipButton.Parent = BG
NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
NoclipButton.BorderColor3 = Color3.fromRGB(0, 180, 180)
NoclipButton.Size = UDim2.new(0, 380, 0, 50)
NoclipButton.Position = UDim2.new(0.5, -190, 0.2, 0)
NoclipButton.Text = "Toggle Noclip"
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.TextSize = 20

FlyButton.Parent = BG
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
FlyButton.BorderColor3 = Color3.fromRGB(0, 180, 180)
FlyButton.Size = UDim2.new(0, 380, 0, 50)
FlyButton.Position = UDim2.new(0.5, -190, 0.4, 0)
FlyButton.Text = "Toggle Fly"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 20

SpeedSliderLabel.Parent = BG
SpeedSliderLabel.Position = UDim2.new(0.5, -150, 0.6, 0)
SpeedSliderLabel.Size = UDim2.new(0, 120, 0, 30)
SpeedSliderLabel.Text = "Fly Speed"
SpeedSliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSliderLabel.TextSize = 18

SpeedTextBox.Parent = BG
SpeedTextBox.Position = UDim2.new(0.5, -190, 0.7, 0)
SpeedTextBox.Size = UDim2.new(0, 380, 0, 30)
SpeedTextBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
SpeedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTextBox.TextSize = 18
SpeedTextBox.Text = tostring(FlySpeed)

-- Combined Status label
StatusLabel.Parent = BG
StatusLabel.Position = UDim2.new(0.5, -60, 0.85, 0)
StatusLabel.Size = UDim2.new(0, 180, 0, 30)
StatusLabel.Text = "Status: Off"
StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
StatusLabel.TextSize = 18

Credit.Parent = BG
Credit.Position = UDim2.new(0.5, -75, 0.93, 0)
Credit.Size = UDim2.new(0, 150, 0, 20)
Credit.Text = "Created by LilVamp1X"
Credit.TextColor3 = Color3.fromRGB(255, 255, 255)
Credit.TextSize = 12

CloseButton.Parent = BG
CloseButton.Position = UDim2.new(0.9, -15, 0.02, 0)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.MouseButton1Click:Connect(function()
    Noclip:Destroy()
end)

-- Noclip Functionality
local function ToggleNoclip(enabled)
    ClipOn = enabled
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
    UpdateStatusLabel()
end

-- Update status label to reflect current state
local function UpdateStatusLabel()
    local statusText = "Status: " .. (ClipOn and "Noclip On" or "Noclip Off")
    StatusLabel.Text = statusText
    StatusLabel.TextColor3 = ClipOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end

NoclipButton.MouseButton1Click:Connect(function()
    ToggleNoclip(not ClipOn)
end)

-- Fly Functionality
local function StartFlying()
    Flying = true
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity.Parent = rootPart

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    BodyGyro.P = 40000
    BodyGyro.Parent = rootPart
end

local function StopFlying()
    Flying = false
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
end

FlyButton.MouseButton1Click:Connect(function()
    if Flying then
        StopFlying()
        StatusLabel.Text = "Status: Fly Off"
    else
        StartFlying()
        StatusLabel.Text = "Status: Fly On"
    end
end)

-- Speed TextBox FocusLost Handler
SpeedTextBox.FocusLost:Connect(function()
    local speedInput = tonumber(SpeedTextBox.Text)
    if speedInput then
        FlySpeed = math.clamp(speedInput, 1, 1000)  -- Range from 1 to 1000
        SpeedTextBox.Text = tostring(FlySpeed)  -- Update TextBox to reflect new FlySpeed
    else
        SpeedTextBox.Text = tostring(FlySpeed)  -- Reset to current FlySpeed if input is invalid
    end
end)

-- Keep Noclip active while flying
RunService.Heartbeat:Connect(function()
    if Flying then
        local camera = Workspace.CurrentCamera
        local moveVector = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if moveVector.Magnitude > 0 then
            BodyVelocity.Velocity = moveVector.Unit * FlySpeed
        else
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        BodyGyro.CFrame = camera.CFrame
    end

    -- Keep Noclip active while flying
    if ClipOn then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)