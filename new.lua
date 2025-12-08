-- Modern UI Library
-- A fresh, mobile-friendly UI library with left-side tabs
-- Version 1.0

local ModernUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Utility Functions
local function Tween(instance, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
    tween:Play()
    return tween
end

local function Ripple(button, x, y)
    spawn(function()
        local ripple = Instance.new("ImageLabel")
        ripple.Name = "Ripple"
        ripple.BackgroundTransparency = 1
        ripple.Image = "rbxassetid://2708891598"
        ripple.ImageTransparency = 0.5
        ripple.ScaleType = Enum.ScaleType.Fit
        ripple.ZIndex = button.ZIndex + 1
        ripple.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Parent = button
        
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        Tween(ripple, {Size = UDim2.new(0, size, 0, size), ImageTransparency = 1}, 0.5)
        
        task.wait(0.5)
        ripple:Destroy()
    end)
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - mousePos
            Tween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1, Enum.EasingStyle.Linear)
        end
    end)
end

-- Main Library Functions
function ModernUI:CreateWindow(options)
    options = options or {}
    local WindowName = options.Name or "Modern UI"
    local WindowIcon = options.Icon or "rbxassetid://7733955511"
    local Theme = options.Theme or {
        Primary = Color3.fromRGB(45, 45, 55),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(200, 200, 200),
        Background = Color3.fromRGB(25, 25, 35),
        Border = Color3.fromRGB(60, 60, 70)
    }
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end
    
    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame
    
    -- Drop Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Theme.Primary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    local TopBarBottom = Instance.new("Frame")
    TopBarBottom.Size = UDim2.new(1, 0, 0, 12)
    TopBarBottom.Position = UDim2.new(0, 0, 1, -12)
    TopBarBottom.BackgroundColor3 = Theme.Primary
    TopBarBottom.BorderSizePixel = 0
    TopBarBottom.Parent = TopBar
    
    -- Icon
    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 30, 0, 30)
    Icon.Position = UDim2.new(0, 15, 0.5, -15)
    Icon.BackgroundTransparency = 1
    Icon.Image = WindowIcon
    Icon.ImageColor3 = Theme.Accent
    Icon.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 55, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = Theme.Text
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0.5, -20)
    CloseButton.BackgroundColor3 = Theme.Secondary
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
    end)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(1, -90, 0.5, -20)
    MinimizeButton.BackgroundColor3 = Theme.Secondary
    MinimizeButton.Text = "─"
    MinimizeButton.TextColor3 = Theme.Text
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Parent = TopBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeButton
    
    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 50)}, 0.3)
            MinimizeButton.Text = "□"
        else
            Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.3)
            MinimizeButton.Text = "─"
        end
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Theme.Accent}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
    end)
    
    MakeDraggable(MainFrame, TopBar)
    
    -- Tab Container (Left Side)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundColor3 = Theme.Primary
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = Theme.Accent
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingBottom = UDim.new(0, 5)
    TabPadding.PaddingLeft = UDim.new(0, 5)
    TabPadding.PaddingRight = UDim.new(0, 5)
    TabPadding.Parent = TabContainer
    
    -- Content Container (Right Side)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -170, 1, -60)
    ContentContainer.Position = UDim2.new(0, 165, 0, 55)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    local Tabs = {}
    local CurrentTab = nil
    
    local Window = {}
    
    function Window:CreateTab(options)
        options = options or {}
        local TabName = options.Name or "Tab"
        local TabIcon = options.Icon or "rbxassetid://7733955511"
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = TabName
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Theme.Secondary
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton
        
        local TabIconImage = Instance.new("ImageLabel")
        TabIconImage.Name = "Icon"
        TabIconImage.Size = UDim2.new(0, 24, 0, 24)
        TabIconImage.Position = UDim2.new(0, 10, 0.5, -12)
        TabIconImage.BackgroundTransparency = 1
        TabIconImage.Image = TabIcon
        TabIconImage.ImageColor3 = Theme.SubText
        TabIconImage.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(1, -45, 1, 0)
        TabLabel.Position = UDim2.new(0, 40, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = TabName
        TabLabel.TextColor3 = Theme.SubText
        TabLabel.TextSize = 14
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("Frame")
        TabContent.Name = TabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        -- Left Section
        local LeftSection = Instance.new("ScrollingFrame")
        LeftSection.Name = "LeftSection"
        LeftSection.Size = UDim2.new(0.48, 0, 1, 0)
        LeftSection.Position = UDim2.new(0, 0, 0, 0)
        LeftSection.BackgroundTransparency = 1
        LeftSection.BorderSizePixel = 0
        LeftSection.ScrollBarThickness = 4
        LeftSection.ScrollBarImageColor3 = Theme.Accent
        LeftSection.CanvasSize = UDim2.new(0, 0, 0, 0)
        LeftSection.AutomaticCanvasSize = Enum.AutomaticSize.Y
        LeftSection.Parent = TabContent
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 10)
        LeftLayout.Parent = LeftSection
        
        -- Right Section
        local RightSection = Instance.new("ScrollingFrame")
        RightSection.Name = "RightSection"
        RightSection.Size = UDim2.new(0.48, 0, 1, 0)
        RightSection.Position = UDim2.new(0.52, 0, 0, 0)
        RightSection.BackgroundTransparency = 1
        RightSection.BorderSizePixel = 0
        RightSection.ScrollBarThickness = 4
        RightSection.ScrollBarImageColor3 = Theme.Accent
        RightSection.CanvasSize = UDim2.new(0, 0, 0, 0)
        RightSection.AutomaticCanvasSize = Enum.AutomaticSize.Y
        RightSection.Parent = TabContent
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 10)
        RightLayout.Parent = RightSection
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Button.BackgroundColor3 = Theme.Secondary
                tab.Icon.ImageColor3 = Theme.SubText
                tab.Label.TextColor3 = Theme.SubText
                tab.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Theme.Accent
            TabIconImage.ImageColor3 = Theme.Text
            TabLabel.TextColor3 = Theme.Text
            TabContent.Visible = true
            CurrentTab = TabContent
            
            Ripple(TabButton, Mouse.X, Mouse.Y)
        end)
        
        TabButton.MouseEnter:Connect(function()
            if TabButton.BackgroundColor3 ~= Theme.Accent then
                Tween(TabButton, {BackgroundColor3 = Theme.Border}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabButton.BackgroundColor3 ~= Theme.Accent then
                Tween(TabButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
            end
        end)
        
        local Tab = {
            Button = TabButton,
            Icon = TabIconImage,
            Label = TabLabel,
            Content = TabContent,
            LeftSection = LeftSection,
            RightSection = RightSection
        }
        
        table.insert(Tabs, Tab)
        
        if #Tabs == 1 then
            TabButton.BackgroundColor3 = Theme.Accent
            TabIconImage.ImageColor3 = Theme.Text
            TabLabel.TextColor3 = Theme.Text
            TabContent.Visible = true
            CurrentTab = TabContent
        end
        
        -- Tab Functions
        function Tab:CreateSection(options)
            options = options or {}
            local SectionName = options.Name or "Section"
            local Side = options.Side or "Left"
            
            local Parent = Side == "Left" and LeftSection or RightSection
            
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = SectionName
            SectionFrame.Size = UDim2.new(1, 0, 0, 40)
            SectionFrame.BackgroundColor3 = Theme.Primary
            SectionFrame.BorderSizePixel = 0
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.Parent = Parent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = SectionFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -20, 0, 35)
            SectionTitle.Position = UDim2.new(0, 10, 0, 5)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = SectionName
            SectionTitle.TextColor3 = Theme.Text
            SectionTitle.TextSize = 16
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            local SectionContainer = Instance.new("Frame")
            SectionContainer.Name = "Container"
            SectionContainer.Size = UDim2.new(1, -20, 1, -45)
            SectionContainer.Position = UDim2.new(0, 10, 0, 40)
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.AutomaticSize = Enum.AutomaticSize.Y
            SectionContainer.Parent = SectionFrame
            
            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Padding = UDim.new(0, 8)
            SectionLayout.Parent = SectionContainer
            
            local Section = {}
            
            function Section:AddButton(options)
                options = options or {}
                local ButtonName = options.Name or "Button"
                local Callback = options.Callback or function() end
                
                local Button = Instance.new("TextButton")
                Button.Name = ButtonName
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.BackgroundColor3 = Theme.Secondary
                Button.Text = ButtonName
                Button.TextColor3 = Theme.Text
                Button.TextSize = 14
                Button.Font = Enum.Font.GothamMedium
                Button.BorderSizePixel = 0
                Button.AutoButtonColor = false
                Button.Parent = SectionContainer
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 8)
                ButtonCorner.Parent = Button
                
                Button.MouseButton1Click:Connect(function()
                    Ripple(Button, Mouse.X, Mouse.Y)
                    pcall(Callback)
                end)
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = Theme.Accent}, 0.2)
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = Theme.Secondary}, 0.2)
                end)
                
                return Button
            end
            
            function Section:AddToggle(options)
                options = options or {}
                local ToggleName = options.Name or "Toggle"
                local Default = options.Default or false
                local Callback = options.Callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = ToggleName
                ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
                ToggleFrame.BackgroundColor3 = Theme.Secondary
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Parent = SectionContainer
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 8)
                ToggleCorner.Parent = ToggleFrame
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = ToggleName
                ToggleLabel.TextColor3 = Theme.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.Font = Enum.Font.GothamMedium
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
                ToggleButton.BackgroundColor3 = Default and Theme.Accent or Theme.Border
                ToggleButton.Text = ""
                ToggleButton.BorderSizePixel = 0
                ToggleButton.AutoButtonColor = false
                ToggleButton.Parent = ToggleFrame
                
                local ToggleButtonCorner = Instance.new("UICorner")
                ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
                ToggleButtonCorner.Parent = ToggleButton
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
                ToggleIndicator.Position = Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                ToggleIndicator.BackgroundColor3 = Theme.Text
                ToggleIndicator.BorderSizePixel = 0
                ToggleIndicator.Parent = ToggleButton
                
                local IndicatorCorner = Instance.new("UICorner")
                IndicatorCorner.CornerRadius = UDim.new(1, 0)
                IndicatorCorner.Parent = ToggleIndicator
                
                local Toggled = Default
                
                ToggleButton.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    
                    Tween(ToggleButton, {BackgroundColor3 = Toggled and Theme.Accent or Theme.Border}, 0.2)
                    Tween(ToggleIndicator, {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                    
                    pcall(function()
                        Callback(Toggled)
                    end)
                end)
                
                local Toggle = {}
                function Toggle:SetValue(value)
                    Toggled = value
                    Tween(ToggleButton, {BackgroundColor3 = Toggled and Theme.Accent or Theme.Border}, 0.2)
                    Tween(ToggleIndicator, {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                end
                
                return Toggle
            end
            
            function Section:AddSlider(options)
                options = options or {}
                local SliderName = options.Name or "Slider"
                local Min = options.Min or 0
                local Max = options.Max or 100
                local Default = options.Default or Min
                local Increment = options.Increment or 1
                local Callback = options.Callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = SliderName
                SliderFrame.Size = UDim2.new(1, 0, 0, 50)
                SliderFrame.BackgroundColor3 = Theme.Secondary
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Parent = SectionContainer
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 8)
                SliderCorner.Parent = SliderFrame
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(1, -20, 0, 20)
                SliderLabel.Position = UDim2.new(0, 10, 0, 5)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = SliderName
                SliderLabel.TextColor3 = Theme.Text
                SliderLabel.TextSize = 14
                SliderLabel.Font = Enum.Font.GothamMedium
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Size = UDim2.new(0, 50, 0, 20)
                SliderValue.Position = UDim2.new(1, -60, 0, 5)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(Default)
                SliderValue.TextColor3 = Theme.Accent
                SliderValue.TextSize = 14
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderFrame
                
                local SliderBackground = Instance.new("Frame")
                SliderBackground.Size = UDim2.new(1, -20, 0, 6)
                SliderBackground.Position = UDim2.new(0, 10, 1, -12)
                SliderBackground.BackgroundColor3 = Theme.Border
                SliderBackground.BorderSizePixel = 0
                SliderBackground.Parent = SliderFrame
                
                local SliderBgCorner = Instance.new("UICorner")
                SliderBgCorner.CornerRadius = UDim.new(1, 0)
                SliderBgCorner.Parent = SliderBackground
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Theme.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBackground
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local Dragging = false
                local CurrentValue = Default
                
                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                    local value = math.floor((Min + (Max - Min) * pos) / Increment + 0.5) * Increment
                    value = math.clamp(value, Min, Max)
                    
                    CurrentValue = value
                    SliderValue.Text = tostring(value)
                    Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1, Enum.EasingStyle.Linear)
                    
                    pcall(function()
                        Callback(value)
                    end)
                end
                
                SliderBackground.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        UpdateSlider(input)
                    end
                end)
                
                SliderBackground.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
                
                local Slider = {}
                function Slider:SetValue(value)
                    CurrentValue = math.clamp(value, Min, Max)
                    SliderValue.Text = tostring(CurrentValue)
                    local pos = (CurrentValue - Min) / (Max - Min)
                    Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.2)
                end
                
                return Slider
            end
            
            function Section:AddDropdown(options)
                options = options or {}
                local DropdownName = options.Name or "Dropdown"
                local Items = options.Items or {}
                local Default = options.Default or ""
                local Callback = options.Callback or function() end
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = DropdownName
                DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                DropdownFrame.BackgroundColor3 = Theme.Secondary
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.Parent = SectionContainer
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 8)
                DropdownCorner.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(1, 0, 0, 35)
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Text = ""
                DropdownButton.Parent = DropdownFrame
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Size = UDim2.new(1, -60, 1, 0)
                DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = DropdownName
                DropdownLabel.TextColor3 = Theme.Text
                DropdownLabel.TextSize = 14
                DropdownLabel.Font = Enum.Font.GothamMedium
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownButton
                
                local DropdownValue = Instance.new("TextLabel")
                DropdownValue.Size = UDim2.new(0, 100, 1, 0)
                DropdownValue.Position = UDim2.new(1, -130, 0, 0)
                DropdownValue.BackgroundTransparency = 1
                DropdownValue.Text = Default
                DropdownValue.TextColor3 = Theme.SubText
                DropdownValue.TextSize = 13
                DropdownValue.Font = Enum.Font.Gotham
                DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
                DropdownValue.TextTruncate = Enum.TextTruncate.AtEnd
                DropdownValue.Parent = DropdownButton
                
                local DropdownArrow = Instance.new("TextLabel")
                DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
                DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Text = "▼"
                DropdownArrow.TextColor3 = Theme.SubText
                DropdownArrow.TextSize = 10
                DropdownArrow.Font = Enum.Font.GothamBold
                DropdownArrow.Parent = DropdownButton
                
                local DropdownList = Instance.new("ScrollingFrame")
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                DropdownList.Position = UDim2.new(0, 0, 0, 35)
                DropdownList.BackgroundColor3 = Theme.Primary
                DropdownList.BorderSizePixel = 0
                DropdownList.ScrollBarThickness = 3
                DropdownList.ScrollBarImageColor3 = Theme.Accent
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
                DropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
                DropdownList.Visible = false
                DropdownList.Parent = DropdownFrame
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Padding = UDim.new(0, 2)
                ListLayout.Parent = DropdownList
                
                local ListPadding = Instance.new("UIPadding")
                ListPadding.PaddingTop = UDim.new(0, 5)
                ListPadding.PaddingBottom = UDim.new(0, 5)
                ListPadding.Parent = DropdownList
                
                local Opened = false
                local CurrentValue = Default
                
                DropdownButton.MouseButton1Click:Connect(function()
                    Opened = not Opened
                    
                    if Opened then
                        local height = math.min(#Items * 28 + 10, 150)
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35 + height)}, 0.3)
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, height)}, 0.3)
                        task.wait(0.1)
                        DropdownList.Visible = true
                        Tween(DropdownArrow, {Rotation = 180}, 0.3)
                    else
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                        Tween(DropdownArrow, {Rotation = 0}, 0.3)
                        task.wait(0.3)
                        DropdownList.Visible = false
                    end
                end)
                
                for _, item in ipairs(Items) do
                    local ItemButton = Instance.new("TextButton")
                    ItemButton.Size = UDim2.new(1, -10, 0, 25)
                    ItemButton.BackgroundColor3 = Theme.Secondary
                    ItemButton.Text = item
                    ItemButton.TextColor3 = Theme.Text
                    ItemButton.TextSize = 13
                    ItemButton.Font = Enum.Font.Gotham
                    ItemButton.BorderSizePixel = 0
                    ItemButton.AutoButtonColor = false
                    ItemButton.Parent = DropdownList
                    
                    local ItemCorner = Instance.new("UICorner")
                    ItemCorner.CornerRadius = UDim.new(0, 6)
                    ItemCorner.Parent = ItemButton
                    
                    ItemButton.MouseButton1Click:Connect(function()
                        CurrentValue = item
                        DropdownValue.Text = item
                        
                        Opened = false
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                        Tween(DropdownArrow, {Rotation = 0}, 0.3)
                        task.wait(0.3)
                        DropdownList.Visible = false
                        
                        pcall(function()
                            Callback(item)
                        end)
                    end)
                    
                    ItemButton.MouseEnter:Connect(function()
                        Tween(ItemButton, {BackgroundColor3 = Theme.Accent}, 0.2)
                    end)
                    
                    ItemButton.MouseLeave:Connect(function()
                        Tween(ItemButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
                    end)
                end
                
                local Dropdown = {}
                function Dropdown:SetValue(value)
                    CurrentValue = value
                    DropdownValue.Text = value
                end
                
                function Dropdown:Refresh(newItems)
                    Items = newItems
                    for _, child in ipairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for _, item in ipairs(Items) do
                        local ItemButton = Instance.new("TextButton")
                        ItemButton.Size = UDim2.new(1, -10, 0, 25)
                        ItemButton.BackgroundColor3 = Theme.Secondary
                        ItemButton.Text = item
                        ItemButton.TextColor3 = Theme.Text
                        ItemButton.TextSize = 13
                        ItemButton.Font = Enum.Font.Gotham
                        ItemButton.BorderSizePixel = 0
                        ItemButton.AutoButtonColor = false
                        ItemButton.Parent = DropdownList
                        
                        local ItemCorner = Instance.new("UICorner")
                        ItemCorner.CornerRadius = UDim.new(0, 6)
                        ItemCorner.Parent = ItemButton
                        
                        ItemButton.MouseButton1Click:Connect(function()
                            CurrentValue = item
                            DropdownValue.Text = item
                            
                            Opened = false
                            Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3)
                            Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                            Tween(DropdownArrow, {Rotation = 0}, 0.3)
                            task.wait(0.3)
                            DropdownList.Visible = false
                            
                            pcall(function()
                                Callback(item)
                            end)
                        end)
                        
                        ItemButton.MouseEnter:Connect(function()
                            Tween(ItemButton, {BackgroundColor3 = Theme.Accent}, 0.2)
                        end)
                        
                        ItemButton.MouseLeave:Connect(function()
                            Tween(ItemButton, {BackgroundColor3 = Theme.Secondary}, 0.2)
                        end)
                    end
                end
                
                return Dropdown
            end
            
            function Section:AddLabel(options)
                options = options or {}
                local LabelText = options.Text or "Label"
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 25)
                Label.BackgroundTransparency = 1
                Label.Text = LabelText
                Label.TextColor3 = Theme.SubText
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                Label.AutomaticSize = Enum.AutomaticSize.Y
                Label.Parent = SectionContainer
                
                local LabelObj = {}
                function LabelObj:SetText(text)
                    Label.Text = text
                end
                
                return LabelObj
            end
            
            function Section:AddColorPicker(options)
                options = options or {}
                local PickerName = options.Name or "Color Picker"
                local Default = options.Default or Color3.fromRGB(255, 255, 255)
                local Callback = options.Callback or function() end
                
                local PickerFrame = Instance.new("Frame")
                PickerFrame.Name = PickerName
                PickerFrame.Size = UDim2.new(1, 0, 0, 35)
                PickerFrame.BackgroundColor3 = Theme.Secondary
                PickerFrame.BorderSizePixel = 0
                PickerFrame.Parent = SectionContainer
                
                local PickerCorner = Instance.new("UICorner")
                PickerCorner.CornerRadius = UDim.new(0, 8)
                PickerCorner.Parent = PickerFrame
                
                local PickerLabel = Instance.new("TextLabel")
                PickerLabel.Size = UDim2.new(1, -50, 1, 0)
                PickerLabel.Position = UDim2.new(0, 10, 0, 0)
                PickerLabel.BackgroundTransparency = 1
                PickerLabel.Text = PickerName
                PickerLabel.TextColor3 = Theme.Text
                PickerLabel.TextSize = 14
                PickerLabel.Font = Enum.Font.GothamMedium
                PickerLabel.TextXAlignment = Enum.TextXAlignment.Left
                PickerLabel.Parent = PickerFrame
                
                local ColorDisplay = Instance.new("Frame")
                ColorDisplay.Size = UDim2.new(0, 30, 0, 20)
                ColorDisplay.Position = UDim2.new(1, -40, 0.5, -10)
                ColorDisplay.BackgroundColor3 = Default
                ColorDisplay.BorderSizePixel = 0
                ColorDisplay.Parent = PickerFrame
                
                local ColorCorner = Instance.new("UICorner")
                ColorCorner.CornerRadius = UDim.new(0, 6)
                ColorCorner.Parent = ColorDisplay
                
                local ColorButton = Instance.new("TextButton")
                ColorButton.Size = UDim2.new(1, 0, 1, 0)
                ColorButton.BackgroundTransparency = 1
                ColorButton.Text = ""
                ColorButton.Parent = ColorDisplay
                
                local CurrentColor = Default
                
                ColorButton.MouseButton1Click:Connect(function()
                    -- Simple color cycle for demonstration
                    local colors = {
                        Color3.fromRGB(255, 0, 0),
                        Color3.fromRGB(255, 165, 0),
                        Color3.fromRGB(255, 255, 0),
                        Color3.fromRGB(0, 255, 0),
                        Color3.fromRGB(0, 0, 255),
                        Color3.fromRGB(138, 43, 226),
                        Color3.fromRGB(255, 255, 255)
                    }
                    
                    local currentIndex = 1
                    for i, color in ipairs(colors) do
                        if CurrentColor == color then
                            currentIndex = i
                            break
                        end
                    end
                    
                    currentIndex = currentIndex % #colors + 1
                    CurrentColor = colors[currentIndex]
                    
                    Tween(ColorDisplay, {BackgroundColor3 = CurrentColor}, 0.2)
                    pcall(function()
                        Callback(CurrentColor)
                    end)
                end)
                
                local ColorPicker = {}
                function ColorPicker:SetColor(color)
                    CurrentColor = color
                    Tween(ColorDisplay, {BackgroundColor3 = CurrentColor}, 0.2)
                end
                
                return ColorPicker
            end
            
            function Section:AddTextBox(options)
                options = options or {}
                local TextBoxName = options.Name or "TextBox"
                local Default = options.Default or ""
                local Placeholder = options.Placeholder or "Enter text..."
                local Callback = options.Callback or function() end
                
                local TextBoxFrame = Instance.new("Frame")
                TextBoxFrame.Name = TextBoxName
                TextBoxFrame.Size = UDim2.new(1, 0, 0, 60)
                TextBoxFrame.BackgroundColor3 = Theme.Secondary
                TextBoxFrame.BorderSizePixel = 0
                TextBoxFrame.Parent = SectionContainer
                
                local TextBoxCorner = Instance.new("UICorner")
                TextBoxCorner.CornerRadius = UDim.new(0, 8)
                TextBoxCorner.Parent = TextBoxFrame
                
                local TextBoxLabel = Instance.new("TextLabel")
                TextBoxLabel.Size = UDim2.new(1, -20, 0, 20)
                TextBoxLabel.Position = UDim2.new(0, 10, 0, 5)
                TextBoxLabel.BackgroundTransparency = 1
                TextBoxLabel.Text = TextBoxName
                TextBoxLabel.TextColor3 = Theme.Text
                TextBoxLabel.TextSize = 14
                TextBoxLabel.Font = Enum.Font.GothamMedium
                TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextBoxLabel.Parent = TextBoxFrame
                
                local TextBoxInput = Instance.new("TextBox")
                TextBoxInput.Size = UDim2.new(1, -20, 0, 30)
                TextBoxInput.Position = UDim2.new(0, 10, 0, 25)
                TextBoxInput.BackgroundColor3 = Theme.Primary
                TextBoxInput.Text = Default
                TextBoxInput.PlaceholderText = Placeholder
                TextBoxInput.TextColor3 = Theme.Text
                TextBoxInput.PlaceholderColor3 = Theme.SubText
                TextBoxInput.TextSize = 13
                TextBoxInput.Font = Enum.Font.Gotham
                TextBoxInput.BorderSizePixel = 0
                TextBoxInput.ClearTextOnFocus = false
                TextBoxInput.Parent = TextBoxFrame
                
                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 6)
                InputCorner.Parent = TextBoxInput
                
                TextBoxInput.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        pcall(function()
                            Callback(TextBoxInput.Text)
                        end)
                    end
                end)
                
                local TextBox = {}
                function TextBox:SetValue(text)
                    TextBoxInput.Text = text
                end
                
                return TextBox
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Intro Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.5, Enum.EasingStyle.Back)
    
    return Window
end

return ModernUI
