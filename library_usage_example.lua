--[[
    Example usage of AccioLib
    To use this from GitHub, you would typically use:
    local AccioLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/repo/main/library.lua"))()
]]

-- 1. Load your library from GitHub
local LibRaw = "https://raw.githubusercontent.com/MoonOFCC/RobloxGUI_First_Library/refs/heads/main/library_main.lua"
local AccioLib = loadstring(game:HttpGet(LibRaw))()

-- 2. Create the Window
local window = AccioLib:CreateWindow("Moon Hub")

-- 3. Create a Tab
local farmTab = window:CreateTab("Autofarm")

-- 4. Add interactive components
farmTab:CreateToggle("Auto Farming", false, function(state)
    print("Auto farm is now:", state)
    _G.autoFarm = state
end)

farmTab:CreateButton("Kill Roblox", function()
    game:Shutdown() -- Just an example!
end)

-- 5. Add another Tab
local infoTab = window:CreateTab("Credits")
infoTab:CreateButton("Made by MoonOFCC", function()
    print("Visit the GitHub repo for more info!")
end)
