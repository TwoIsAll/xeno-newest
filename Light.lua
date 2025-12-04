-- Light.lua
-- Toggle full brightness (disable darkness) with M key

local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Store original lighting values
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient
local originalOutdoorAmbient = Lighting.OutdoorAmbient
local originalGlobalShadows = Lighting.GlobalShadows

local isFullBright = false

-- Function to toggle full brightness
local function toggleFullBright()
    isFullBright = not isFullBright
    
    if isFullBright then
        -- Save original values
        originalBrightness = Lighting.Brightness
        originalAmbient = Lighting.Ambient
        originalOutdoorAmbient = Lighting.OutdoorAmbient
        originalGlobalShadows = Lighting.GlobalShadows
        
        -- Set full bright values
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 14 -- Set to daylight
    else
        -- Restore original values
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalOutdoorAmbient
        Lighting.GlobalShadows = originalGlobalShadows
    end
end

-- Connect M key to toggle full bright
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        toggleFullBright()
    end
end)

-- Clean up when script is destroyed
local function onDestroy()
    -- Restore original lighting when script is destroyed
    if isFullBright then
        toggleFullBright()
    end
end

-- Return cleanup function
return onDestroy
