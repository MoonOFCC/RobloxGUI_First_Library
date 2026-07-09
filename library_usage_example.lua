--[[
    Example usage of AccioLib
    To use this from GitHub, you would typically use:
    local AccioLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/repo/main/library.lua"))()
]]

-- For local testing purposes, we assume AccioLib is already loaded or required
local AccioLib = loadfile("library.lua")()

-- Create the main window
local window = AccioLib:CreateWindow("My Script Hub")

-- Create a dynamic category (Tab)
local farmTab = window:CreateTab("Autofarm")

-- Add a toggle
farmTab:CreateToggle("Auto Lemonz", false, function(state)
    print("Auto Farm is now:", state)
    _G.farming = state
end)

-- Add a button
farmTab:CreateButton("Reset Character", function()
    print("Resetting character...")
    game.Players.LocalPlayer.Character:BreakJoints()
end)

-- Create another category
local miscTab = window:CreateTab("Misc")

miscTab:CreateButton("Print Hello", function()
    print("Hello from AccioLib!")
end)

miscTab:CreateToggle("Anti-AFK", true, function(state)
    print("Anti-AFK set to:", state)
end)

print("GUI Loaded Successfully!")
