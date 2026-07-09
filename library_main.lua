--[[
    AccioLib - Updated for GitHub/Executors
    Features: Close (X), Minimize (-), and Keybind Toggle (RightShift)
]]

local AccioLib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function AccioLib:CreateWindow(title)
    local Window = {}
    local ui_toggled = true
    
    -- Main UI Construction
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AccioLib_v2"
    -- Protecting the GUI from being detected/deleted easily in some executors
    ScreenGui.Parent = (gethui and gethui()) or CoreGui 
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local TopBarLine = Instance.new("Frame")
    TopBarLine.Name = "Line"
    TopBarLine.Parent = TopBar
    TopBarLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBarLine.BorderSizePixel = 0
    TopBarLine.Position = UDim2.new(0, 0, 1, -5)
    TopBarLine.Size = UDim2.new(1, 0, 0, 5)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = title or "Accio Library"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- [NEW] BUTTONS CONTAINER
    local Buttons = Instance.new("Frame")
    Buttons.Name = "Buttons"
    Buttons.Parent = TopBar
    Buttons.BackgroundTransparency = 1
    Buttons.Position = UDim2.new(1, -75, 0, 0)
    Buttons.Size = UDim2.new(0, 70, 1, 0)

    -- Function to create TopBar Buttons
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
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {TextTransparency = 0.5}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        end)
        
        return btn
    end

    local CloseBtn = createTopBtn("×", Color3.fromRGB(255, 100, 100), UDim2.new(0, 35, 0, 0))
    local MinBtn = createTopBtn("−", Color3.fromRGB(200, 200, 200), UDim2.new(0, 0, 0, 0))

    -- Visibility Toggle Logic
    local function toggleUI()
        ui_toggled = not ui_toggled
        MainFrame.Visible = ui_toggled
    end

    CloseBtn.MouseButton1Click:Connect(toggleUI)
    MinBtn.MouseButton1Click:Connect(toggleUI)

    -- [NEW] Keybind to reopen (RightShift)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
            toggleUI()
        end
    end)

    -- Sidebar and Content Logic (UNCHANGED)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar
    
    local SidebarLine = Instance.new("Frame")
    SidebarLine.Name = "Line"
    SidebarLine.Parent = Sidebar
    SidebarLine.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Position = UDim2.new(1, -5, 0, 0)
    SidebarLine.Size = UDim2.new(0, 5, 1, 0)

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.Position = UDim2.new(0, 0, 0, 5)
    TabContainer.ScrollBarThickness = 0
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 155, 0, 45)
    ContentArea.Size = UDim2.new(1, -160, 1, -50)

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    -- Tab System
    local currentTab = nil
    function Window:CreateTab(name)
        local Tab = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Position = UDim2.new(0, 5, 0, 0)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabUICorner = Instance.new("UICorner")
        TabUICorner.CornerRadius = UDim.new(0, 6)
        TabUICorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContentArea
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 2
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 7)

        local function selectTab()
            if currentTab then
                currentTab.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
                TweenService:Create(currentTab.Button, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                currentTab.Page.Visible = false
            end
            currentTab = {Button = TabButton, Page = Page}
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            Page.Visible = true
        end

        TabButton.MouseButton1Click:Connect(selectTab)
        if not currentTab then selectTab() end

        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Page
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
            ToggleLabel.TextSize = 13
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchBG = Instance.new("Frame")
            SwitchBG.Parent = ToggleFrame
            SwitchBG.BackgroundColor3 = Toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
            SwitchBG.Position = UDim2.new(1, -50, 0.5, -10)
            SwitchBG.Size = UDim2.new(0, 40, 0, 20)
            Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame")
            Knob.Parent = SwitchBG
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Position = Toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local ClickRegion = Instance.new("TextButton")
            ClickRegion.Parent = ToggleFrame
            ClickRegion.BackgroundTransparency = 1
            ClickRegion.Size = UDim2.new(1, 0, 1, 0)
            ClickRegion.Text = ""

            ClickRegion.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), {Position = Toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
                if callback then callback(Toggled) end
            end)
            return ToggleFrame
        end
        return Tab
    end
    return Window
end

return AccioLib
