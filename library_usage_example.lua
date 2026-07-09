--[[
    Made For Version: Premium v11
    Updated: 10th july of 2026
]]

local LibRaw = "https://raw.githubusercontent.com/MoonOFCC/RobloxGUI_First_Library/refs/heads/main/library_main.lua"
local AccioLib = loadstring(game:HttpGet(LibRaw))()

local window = AccioLib:CreateWindow("Moon Hub | Premium v11")

local mainTab = window:CreateTab("Main")
local settingsTab = window:CreateTab("Settings")
local macrosTab = window:CreateTab("Macros")
local creditsTab = window:CreateTab("Credits")

-- [Main Tab Settings]
mainTab:CreateButton("Super Speed", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 74
end)
mainTab:CreateButton("Super Jump", function()
    local hum = game.Players.LocalPlayer.Character.Humanoid
    hum.UseJumpPower = true
    hum.JumpPower = 84
end)

-- [Settings Tab with Custom Sorting]
-- LayoutOrder: -10 makes this appear at the top.
-- Color: Color3 makes the text red.
settingsTab:CreateLabel("--- DANGER ZONE ---", -10, Color3.fromRGB(255, 50, 50)) 

-- LayoutOrder: -5 makes this appear below the label but above other things.
settingsTab:CreateButton("Kill Roblox", function()
    game:Shutdown()
end, Color3.fromRGB(120, 0, 0), -5) 

-- Default (Order 0)
settingsTab:CreateLabel("--- UI SETTINGS ---", 0)
settingsTab:CreateButton("Check Version", function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Moon Hub",
        Text = "Version: Premium v11",
        Duration = 5
    })
end, nil, 1) -- Order 1 puts this at the bottom

-- [Credits Tab Settings]
creditsTab:CreateLabel("--- Created By ---", -10, Color3.fromRGB(178, 108, 235))
creditsTab:CreateLabel("Moon_OFCC", -9)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Moon Hub",
    Text = "Moon Hub Loaded, Right Shift To Toggle GUI",
    Duration = 5
})
