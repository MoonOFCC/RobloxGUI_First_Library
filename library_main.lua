--[[
    MoonLib - v13 (Advanced Contrast Update)
    - Added Optional Custom Background Colors for all components
    - Auto-Contrast Text: Automatically switches text to Black on bright colors
    - Manual LayoutOrder support for all elements
    - Weighted Lerp Dragging (0.1 damping)
]]

local MoonLib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Helper: Determines if a color is bright or dark (True = Bright)
local function isColorBright(color)
    local luminance = (0.299 * color.R) + (0.587 * color.G) + (0.114 * color.B)
    return luminance > 0.5
end

function MoonLib:CreateWindow(title)
    local Window = {}
    local ui_toggled = true
    local is_destroyed = false
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MoonLib_v13"
    ScreenGui.Parent = (gethui and gethui()) or CoreGui 
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"; MainFrame.Parent = ScreenGui; MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); MainFrame.BorderSizePixel = 0; MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175); MainFrame.Size = UDim2.new(0, 500, 0, 350); MainFrame.ClipsDescendants = true; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"; TopBar.Parent = MainFrame; TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); TopBar.BorderSizePixel = 0; TopBar.Size = UDim2.new(1, 0, 0, 40); Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TopBar; TitleLabel.BackgroundTransparency = 1; TitleLabel.Position = UDim2.new(0, 15, 0, 0); TitleLabel.Size = UDim2.new(1, -100, 1, 0); TitleLabel.Font = Enum.Font.GothamBold; TitleLabel.Text = title or "Accio Library"; TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); TitleLabel.TextSize = 18; TitleLabel.RichText = true; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Buttons = Instance.new("Frame")
    Buttons.Parent = TopBar; Buttons.BackgroundTransparency = 1; Buttons.Position = UDim2.new(1, -75, 0, 0); Buttons.Size = UDim2.new(0, 70, 1, 0); Buttons.ZIndex = 10
    local function createTopBtn(text, color, pos)
        local btn = Instance.new("TextButton")
        btn.Parent = Buttons; btn.BackgroundTransparency = 1; btn.Position = pos; btn.Size = UDim2.new(0, 30, 1, 0); btn.Font = Enum.Font.GothamBold; btn.Text = text; btn.TextColor3 = color; btn.TextSize = 24; btn.ZIndex = 11; return btn
    end
    local CloseBtn = createTopBtn("×", Color3.fromRGB(255, 80, 80), UDim2.new(0, 35, 0, 0))
    local MinBtn = createTopBtn("−", Color3.fromRGB(200, 200, 200), UDim2.new(0, 0, 0, 0))
    CloseBtn.MouseButton1Click:Connect(function() --[[self:Destroy()]] is_destroyed = true; ScreenGui:Destroy() end)
    local function toggleUI() if is_destroyed then return end ui_toggled = not ui_toggled; MainFrame.Visible = ui_toggled end
    MinBtn.MouseButton1Click:Connect(toggleUI)
    UserInputService.InputBegan:Connect(function(input, gpe) if not gpe and input.KeyCode == Enum.KeyCode.RightShift then toggleUI() end end)

    -- DRAGGING
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    RunService.RenderStepped:Connect(function() if dragging and not is_destroyed then local mouse = UserInputService:GetMouseLocation()
    local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + (mouse.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (mouse.Y - dragStart.Y) - 36)
    MainFrame.Position = MainFrame.Position:Lerp(targetPos, 0.1) end end)

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.Size = UDim2.new(0, 150, 1, -40); Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
    local TabContainer = Instance.new("ScrollingFrame", Sidebar); TabContainer.BackgroundTransparency = 1; TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.Position = UDim2.new(0, 0, 0, 5); TabContainer.ScrollBarThickness = 0; Instance.new("UIListLayout", TabContainer).HorizontalAlignment = Enum.HorizontalAlignment.Center
    local ContentArea = Instance.new("Frame", MainFrame); ContentArea.BackgroundTransparency = 1; ContentArea.Position = UDim2.new(0, 155, 0, 45); ContentArea.Size = UDim2.new(1, -160, 1, -50)

    local currentTab = nil
    function Window:CreateTab(name)
        local Tab = {}
        local TabButton = Instance.new("TextButton", TabContainer)
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TabButton.BackgroundTransparency = 1; TabButton.Size = UDim2.new(1, -14, 0, 40); TabButton.Text = name; TabButton.TextColor3 = Color3.fromRGB(160, 160, 160); TabButton.Font = Enum.Font.GothamBold; TabButton.TextSize = 18; TabButton.RichText = true; Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
        local Page = Instance.new("ScrollingFrame", ContentArea); Page.BackgroundTransparency = 1; Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.ScrollBarThickness = 0; Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local PageLayout = Instance.new("UIListLayout", Page); PageLayout.Padding = UDim.new(0, 7); PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function selectTab() if currentTab then currentTab.Button.TextColor3 = Color3.fromRGB(160, 160, 160); currentTab.Button.BackgroundTransparency = 1; currentTab.Page.Visible = false end
            currentTab = {Button = TabButton, Page = Page}; TabButton.TextColor3 = Color3.fromRGB(255, 255, 255); TabButton.BackgroundTransparency = 0; Page.Visible = true end
        TabButton.MouseButton1Click:Connect(selectTab)
        if not currentTab then selectTab() end

        function Tab:CreateLabel(text, order, color)
            local Label = Instance.new("TextLabel", Page); Label.BackgroundTransparency = 1; Label.Size = UDim2.new(1, -10, 0, 25); Label.Font = Enum.Font.GothamBold; Label.Text = text; Label.TextColor3 = color or Color3.fromRGB(200, 200, 200); Label.TextSize = 16; Label.RichText = true; Label.LayoutOrder = order or 0
            return Label
        end

        function Tab:CreateButton(text, callback, customColor, order)
            local baseColor = customColor or Color3.fromRGB(45, 45, 45)
            local textColor = isColorBright(baseColor) and Color3.fromRGB(0,0,0) or Color3.fromRGB(230,230,230)
            local Button = Instance.new("TextButton", Page); Button.BackgroundColor3 = baseColor; Button.Size = UDim2.new(1, -10, 0, 35); Button.Font = Enum.Font.GothamBold; Button.Text = text; Button.TextColor3 = textColor; Button.TextSize = 16; Button.LayoutOrder = order or 0; Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            Button.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = baseColor:Lerp(Color3.new(1,1,1), 0.1)}):Play() end); Button.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = baseColor}):Play() end)
            Button.MouseButton1Click:Connect(function() if callback then callback() end end); return Button
        end

        function Tab:CreateToggle(text, default, callback, order, customColor)
            local Toggled = default or false
            local baseColor = customColor or Color3.fromRGB(45, 45, 45)
            local textColor = isColorBright(baseColor) and Color3.fromRGB(0,0,0) or Color3.fromRGB(230,230,230)
            
            local ToggleFrame = Instance.new("Frame", Page); ToggleFrame.BackgroundColor3 = baseColor; ToggleFrame.Size = UDim2.new(1, -10, 0, 35); ToggleFrame.LayoutOrder = order or 0; Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
            local ToggleLabel = Instance.new("TextLabel", ToggleFrame); ToggleLabel.BackgroundTransparency = 1; ToggleLabel.Position = UDim2.new(0, 15, 0, 0); ToggleLabel.Size = UDim2.new(1, -60, 1, 0); ToggleLabel.Text = text; ToggleLabel.TextColor3 = textColor; ToggleLabel.TextSize = 15; ToggleLabel.Font = Enum.Font.GothamBold; ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            local SwitchBG = Instance.new("Frame", ToggleFrame); SwitchBG.BackgroundColor3 = Toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60); SwitchBG.Position = UDim2.new(1, -50, 0.5, -10); SwitchBG.Size = UDim2.new(0, 40, 0, 20); Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)
            local Knob = Instance.new("Frame", SwitchBG); Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Knob.Position = Toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2); Knob.Size = UDim2.new(0, 16, 0, 16); Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
            local Click = Instance.new("TextButton", ToggleFrame); Click.BackgroundTransparency = 1; Click.Size = UDim2.new(1, 0, 1, 0); Click.Text = ""
            Click.MouseButton1Click:Connect(function() Toggled = not Toggled; SwitchBG.BackgroundColor3 = Toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60); Knob.Position = Toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2); if callback then callback(Toggled) end end)
            return ToggleFrame
        end

        function Tab:CreateSlider(text, defaultState, callback, defaultVal, min, max, order, customColor)
            local Toggled = defaultState or false
            local CurrentValue = defaultVal or min
            local baseColor = customColor or Color3.fromRGB(45, 45, 45)
            local textColor = isColorBright(baseColor) and Color3.fromRGB(0,0,0) or Color3.fromRGB(230,230,230)
            
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.BackgroundColor3 = baseColor; SliderFrame.Size = UDim2.new(1, -10, 0, 65); SliderFrame.LayoutOrder = order or 0; Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)
            local ToggleLabel = Instance.new("TextLabel", SliderFrame); ToggleLabel.BackgroundTransparency = 1; ToggleLabel.Position = UDim2.new(0, 15, 0, 5); ToggleLabel.Size = UDim2.new(1, -100, 0, 30); ToggleLabel.Text = text; ToggleLabel.TextColor3 = textColor; ToggleLabel.TextSize = 15; ToggleLabel.Font = Enum.Font.GothamBold; ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            local SwitchBG = Instance.new("Frame", SliderFrame); SwitchBG.BackgroundColor3 = Toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60); SwitchBG.Position = UDim2.new(1, -50, 0, 10); SwitchBG.Size = UDim2.new(0, 40, 0, 20); Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)
            local Knob = Instance.new("Frame", SwitchBG); Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Knob.Position = Toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2); Knob.Size = UDim2.new(0, 16, 0, 16); Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
            local SliderBack = Instance.new("Frame", SliderFrame); SliderBack.BackgroundColor3 = isColorBright(baseColor) and Color3.fromRGB(0,0,0) or Color3.fromRGB(60, 60, 60); SliderBack.BackgroundTransparency = 0.5; SliderBack.Position = UDim2.new(0, 15, 0, 45); SliderBack.Size = UDim2.new(1, -80, 0, 6); Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)
            local SliderFill = Instance.new("Frame", SliderBack); SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255); SliderFill.Size = UDim2.new((CurrentValue - min) / (max - min), 0, 1, 0); Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
            local SliderKnob = Instance.new("Frame", SliderBack); SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); SliderKnob.Position = UDim2.new((CurrentValue - min) / (max - min), -6, 0.5, -6); SliderKnob.Size = UDim2.new(0, 12, 0, 12); Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)
            local ValueDisplay = Instance.new("TextLabel", SliderFrame); ValueDisplay.BackgroundTransparency = 1; ValueDisplay.Position = UDim2.new(1, -60, 0, 33); ValueDisplay.Size = UDim2.new(0, 50, 0, 30); ValueDisplay.Font = Enum.Font.GothamBold; ValueDisplay.Text = tostring(CurrentValue); ValueDisplay.TextColor3 = textColor; ValueDisplay.TextSize = 14
            
            local Click = Instance.new("TextButton", SliderFrame); Click.BackgroundTransparency = 1; Click.Position = UDim2.new(0,0,0,0); Click.Size = UDim2.new(1, 0, 0, 40); Click.Text = ""
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                CurrentValue = math.floor(min + (max - min) * pos)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0); SliderKnob.Position = UDim2.new(pos, -6, 0.5, -6); ValueDisplay.Text = tostring(CurrentValue)
                if callback then callback(Toggled, CurrentValue) end
            end
            SliderBack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then local move; move = UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end) updateSlider(input) end end)
            Click.MouseButton1Click:Connect(function() Toggled = not Toggled; SwitchBG.BackgroundColor3 = Toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60); Knob.Position = Toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2); if callback then callback(Toggled, CurrentValue) end end)
            return SliderFrame
        end
        return Tab
    end
    return Window
end

return MoonLib
