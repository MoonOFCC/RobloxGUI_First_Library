--[[
    AccioLib - v3 (Destroy on X, Minimize on -, Custom Button Colors)
]]

local AccioLib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function AccioLib:CreateWindow(title)
    local Window = {}
    local ui_toggled = true
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AccioLib_v3"
    ScreenGui.Parent = (gethui and gethui()) or CoreGui 
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    
    local TopBarLine = Instance.new("Frame")
    TopBarLine.Name = "Line"
    TopBarLine.Parent = TopBar
    TopBarLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBarLine.Position = UDim2.new(0, 0, 1, -5)
    TopBarLine.Size = UDim2.new(1, 0, 0, 5)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = title or "Accio Library"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Buttons = Instance.new("Frame")
    Buttons.Parent = TopBar
    Buttons.BackgroundTransparency = 1
    Buttons.Position = UDim2.new(1, -75, 0, 0)
    Buttons.Size = UDim2.new(0, 70, 1, 0)

    local function createTopBtn(text, color, pos)
        local btn = Instance.new("TextButton")
        btn.Parent = Buttons
        btn.BackgroundTransparency = 1
        btn.Position = pos
        btn.Size = UDim2.new(0, 30, 1, 0)
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.TextColor3 = color
        btn.TextSize = 18
        return btn
    end

    local CloseBtn = createTopBtn("×", Color3.fromRGB(255, 80, 80), UDim2.new(0, 35, 0, 0))
    local MinBtn = createTopBtn("−", Color3.fromRGB(200, 200, 200), UDim2.new(0, 0, 0, 0))

    -- [X] DESTROYS THE GUI
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- [-] MINIMIZES (TOGGLE)
    local function toggleUI()
        ui_toggled = not ui_toggled
        MainFrame.Visible = ui_toggled
    end
    MinBtn.MouseButton1Click:Connect(toggleUI)

    -- RightShift to Toggle
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
            toggleUI()
        end
    end)

    -- UI Structure
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.Position = UDim2.new(0, 0, 0, 5)
    TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 155, 0, 45)
    ContentArea.Size = UDim2.new(1, -160, 1, -50)

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local currentTab = nil
    function Window:CreateTab(name)
        local Tab = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Text = "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContentArea
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 7)

        local function selectTab()
            if currentTab then
                currentTab.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
                currentTab.Button.BackgroundTransparency = 1
                currentTab.Page.Visible = false
            end
            currentTab = {Button = TabButton, Page = Page}
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.BackgroundTransparency = 0
            Page.Visible = true
        end

        TabButton.MouseButton1Click:Connect(selectTab)
        if not currentTab then selectTab() end

        -- [NEW] Updated Button with Color parameter
        function Tab:CreateButton(text, callback, customColor)
            local Button = Instance.new("TextButton")
            Button.Parent = Page
            Button.BackgroundColor3 = customColor or Color3.fromRGB(45, 45, 45)
            Button.Size = UDim2.new(1, -10, 0, 35)
            Button.Font = Enum.Font.Gotham
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(230, 230, 230)
            Button.TextSize = 13
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

            Button.MouseButton1Click:Connect(function() if callback then callback() end end)
            return Button
        end

        function Tab:CreateToggle(text, default, callback)
            local Toggled = default or false
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame; ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0); ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Text = text; ToggleLabel.TextColor3 = Color3.fromRGB(230, 230, 230); ToggleLabel.TextSize = 13
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left; ToggleLabel.Font = Enum.Font.Gotham

            local SwitchBG = Instance.new("Frame")
            SwitchBG.Parent = ToggleFrame; SwitchBG.BackgroundColor3 = Toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
            SwitchBG.Position = UDim2.new(1, -50, 0.5, -10); SwitchBG.Size = UDim2.new(0, 40, 0, 20)
            Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame")
            Knob.Parent = SwitchBG; Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Position = Toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
            Knob.Size = UDim2.new(0, 16, 0, 16); Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local Click = Instance.new("TextButton", ToggleFrame)
            Click.BackgroundTransparency = 1; Click.Size = UDim2.new(1, 0, 1, 0); Click.Text = ""

            Click.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                SwitchBG.BackgroundColor3 = Toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
                Knob.Position = Toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
                if callback then callback(Toggled) end
            end)
            return ToggleFrame
        end
        return Tab
    end
    return Window
end

return AccioLib
