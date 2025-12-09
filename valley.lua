
-- / Locals
local Workspace = game:GetService("Workspace")
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

-- / Services
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGuiService = game:GetService("CoreGui")
local ContentService = game:GetService("ContentProvider")
local TeleportService = game:GetService("TeleportService")

-- / Tween table & function
local TweenTable = {
    Default = {
        TweenInfo.new(0.17, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
    }
}
local CreateTween = function(name, speed, style, direction, loop, reverse, delay)
    name = name
    speed = speed or 0.17
    style = style or Enum.EasingStyle.Sine
    direction = direction or Enum.EasingDirection.InOut
    loop = loop or 0
    reverse = reverse or false
    delay = delay or 0

    TweenTable[name] = TweenInfo.new(speed, style, direction, loop, reverse, delay)
end

-- / Dragging
local drag = function(obj, latency)
    obj = obj
    latency = latency or 0.06

    local toggled = nil
    local input = nil
    local start = nil
    local startPos = nil

    function updateInput(input)
        local Delta = input.Position - start
        local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        TweenService:Create(obj, TweenInfo.new(latency), {Position = Position}):Play()
    end

    obj.InputBegan:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
            toggled = true
            start = inp.Position
            startPos = obj.Position
            inp.Changed:Connect(function()
                if (inp.UserInputState == Enum.UserInputState.End) then
                    toggled = false
                end
            end)
        end
    end)

    obj.InputChanged:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            input = inp
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if (inp == input and toggled) then
            updateInput(inp)
        end
    end)
end

local library = {
    version = "2.0.2",
    title = title or "script " .. tostring(math.random(1,366)),
    fps = 0,
    rank = "private"
}
library.inputConnection = nil

coroutine.wrap(function()
    RunService.RenderStepped:Connect(function(v)
        library.fps =  math.round(1/v)
    end)
end)()

function library:RoundNumber(int, float)
    return tonumber(string.format("%." .. (int or 0) .. "f", float))
end

function library:GetUsername()
    return Player.Name
end

function library:CheckIfLoaded()
    if game:IsLoaded() then
        return true
    else
        return false
    end
end

function library:GetUserId()
    return Player.UserId
end

function library:GetPlaceId()
    return game.PlaceId
end

function library:GetJobId()
    return game.JobId
end

function library:Rejoin()
    TeleportService:TeleportToPlaceInstance(library:GetPlaceId(), library:GetJobId(), library:GetUserId())
end

function library:Copy(input) -- only works with synapse
    if syn then
        syn.write_clipboard(input)
    end
end

function library:GetDay(type)
    if type == "word" then -- day in a full word
        return os.date("%A")
    elseif type == "short" then -- day in a shortened word
        return os.date("%a")
    elseif type == "month" then -- day of the month in digits
        return os.date("%d")
    elseif type == "year" then -- day of the year in digits
        return os.date("%j")
    end
end

function library:GetTime(type)
    if type == "24h" then -- time using a 24 hour clock
        return os.date("%H")
    elseif type == "12h" then -- time using a 12 hour clock
        return os.date("%I")
    elseif type == "minute" then -- time in minutes
        return os.date("%M")
    elseif type == "half" then -- what part of the day it is (AM or PM)
        return os.date("%p")
    elseif type == "second" then -- time in seconds
        return os.date("%S")
    elseif type == "full" then -- full time
        return os.date("%X")
    elseif type == "ISO" then -- ISO / UTC ( 1min = 1, 1hour = 100)
        return os.date("%z")
    elseif type == "zone" then -- time zone
        return os.date("%Z") 
    end
end

function library:GetMonth(type)
    if type == "word" then -- full month name
        return os.date("%B")
    elseif type == "short" then -- month in shortened word
        return os.date("%b")
    elseif type == "digit" then -- the months digit
        return os.date("%m")
    end
end

function library:GetWeek(type)
    if type == "year_S" then -- the number of the week in the current year (sunday first day)
        return os.date("%U")
    elseif type == "day" then -- the week day
        return os.date("%w")
    elseif type == "year_M" then -- the number of the week in the current year (monday first day)
        return os.date("%W")
    end
end

function library:GetYear(type)
    if type == "digits" then -- the second 2 digits of the year
        return os.date("%y")
    elseif type == "full" then -- the full year
        return os.date("%Y")
    end
end

function library:UnlockFps(new) -- syn only
    if syn then
        setfpscap(new)
    end
end

function library:Watermark(text)
    for i,v in pairs(CoreGuiService:GetChildren()) do
        if v.Name == "watermark" then
            v:Destroy()
        end
    end

    tetx = text or "script"

    local watermark = Instance.new("ScreenGui")
    local watermarkPadding = Instance.new("UIPadding")
    local watermarkLayout = Instance.new("UIListLayout")
    local edge = Instance.new("Frame")
    local edgeCorner = Instance.new("UICorner")
    local background = Instance.new("Frame")
    local barFolder = Instance.new("Folder")
    local bar = Instance.new("Frame")
    local barCorner = Instance.new("UICorner")
    local barLayout = Instance.new("UIListLayout")
    local backgroundGradient = Instance.new("UIGradient")
    local backgroundCorner = Instance.new("UICorner")
    local waterText = Instance.new("TextLabel")
    local waterPadding = Instance.new("UIPadding")
    local backgroundLayout = Instance.new("UIListLayout")

    watermark.Name = "watermark"
    watermark.Parent = CoreGuiService
    watermark.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    watermarkLayout.Name = "watermarkLayout"
    watermarkLayout.Parent = watermark
    watermarkLayout.FillDirection = Enum.FillDirection.Horizontal
    watermarkLayout.SortOrder = Enum.SortOrder.LayoutOrder
    watermarkLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    watermarkLayout.Padding = UDim.new(0, 4)
    
    watermarkPadding.Name = "watermarkPadding"
    watermarkPadding.Parent = watermark
    watermarkPadding.PaddingBottom = UDim.new(0, 6)
    watermarkPadding.PaddingLeft = UDim.new(0, 6)

    edge.Name = "edge"
    edge.Parent = watermark
    edge.AnchorPoint = Vector2.new(0.5, 0.5)
    edge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    edge.Position = UDim2.new(0.5, 0, -0.03, 0)
    edge.Size = UDim2.new(0, 0, 0, 26)
    edge.BackgroundTransparency = 1

    edgeCorner.CornerRadius = UDim.new(0, 2)
    edgeCorner.Name = "edgeCorner"
    edgeCorner.Parent = edge

    background.Name = "background"
    background.Parent = edge
    background.AnchorPoint = Vector2.new(0.5, 0.5)
    background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    background.BackgroundTransparency = 1
    background.ClipsDescendants = true
    background.Position = UDim2.new(0.5, 0, 0.5, 0)
    background.Size = UDim2.new(0, 0, 0, 24)

    barFolder.Name = "barFolder"
    barFolder.Parent = background

    bar.Name = "bar"
    bar.Parent = barFolder
    bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    bar.BackgroundTransparency = 0
    bar.Size = UDim2.new(0, 0, 0, 1)

    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Name = "barCorner"
    barCorner.Parent = bar

    barLayout.Name = "barLayout"
    barLayout.Parent = barFolder
    barLayout.SortOrder = Enum.SortOrder.LayoutOrder

    backgroundGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    backgroundGradient.Rotation = 90
    backgroundGradient.Name = "backgroundGradient"
    backgroundGradient.Parent = background

    backgroundCorner.CornerRadius = UDim.new(0, 2)
    backgroundCorner.Name = "backgroundCorner"
    backgroundCorner.Parent = background

    waterText.Name = "notifText"
    waterText.Parent = background
    waterText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    waterText.BackgroundTransparency = 1.000
    waterText.Position = UDim2.new(0, 0, -0.0416666679, 0)
    waterText.Size = UDim2.new(0, 0, 0, 24)
    waterText.Font = Enum.Font.Code
    waterText.Text = text
    waterText.TextColor3 = Color3.fromRGB(198, 198, 198)
    waterText.TextTransparency = 1
    waterText.TextSize = 14.000
    waterText.RichText = true

    local NewSize = TextService:GetTextSize(waterText.Text, waterText.TextSize, waterText.Font, Vector2.new(math.huge, math.huge))
    waterText.Size = UDim2.new(0, NewSize.X + 8, 0, 24)

    waterPadding.Name = "notifPadding"
    waterPadding.Parent = waterText
    waterPadding.PaddingBottom = UDim.new(0, 4)
    waterPadding.PaddingLeft = UDim.new(0, 4)
    waterPadding.PaddingRight = UDim.new(0, 4)
    waterPadding.PaddingTop = UDim.new(0, 4)

    backgroundLayout.Name = "backgroundLayout"
    backgroundLayout.Parent = background
    backgroundLayout.SortOrder = Enum.SortOrder.LayoutOrder
    backgroundLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    CreateTween("wm", 0.24)
    CreateTween("wm_2", 0.04)
    coroutine.wrap(function()
        TweenService:Create(edge, TweenTable["wm"], {BackgroundTransparency = 0}):Play()
        TweenService:Create(edge, TweenTable["wm"], {Size = UDim2.new(0, NewSize.x + 10, 0, 26)}):Play()
        TweenService:Create(background, TweenTable["wm"], {BackgroundTransparency = 0}):Play()
        TweenService:Create(background, TweenTable["wm"], {Size = UDim2.new(0, NewSize.x + 8, 0, 24)}):Play()
        wait(.2)
        TweenService:Create(bar, TweenTable["wm"], {Size = UDim2.new(0, NewSize.x + 8, 0, 1)}):Play()
        wait(.1)
        TweenService:Create(waterText, TweenTable["wm"], {TextTransparency = 0}):Play()
    end)()

    local WatermarkFunctions = {}
    function WatermarkFunctions:AddWatermark(text)
        tetx = text or "script"

        local edge = Instance.new("Frame")
        local edgeCorner = Instance.new("UICorner")
        local background = Instance.new("Frame")
        local barFolder = Instance.new("Folder")
        local bar = Instance.new("Frame")
        local barCorner = Instance.new("UICorner")
        local barLayout = Instance.new("UIListLayout")
        local backgroundGradient = Instance.new("UIGradient")
        local backgroundCorner = Instance.new("UICorner")
        local waterText = Instance.new("TextLabel")
        local waterPadding = Instance.new("UIPadding")
        local backgroundLayout = Instance.new("UIListLayout")
    
        edge.Name = "edge"
        edge.Parent = watermark
        edge.AnchorPoint = Vector2.new(0.5, 0.5)
        edge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        edge.Position = UDim2.new(0.5, 0, -0.03, 0)
        edge.Size = UDim2.new(0, 0, 0, 26)
        edge.BackgroundTransparency = 1
    
        edgeCorner.CornerRadius = UDim.new(0, 2)
        edgeCorner.Name = "edgeCorner"
        edgeCorner.Parent = edge
    
        background.Name = "background"
        background.Parent = edge
        background.AnchorPoint = Vector2.new(0.5, 0.5)
        background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        background.BackgroundTransparency = 1
        background.ClipsDescendants = true
        background.Position = UDim2.new(0.5, 0, 0.5, 0)
        background.Size = UDim2.new(0, 0, 0, 24)
    
        barFolder.Name = "barFolder"
        barFolder.Parent = background
    
        bar.Name = "bar"
        bar.Parent = barFolder
        bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        bar.BackgroundTransparency = 0
        bar.Size = UDim2.new(0, 0, 0, 1)
    
        barCorner.CornerRadius = UDim.new(0, 2)
        barCorner.Name = "barCorner"
        barCorner.Parent = bar
    
        barLayout.Name = "barLayout"
        barLayout.Parent = barFolder
        barLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
        backgroundGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
        backgroundGradient.Rotation = 90
        backgroundGradient.Name = "backgroundGradient"
        backgroundGradient.Parent = background
    
        backgroundCorner.CornerRadius = UDim.new(0, 2)
        backgroundCorner.Name = "backgroundCorner"
        backgroundCorner.Parent = background
    
        waterText.Name = "notifText"
        waterText.Parent = background
        waterText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        waterText.BackgroundTransparency = 1.000
        waterText.Position = UDim2.new(0, 0, -0.0416666679, 0)
        waterText.Size = UDim2.new(0, 0, 0, 24)
        waterText.Font = Enum.Font.Code
        waterText.Text = text
        waterText.TextColor3 = Color3.fromRGB(198, 198, 198)
        waterText.TextTransparency = 1
        waterText.TextSize = 14.000
        waterText.RichText = true
    
        local NewSize = TextService:GetTextSize(waterText.Text, waterText.TextSize, waterText.Font, Vector2.new(math.huge, math.huge))
        waterText.Size = UDim2.new(0, NewSize.X + 8, 0, 24)
    
        waterPadding.Name = "notifPadding"
        waterPadding.Parent = waterText
        waterPadding.PaddingBottom = UDim.new(0, 4)
        waterPadding.PaddingLeft = UDim.new(0, 4)
        waterPadding.PaddingRight = UDim.new(0, 4)
        waterPadding.PaddingTop = UDim.new(0, 4)
    
        backgroundLayout.Name = "backgroundLayout"
        backgroundLayout.Parent = background
        backgroundLayout.SortOrder = Enum.SortOrder.LayoutOrder
        backgroundLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    
        coroutine.wrap(function()
            TweenService:Create(edge, TweenTable["wm"], {BackgroundTransparency = 0}):Play()
            TweenService:Create(edge, TweenTable["wm"], {Size = UDim2.new(0, NewSize.x + 10, 0, 26)}):Play()
            TweenService:Create(background, TweenTable["wm"], {BackgroundTransparency = 0}):Play()
            TweenService:Create(background, TweenTable["wm"], {Size = UDim2.new(0, NewSize.x + 8, 0, 24)}):Play()
            wait(.2)
            TweenService:Create(bar, TweenTable["wm"], {Size = UDim2.new(0, NewSize.x + 8, 0, 1)}):Play()
            wait(.1)
            TweenService:Create(waterText, TweenTable["wm"], {TextTransparency = 0}):Play()
        end)()

        local NewWatermarkFunctions = {}
        function NewWatermarkFunctions:Hide()
            edge.Visible = false
            return NewWatermarkFunctions
        end
        --
        function NewWatermarkFunctions:Show()
            edge.Visible = true
            return NewWatermarkFunctions
        end
        --
        function NewWatermarkFunctions:Text(new)
            new = new or text
            waterText.Text = new
    
            local NewSize = TextService:GetTextSize(waterText.Text, waterText.TextSize, waterText.Font, Vector2.new(math.huge, math.huge))
            waterText.Size = UDim2.new(0, NewSize.X + 8, 0, 24)
            coroutine.wrap(function()
                TweenService:Create(edge, TweenTable["wm_2"], {Size = UDim2.new(0, NewSize.x + 10, 0, 26)}):Play()
                TweenService:Create(background, TweenTable["wm_2"], {Size = UDim2.new(0, NewSize.x + 8, 0, 24)}):Play()
                TweenService:Create(bar, TweenTable["wm_2"], {Size = UDim2.new(0, NewSize.x + 8, 0, 1)}):Play()
                TweenService:Create(waterText, TweenTable["wm_2"], {Size = UDim2.new(0, NewSize.x + 8, 0, 1)}):Play()
            end)()
    
            return NewWatermarkFunctions
        end
        --
        function NewWatermarkFunctions:Remove()
            Watermark:Destroy()
            return NewWatermarkFunctions
        end
        return NewWatermarkFunctions
    end

    function WatermarkFunctions:Hide()
        edge.Visible = false
        return WatermarkFunctions
    end
    --
    function WatermarkFunctions:Show()
        edge.Visible = true
        return WatermarkFunctions
    end
    --
    function WatermarkFunctions:Text(new)
        new = new or text
        waterText.Text = new

        local NewSize = TextService:GetTextSize(waterText.Text, waterText.TextSize, waterText.Font, Vector2.new(math.huge, math.huge))
        coroutine.wrap(function()
            TweenService:Create(edge, TweenTable["wm_2"], {Size = UDim2.new(0, NewSize.x + 10, 0, 26)}):Play()
            TweenService:Create(background, TweenTable["wm_2"], {Size = UDim2.new(0, NewSize.x + 8, 0, 24)}):Play()
            TweenService:Create(bar, TweenTable["wm_2"], {Size = UDim2.new(0, NewSize.x + 8, 0, 1)}):Play()
            TweenService:Create(waterText, TweenTable["wm_2"], {Size = UDim2.new(0, NewSize.x + 8, 0, 1)}):Play()
        end)()

        return WatermarkFunctions
    end
    --
    function WatermarkFunctions:Remove()
        Watermark:Destroy()
        return WatermarkFunctions
    end
    return WatermarkFunctions
end

function library:InitNotifications(text, duration, callback)
    for i,v in next, CoreGuiService:GetChildren() do
        if v.name == "Notifications" then
            v:Destroy()
        end
    end

    local Notifications = Instance.new("ScreenGui")
    local notificationsLayout = Instance.new("UIListLayout")
    local notificationsPadding = Instance.new("UIPadding")

    Notifications.Name = "Notifications"
    Notifications.Parent = CoreGuiService
    Notifications.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    notificationsLayout.Name = "notificationsLayout"
    notificationsLayout.Parent = Notifications
    notificationsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notificationsLayout.Padding = UDim.new(0, 4)

    notificationsPadding.Name = "notificationsPadding"
    notificationsPadding.Parent = Notifications
    notificationsPadding.PaddingLeft = UDim.new(0, 6)
    notificationsPadding.PaddingTop = UDim.new(0, 18)

    local Notification = {}
    function Notification:Notify(text, duration, type, callback)
        
        CreateTween("notification_load", 0.2)

        text = text or "please wait."
        duration = duration or 5
        type = type or "notification"
        callback = callback or function() end

        local edge = Instance.new("Frame")
        local edgeCorner = Instance.new("UICorner")
        local background = Instance.new("Frame")
        local barFolder = Instance.new("Folder")
        local bar = Instance.new("Frame")
        local barCorner = Instance.new("UICorner")
        local barLayout = Instance.new("UIListLayout")
        local backgroundGradient = Instance.new("UIGradient")
        local backgroundCorner = Instance.new("UICorner")
        local notifText = Instance.new("TextLabel")
        local notifPadding = Instance.new("UIPadding")
        local backgroundLayout = Instance.new("UIListLayout")
    
        edge.Name = "edge"
        edge.Parent = Notifications
        edge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        edge.BackgroundTransparency = 1.000
        edge.Size = UDim2.new(0, 0, 0, 26)
    
        edgeCorner.CornerRadius = UDim.new(0, 2)
        edgeCorner.Name = "edgeCorner"
        edgeCorner.Parent = edge
    
        background.Name = "background"
        background.Parent = edge
        background.AnchorPoint = Vector2.new(0.5, 0.5)
        background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        background.BackgroundTransparency = 1.000
        background.ClipsDescendants = true
        background.Position = UDim2.new(0.5, 0, 0.5, 0)
        background.Size = UDim2.new(0, 0, 0, 24)
    
        barFolder.Name = "barFolder"
        barFolder.Parent = background
    
        bar.Name = "bar"
        bar.Parent = barFolder
        bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        bar.BackgroundTransparency = 0.200
        bar.Size = UDim2.new(0, 0, 0, 1)
        if type == "notification" then
            bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        elseif type == "alert" then
            bar.BackgroundColor3 = Color3.fromRGB(255, 246, 112)
        elseif type == "error" then
            bar.BackgroundColor3 = Color3.fromRGB(255, 74, 77)
        elseif type == "success" then
            bar.BackgroundColor3 = Color3.fromRGB(131, 255, 103)
        elseif type == "information" then
            bar.BackgroundColor3 = Color3.fromRGB(126, 117, 255)
        end
    
        barCorner.CornerRadius = UDim.new(0, 2)
        barCorner.Name = "barCorner"
        barCorner.Parent = bar
    
        barLayout.Name = "barLayout"
        barLayout.Parent = barFolder
        barLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
        backgroundGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
        backgroundGradient.Rotation = 90
        backgroundGradient.Name = "backgroundGradient"
        backgroundGradient.Parent = background
    
        backgroundCorner.CornerRadius = UDim.new(0, 2)
        backgroundCorner.Name = "backgroundCorner"
        backgroundCorner.Parent = background
    
        notifText.Name = "notifText"
        notifText.Parent = background
        notifText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        notifText.BackgroundTransparency = 1.000
        notifText.Size = UDim2.new(0, 230, 0, 26)
        notifText.Font = Enum.Font.Code
        notifText.Text = text
        notifText.TextColor3 = Color3.fromRGB(198, 198, 198)
        notifText.TextSize = 14.000
        notifText.TextTransparency = 1.000
        notifText.TextXAlignment = Enum.TextXAlignment.Left
        notifText.RichText = true
    
        notifPadding.Name = "notifPadding"
        notifPadding.Parent = notifText
        notifPadding.PaddingBottom = UDim.new(0, 4)
        notifPadding.PaddingLeft = UDim.new(0, 4)
        notifPadding.PaddingRight = UDim.new(0, 4)
        notifPadding.PaddingTop = UDim.new(0, 4)
    
        backgroundLayout.Name = "backgroundLayout"
        backgroundLayout.Parent = background
        backgroundLayout.SortOrder = Enum.SortOrder.LayoutOrder
        backgroundLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    
        local NewSize = TextService:GetTextSize(notifText.Text, notifText.TextSize, notifText.Font, Vector2.new(math.huge, math.huge))
        CreateTween("notification_wait", duration, Enum.EasingStyle.Quad)
        local IsRunning = false
        coroutine.wrap(function()
            IsRunning = true
            TweenService:Create(edge, TweenTable["notification_load"], {BackgroundTransparency = 0}):Play()
            TweenService:Create(background, TweenTable["notification_load"], {BackgroundTransparency = 0}):Play()
            TweenService:Create(notifText, TweenTable["notification_load"], {TextTransparency = 0}):Play()
            TweenService:Create(edge, TweenTable["notification_load"], {Size = UDim2.new(0, NewSize.X + 10, 0, 26)}):Play()
            TweenService:Create(background, TweenTable["notification_load"], {Size = UDim2.new(0, NewSize.X + 8, 0, 24)}):Play()
            TweenService:Create(notifText, TweenTable["notification_load"], {Size = UDim2.new(0, NewSize.X + 8, 0, 24)}):Play()
            wait()
            TweenService:Create(bar, TweenTable["notification_wait"], {Size = UDim2.new(0, NewSize.X + 8, 0, 1)}):Play()
            repeat wait() until bar.Size == UDim2.new(0, NewSize.X + 8, 0, 1)
            IsRunning = false
            TweenService:Create(edge, TweenTable["notification_load"], {BackgroundTransparency = 1}):Play()
            TweenService:Create(background, TweenTable["notification_load"], {BackgroundTransparency = 1}):Play()
            TweenService:Create(notifText, TweenTable["notification_load"], {TextTransparency = 1}):Play()
            TweenService:Create(bar, TweenTable["notification_load"], {BackgroundTransparency = 1}):Play()
            TweenService:Create(edge, TweenTable["notification_load"], {Size = UDim2.new(0, 0, 0, 26)}):Play()
            TweenService:Create(background, TweenTable["notification_load"], {Size = UDim2.new(0, 0, 0, 24)}):Play()
            TweenService:Create(notifText, TweenTable["notification_load"], {Size = UDim2.new(0, 0, 0, 24)}):Play()
            TweenService:Create(bar, TweenTable["notification_load"], {Size = UDim2.new(0, 0, 0, 1)}):Play()
            wait(.2)
            edge:Destroy()
        end)()

        CreateTween("notification_reset", 0.4)
        local NotificationFunctions = {}
        function NotificationFunctions:Text(new)
            new = new or text
            notifText.Text = new

            NewSize = TextService:GetTextSize(notifText.Text, notifText.TextSize, notifText.Font, Vector2.new(math.huge, math.huge))
            local NewSize_2 = NewSize
            if IsRunning then
                TweenService:Create(edge, TweenTable["notification_load"], {Size = UDim2.new(0, NewSize.X + 10, 0, 26)}):Play()
                TweenService:Create(background, TweenTable["notification_load"], {Size = UDim2.new(0, NewSize.X + 8, 0, 24)}):Play()
                TweenService:Create(notifText, TweenTable["notification_load"], {Size = UDim2.new(0, NewSize.X + 8, 0, 24)}):Play()
                wait()
                TweenService:Create(bar, TweenTable["notification_reset"], {Size = UDim2.new(0, 0, 0, 1)}):Play()
                wait(.4)
                TweenService:Create(bar, TweenTable["notification_wait"], {Size = UDim2.new(0, NewSize.X + 8, 0, 1)}):Play()
            end

            return NotificationFunctions
        end
        return NotificationFunctions
    end
    return Notification
end

function library:Init(key)
    for _,v in next, CoreGuiService:GetChildren() do
        if v.Name == "screen" then
            v:Destroy()
        end
    end

    local title = library.title
    key = key or Enum.KeyCode.RightAlt

    local screen = Instance.new("ScreenGui")
    local edge = Instance.new("Frame")
    local edgeCorner = Instance.new("UICorner")
    local background = Instance.new("Frame")
    local backgroundCorner = Instance.new("UICorner")
    local backgroundGradient = Instance.new("UIGradient")
    local headerLabel = Instance.new("TextLabel")
    local headerPadding = Instance.new("UIPadding")
    local barFolder = Instance.new("Folder")
    local bar = Instance.new("Frame")
    local barCorner = Instance.new("UICorner")
    local barLayout = Instance.new("UIListLayout")
    local tabButtonsEdge = Instance.new("Frame")
    local tabButtonCorner = Instance.new("UICorner")
    local tabButtons = Instance.new("Frame")
    local tabButtonCorner_2 = Instance.new("UICorner")
    local tabButtonsGradient = Instance.new("UIGradient")
    local tabButtonLayout = Instance.new("UIListLayout")
    local tabButtonPadding = Instance.new("UIPadding")
    local containerEdge = Instance.new("Frame")
    local tabButtonCorner_3 = Instance.new("UICorner")
    local container = Instance.new("Frame")
    local containerCorner = Instance.new("UICorner")
    local containerGradient = Instance.new("UIGradient")

    screen.Name = "screen"
    screen.Parent = CoreGuiService
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Detect mobile device
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local screenSize = workspace.CurrentCamera.ViewportSize
    
    edge.Name = "edge"
    edge.Parent = screen
    edge.AnchorPoint = Vector2.new(0.5, 0.5)
    edge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    edge.Position = UDim2.new(0.5, 0, 0.5, 0)
    edge.Size = UDim2.new(0, 594, 0, 406)

    -- Create toggle button for open/close
    local toggleBtn = Instance.new("TextButton")
    local toggleBtnCorner = Instance.new("UICorner")
    local toggleBtnGradient = Instance.new("UIGradient")
    
    toggleBtn.Name = "toggleBtn"
    toggleBtn.Parent = screen
    toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Font = Enum.Font.Code
    toggleBtn.Text = "☰"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
    toggleBtn.TextSize = 24
    toggleBtn.AutoButtonColor = false
    toggleBtn.ZIndex = 1000
    
    toggleBtnCorner.CornerRadius = UDim.new(0, 8)
    toggleBtnCorner.Parent = toggleBtn
    
    toggleBtnGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    toggleBtnGradient.Rotation = 90
    toggleBtnGradient.Parent = toggleBtn
    
    -- Make toggle button draggable
    drag(toggleBtn, 0.04)
    
    -- Toggle button functionality
    local menuVisible = true
    toggleBtn.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        edge.Visible = menuVisible
        toggleBtn.Text = menuVisible and "☰" or "✕"
    end)
    
    drag(edge, 0.04)
local uiToggled = true
local debounce = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == key then
        if debounce then return end
        debounce = true
        
        uiToggled = not uiToggled
        edge.Visible = uiToggled
        
        -- Small debounce to prevent double-triggering
        task.delay(0.1, function()
            debounce = false
        end)
    end
end)
    edgeCorner.CornerRadius = UDim.new(0, 2)
    edgeCorner.Name = "edgeCorner"
    edgeCorner.Parent = edge

    background.Name = "background"
    background.Parent = edge
    background.AnchorPoint = Vector2.new(0.5, 0.5)
    background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    background.Position = UDim2.new(0.5, 0, 0.5, 0)
    background.Size = UDim2.new(0, 592, 0, 404)
    background.ClipsDescendants = true

    backgroundCorner.CornerRadius = UDim.new(0, 2)
    backgroundCorner.Name = "backgroundCorner"
    backgroundCorner.Parent = background

    backgroundGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    backgroundGradient.Rotation = 90
    backgroundGradient.Name = "backgroundGradient"
    backgroundGradient.Parent = background

    headerLabel.Name = "headerLabel"
    headerLabel.Parent = background
    headerLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    headerLabel.BackgroundTransparency = 1.000
    headerLabel.Size = UDim2.new(0, 300, 0, 38)
    headerLabel.Font = Enum.Font.Code
    headerLabel.Text = title
    headerLabel.TextColor3 = Color3.fromRGB(198, 198, 198)
    headerLabel.TextSize = 16.000
    headerLabel.TextXAlignment = Enum.TextXAlignment.Left
    headerLabel.RichText = true

    headerPadding.Name = "headerPadding"
    headerPadding.Parent = headerLabel
    headerPadding.PaddingBottom = UDim.new(0, 6)
    headerPadding.PaddingLeft = UDim.new(0, 12)
    headerPadding.PaddingRight = UDim.new(0, 6)
    headerPadding.PaddingTop = UDim.new(0, 6)

    local urlLabel = Instance.new("TextLabel")
    local urlPadding = Instance.new("UIPadding")

    urlLabel.Name = "urlLabel"
    urlLabel.Parent = background
    urlLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    urlLabel.BackgroundTransparency = 1.000
    urlLabel.Position = UDim2.new(1, -280, 0, 0)
    urlLabel.Size = UDim2.new(0, 280, 0, 38)
    urlLabel.Font = Enum.Font.Code
    urlLabel.Text = "Url: Discord.gg/valleygg"
    urlLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    urlLabel.TextSize = 14.000
    urlLabel.TextXAlignment = Enum.TextXAlignment.Right
    urlLabel.RichText = true

    urlPadding.Name = "urlPadding"
    urlPadding.Parent = urlLabel
    urlPadding.PaddingBottom = UDim.new(0, 6)
    urlPadding.PaddingLeft = UDim.new(0, 6)
    urlPadding.PaddingRight = UDim.new(0, 12)
    urlPadding.PaddingTop = UDim.new(0, 6)

    barFolder.Name = "barFolder"
    barFolder.Parent = background

    bar.Name = "bar"
    bar.Parent = barFolder
    bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    bar.BackgroundTransparency = 0.200
    bar.Size = UDim2.new(0, 592, 0, 1)
    bar.BorderSizePixel = 0

    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Name = "barCorner"
    barCorner.Parent = bar

    barLayout.Name = "barLayout"
    barLayout.Parent = barFolder
    barLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    barLayout.SortOrder = Enum.SortOrder.LayoutOrder

    tabButtonsEdge.Name = "tabButtonsEdge"
    tabButtonsEdge.Parent = background
    tabButtonsEdge.AnchorPoint = Vector2.new(0.5, 0.5)
    tabButtonsEdge.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabButtonsEdge.Position = UDim2.new(0.1435, 0, 0.536000013, 0)
    tabButtonsEdge.Size = UDim2.new(0, 152, 0, 360)

    tabButtonCorner.CornerRadius = UDim.new(0, 2)
    tabButtonCorner.Name = "tabButtonCorner"
    tabButtonCorner.Parent = tabButtonsEdge

    tabButtons.Name = "tabButtons"
    tabButtons.Parent = tabButtonsEdge
    tabButtons.AnchorPoint = Vector2.new(0.5, 0.5)
    tabButtons.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    tabButtons.ClipsDescendants = true
    tabButtons.Position = UDim2.new(0.5, 0, 0.5, 0)
    tabButtons.Size = UDim2.new(0, 150, 0, 358)

    tabButtonCorner_2.CornerRadius = UDim.new(0, 2)
    tabButtonCorner_2.Name = "tabButtonCorner"
    tabButtonCorner_2.Parent = tabButtons

    tabButtonsGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    tabButtonsGradient.Rotation = 90
    tabButtonsGradient.Name = "tabButtonsGradient"
    tabButtonsGradient.Parent = tabButtons

    tabButtonLayout.Name = "tabButtonLayout"
    tabButtonLayout.Parent = tabButtons
    tabButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder

    tabButtonPadding.Name = "tabButtonPadding"
    tabButtonPadding.Parent = tabButtons
    tabButtonPadding.PaddingBottom = UDim.new(0, 4)
    tabButtonPadding.PaddingLeft = UDim.new(0, 4)
    tabButtonPadding.PaddingRight = UDim.new(0, 4)
    tabButtonPadding.PaddingTop = UDim.new(0, 4)

    containerEdge.Name = "containerEdge"
    containerEdge.Parent = background
    containerEdge.AnchorPoint = Vector2.new(0.5, 0.5)
    containerEdge.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    containerEdge.Position = UDim2.new(0.637000024, 0, 0.536000013, 0)
    containerEdge.Size = UDim2.new(0, 414, 0, 360)

    tabButtonCorner_3.CornerRadius = UDim.new(0, 2)
    tabButtonCorner_3.Name = "tabButtonCorner"
    tabButtonCorner_3.Parent = containerEdge

    container.Name = "container"
    container.Parent = containerEdge
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.Size = UDim2.new(0, 412, 0, 358)

    containerCorner.CornerRadius = UDim.new(0, 2)
    containerCorner.Name = "containerCorner"
    containerCorner.Parent = container

    containerGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    containerGradient.Rotation = 90
    containerGradient.Name = "containerGradient"
    containerGradient.Parent = container

    local TabLibrary = {
        IsFirst = true,
        CurrentTab = ""
    }
    CreateTween("tab_text_colour", 0.16)
    function TabLibrary:NewTab(title)
        title = title or "tab"

        local tabButton = Instance.new("TextButton")
        local page = Instance.new("ScrollingFrame")
        local pageLayout = Instance.new("UIListLayout")
        local pagePadding = Instance.new("UIPadding")

        tabButton.Name = "tabButton"
        tabButton.Parent = tabButtons
        tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundTransparency = 1.000
        tabButton.ClipsDescendants = true
        tabButton.Position = UDim2.new(-0.0281690136, 0, 0, 0)
        tabButton.Size = UDim2.new(0, 150, 0, 22)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.Code
        tabButton.Text = title
        tabButton.TextColor3 = Color3.fromRGB(170, 170, 170)
        tabButton.TextSize = 15.000
        tabButton.RichText = true

        page.Name = "page"
        page.Parent = container
        page.Active = true
        page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        page.BackgroundTransparency = 1.000
        page.BorderSizePixel = 0
        page.Size = UDim2.new(0, 412, 0, 358)
        page.BottomImage = "http://www.roblox.com/asset/?id=3062506202"
        page.MidImage = "http://www.roblox.com/asset/?id=3062506202"
        page.ScrollBarThickness = 1
        page.TopImage = "http://www.roblox.com/asset/?id=3062506202"
        page.ScrollBarImageColor3 = Color3.fromRGB(159, 115, 255)
        page.Visible = false
        
        pageLayout.Name = "pageLayout"
        pageLayout.Parent = page
        pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 4)

        pagePadding.Name = "pagePadding"
        pagePadding.Parent = page
        pagePadding.PaddingBottom = UDim.new(0, 6)
        pagePadding.PaddingLeft = UDim.new(0, 6)
        pagePadding.PaddingRight = UDim.new(0, 6)
        pagePadding.PaddingTop = UDim.new(0, 6)

        if TabLibrary.IsFirst then
            page.Visible = true
            tabButton.TextColor3 = Color3.fromRGB(159, 115, 255)
            TabLibrary.CurrentTab = title
        end
        
        tabButton.MouseButton1Click:Connect(function()
            TabLibrary.CurrentTab = title
            for i,v in pairs(container:GetChildren()) do 
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            page.Visible = true

            for i,v in pairs(tabButtons:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenTable["tab_text_colour"], {TextColor3 = Color3.fromRGB(170, 170, 170)}):Play()
                end
            end
            TweenService:Create(tabButton, TweenTable["tab_text_colour"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()
        end)

        local function UpdatePageSize()
            local correction = pageLayout.AbsoluteContentSize
            page.CanvasSize = UDim2.new(0, correction.X+13, 0, correction.Y+2000)
        end

        page.ChildAdded:Connect(UpdatePageSize)
        page.ChildRemoved:Connect(UpdatePageSize)

        TabLibrary.IsFirst = false

        CreateTween("hover", 0.16)
        local Components = {}
        function Components:NewLabel(text, alignment)
            text = text or "label"
            alignment = alignment or "left"

            local label = Instance.new("TextLabel")
            local labelPadding = Instance.new("UIPadding")

            label.Name = "label"
            label.Parent = page
            label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            label.BackgroundTransparency = 1.000
            label.Position = UDim2.new(0.00499999989, 0, 0, 0)
            label.Size = UDim2.new(0, 396, 0, 24)
            label.Font = Enum.Font.Code
            label.Text = text
            label.TextColor3 = Color3.fromRGB(190, 190, 190)
            label.TextSize = 14.000
            label.TextWrapped = true
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.RichText = true

            labelPadding.Name = "pagePadding"
            labelPadding.Parent = page
            labelPadding.PaddingBottom = UDim.new(0, 6)
            labelPadding.PaddingLeft = UDim.new(0, 12)
            labelPadding.PaddingRight = UDim.new(0, 6)
            labelPadding.PaddingTop = UDim.new(0, 6)

            if alignment:lower():find("le") then
                label.TextXAlignment = Enum.TextXAlignment.Left
            elseif alignment:lower():find("cent") then
                label.TextXAlignment = Enum.TextXAlignment.Center
            elseif alignment:lower():find("ri") then
                label.TextXAlignment = Enum.TextXAlignment.Right
            end

            UpdatePageSize()

            local LabelFunctions = {}
            function LabelFunctions:Text(text)
                text = text or "new label text"
                label.Text = text
                return LabelFunctions
            end
            --
            function LabelFunctions:Remove()
                label:Destroy()
                return LabelFunctions
            end
            --
            function LabelFunctions:Hide()
                label.Visible = false
                UpdatePageSize()
                return LabelFunctions
            end
            --
            function LabelFunctions:Show()
                label.Visible = true
                UpdatePageSize()
                return LabelFunctions
            end
            --
            function LabelFunctions:Align(new)
                new = new or "le"
                if new:lower():find("le") then
                    label.TextXAlignment = Enum.TextXAlignment.Left
                elseif new:lower():find("cent") then
                    label.TextXAlignment = Enum.TextXAlignment.Center
                elseif new:lower():find("ri") then
                    label.TextXAlignment = Enum.TextXAlignment.Right
                end
            end
            return LabelFunctions
        end

        function Components:NewButton(text, callback)
            text = text or "button"
            callback = callback or function() end

            local buttonFrame = Instance.new("Frame")
            local buttonLayout = Instance.new("UIListLayout")
            local button = Instance.new("TextButton")
            local buttonCorner = Instance.new("UICorner")
            local buttonBackground = Instance.new("Frame")
            local buttonGradient = Instance.new("UIGradient")
            local buttonBackCorner = Instance.new("UICorner")
            local buttonLabel = Instance.new("TextLabel")

            buttonFrame.Name = "buttonFrame"
            buttonFrame.Parent = page
            buttonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            buttonFrame.BackgroundTransparency = 1.000
            buttonFrame.Size = UDim2.new(0, 396, 0, 24)

            buttonLayout.Name = "buttonLayout"
            buttonLayout.Parent = buttonFrame
            buttonLayout.FillDirection = Enum.FillDirection.Horizontal
            buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
            buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            buttonLayout.Padding = UDim.new(0, 4)

            button.Name = "button"
            button.Parent = buttonFrame
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.Size = UDim2.new(0, 396, 0, 24)
            button.AutoButtonColor = false
            button.Font = Enum.Font.SourceSans
            button.Text = ""
            button.TextColor3 = Color3.fromRGB(0, 0, 0)
            button.TextSize = 14.000

            buttonCorner.CornerRadius = UDim.new(0, 2)
            buttonCorner.Name = "buttonCorner"
            buttonCorner.Parent = button

            buttonBackground.Name = "buttonBackground"
            buttonBackground.Parent = button
            buttonBackground.AnchorPoint = Vector2.new(0.5, 0.5)
            buttonBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            buttonBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
            buttonBackground.Size = UDim2.new(0, 394, 0, 22)

            buttonGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            buttonGradient.Rotation = 90
            buttonGradient.Name = "buttonGradient"
            buttonGradient.Parent = buttonBackground

            buttonBackCorner.CornerRadius = UDim.new(0, 2)
            buttonBackCorner.Name = "buttonBackCorner"
            buttonBackCorner.Parent = buttonBackground

            buttonLabel.Name = "buttonLabel"
            buttonLabel.Parent = buttonBackground
            buttonLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            buttonLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            buttonLabel.BackgroundTransparency = 1.000
            buttonLabel.ClipsDescendants = true
            buttonLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            buttonLabel.Size = UDim2.new(0, 394, 0, 22)
            buttonLabel.Font = Enum.Font.Code
            buttonLabel.Text = text
            buttonLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            buttonLabel.TextSize = 14.000
            buttonLabel.RichText = true

            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenTable["hover"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end)
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenTable["hover"], {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end)

            button.MouseButton1Down:Connect(function()
                TweenService:Create(buttonLabel, TweenTable["hover"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()
            end)
            button.MouseButton1Up:Connect(function()
                TweenService:Create(buttonLabel, TweenTable["hover"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
            end)

            button.MouseButton1Click:Connect(function()
                callback()
            end)

            local NewSizeX = 396
            local Amnt = 0
            local function ResizeButtons()
                local Amount = buttonFrame:GetChildren()
                local Resized = 396
                Amount = #Amount - 1
                Amnt = Amount
                local AmountToSubtract = (Amount / 2)
                Resized = (396 / Amount) - AmountToSubtract
                NewSizeX = (Resized)

                for i,v in pairs(buttonFrame:GetChildren()) do
                    if v:IsA("TextButton") then
                        v.Size = UDim2.new(0, Resized, 0, 24)
                        for z,x in pairs(v:GetDescendants()) do
                            if x:IsA("TextLabel") or x:IsA("Frame") then
                                x.Size = UDim2.new(0, Resized - 2, 0, 22)
                            end
                        end
                    end
                end
            end

            buttonFrame.ChildAdded:Connect(ResizeButtons)
            buttonFrame.ChildRemoved:Connect(ResizeButtons)

            UpdatePageSize()

            --
            local ButtonFunctions = {}
            function ButtonFunctions:AddButton(text, callback_2)
                if Amnt < 4 then
                    text = text or "button"
                    callback_2 = callback_2 or function() end
    
                    local button = Instance.new("TextButton")
                    local buttonCorner = Instance.new("UICorner")
                    local buttonBackground = Instance.new("Frame")
                    local buttonGradient = Instance.new("UIGradient")
                    local buttonBackCorner = Instance.new("UICorner")
                    local buttonLabel = Instance.new("TextLabel")
        
                    button.Name = "button"
                    button.Parent = buttonFrame
                    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    button.Size = UDim2.new(0, NewSizeX - Amnt, 0, 24)
                    button.AutoButtonColor = false
                    button.Font = Enum.Font.SourceSans
                    button.Text = ""
                    button.TextColor3 = Color3.fromRGB(0, 0, 0)
                    button.TextSize = 14.000
        
                    buttonCorner.CornerRadius = UDim.new(0, 2)
                    buttonCorner.Name = "buttonCorner"
                    buttonCorner.Parent = button
        
                    buttonBackground.Name = "buttonBackground"
                    buttonBackground.Parent = button
                    buttonBackground.AnchorPoint = Vector2.new(0.5, 0.5)
                    buttonBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    buttonBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
                    buttonBackground.Size = UDim2.new(0, (NewSizeX - 2) - Amnt, 0, 22)
        
                    buttonGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                    buttonGradient.Rotation = 90
                    buttonGradient.Name = "buttonGradient"
                    buttonGradient.Parent = buttonBackground
        
                    buttonBackCorner.CornerRadius = UDim.new(0, 2)
                    buttonBackCorner.Name = "buttonBackCorner"
                    buttonBackCorner.Parent = buttonBackground
        
                    buttonLabel.Name = "buttonLabel"
                    buttonLabel.Parent = buttonBackground
                    buttonLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                    buttonLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    buttonLabel.BackgroundTransparency = 1.000
                    buttonLabel.ClipsDescendants = true
                    buttonLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                    buttonLabel.Size = UDim2.new(0, NewSizeX - 2, 0, 22)
                    buttonLabel.Font = Enum.Font.Code
                    buttonLabel.Text = text
                    buttonLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
                    buttonLabel.TextSize = 14.000
                    buttonLabel.RichText = true

                    UpdatePageSize()
        
                    button.MouseEnter:Connect(function()
                        TweenService:Create(button, TweenTable["hover"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                    end)
                    button.MouseLeave:Connect(function()
                        TweenService:Create(button, TweenTable["hover"], {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                    end)
        
                    button.MouseButton1Down:Connect(function()
                        TweenService:Create(buttonLabel, TweenTable["hover"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                    end)
                    button.MouseButton1Up:Connect(function()
                        TweenService:Create(buttonLabel, TweenTable["hover"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
                    end)
        
                    button.MouseButton1Click:Connect(function()
                        callback_2()
                    end)

                    local ButtonFunctions2 = {}
                    function ButtonFunctions2:Fire()
                        callback_2()

                        return ButtonFunctions2
                    end
                    --
                    function ButtonFunctions2:Hide()
                        button.Visible = false

                        return ButtonFunctions2
                    end
                    --
                    function ButtonFunctions2:Show()
                        button.Visible = true

                        return ButtonFunctions2
                    end
                    --
                    function ButtonFunctions2:Text(text)
                        text = text or "button new text"
                        buttonLabel.Text = text

                        return ButtonFunctions2
                    end
                    --
                    function ButtonFunctions2:Remove()
                        button:Destroy()

                        return ButtonFunctions2
                    end
                    --
                    function ButtonFunctions2:SetFunction(new)
                        new = new or function() end
                        callback_2 = new

                        return ButtonFunctions2
                    end
                    return ButtonFunctions2 and ButtonFunctions
                elseif Amnt > 4 then
                    print("more than 4 buttons are not supported.")
                end
                return ButtonFunctions
            end
            --
            function ButtonFunctions:Fire()
                callback()

                return ButtonFunctions
            end
            --
            function ButtonFunctions:Hide()
                button.Visible = false

                return ButtonFunctions
            end
            --
            function ButtonFunctions:Show()
                button.Visible = true

                return ButtonFunctions
            end
            --
            function ButtonFunctions:Text(text)
                text = text or "button new text"
                buttonLabel.Text = text

                return ButtonFunctions
            end
            --
            function ButtonFunctions:Remove()
                button:Destroy()

                return ButtonFunctions
            end
            --
            function ButtonFunctions:SetFunction(new)
                new = new or function() end
                callback = new

                return ButtonFunctions
            end
            --
            function ButtonFunctions:AddColorPicker(defaultColor, colorCallback)
                defaultColor = defaultColor or Color3.fromRGB(159, 115, 255)
                colorCallback = colorCallback or function() end

                local colorPreview = Instance.new("Frame")
                local colorPreviewCorner = Instance.new("UICorner")

                colorPreview.Name = "colorPreview"
                colorPreview.Parent = buttonBackground
                colorPreview.AnchorPoint = Vector2.new(1, 0.5)
                colorPreview.BackgroundColor3 = defaultColor
                colorPreview.Position = UDim2.new(1, -4, 0.5, 0)
                colorPreview.Size = UDim2.new(0, 18, 0, 18)
                colorPreview.ZIndex = 5

                colorPreviewCorner.CornerRadius = UDim.new(0, 2)
                colorPreviewCorner.Parent = colorPreview

                local colorPickerFrame = Instance.new("Frame")
                local colorPickerCorner = Instance.new("UICorner")
                local colorPickerGradient = Instance.new("UIGradient")
                local saturationFrame = Instance.new("Frame")
                local saturationCorner = Instance.new("UICorner")
                local hueSlider = Instance.new("Frame")
                local hueSliderCorner = Instance.new("UICorner")

                colorPickerFrame.Name = "colorPickerFrame"
                colorPickerFrame.Parent = buttonFrame
                colorPickerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                colorPickerFrame.Position = UDim2.new(0, 0, 1, 2)
                colorPickerFrame.Size = UDim2.new(0, 396, 0, 0)
                colorPickerFrame.ClipsDescendants = true
                colorPickerFrame.Visible = false
                colorPickerFrame.ZIndex = 500

                colorPickerCorner.CornerRadius = UDim.new(0, 2)
                colorPickerCorner.Parent = colorPickerFrame

                colorPickerGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                colorPickerGradient.Rotation = 90
                colorPickerGradient.Parent = colorPickerFrame

                saturationFrame.Name = "saturationFrame"
                saturationFrame.Parent = colorPickerFrame
                saturationFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                saturationFrame.Position = UDim2.new(0, 10, 0, 10)
                saturationFrame.Size = UDim2.new(0, 340, 0, 140)
                saturationFrame.ZIndex = 501

                saturationCorner.CornerRadius = UDim.new(0, 2)
                saturationCorner.Parent = saturationFrame

                local satWhite = Instance.new("Frame")
                satWhite.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                satWhite.Size = UDim2.new(1, 0, 1, 0)
                satWhite.ZIndex = 502
                satWhite.Parent = saturationFrame
                local satWhiteCorner = Instance.new("UICorner")
                satWhiteCorner.CornerRadius = UDim.new(0, 2)
                satWhiteCorner.Parent = satWhite
                local satWhiteGradient = Instance.new("UIGradient")
                satWhiteGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
                satWhiteGradient.Rotation = 0
                satWhiteGradient.Parent = satWhite

                local satBlack = Instance.new("Frame")
                satBlack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                satBlack.Size = UDim2.new(1, 0, 1, 0)
                satBlack.ZIndex = 503
                satBlack.Parent = saturationFrame
                local satBlackCorner = Instance.new("UICorner")
                satBlackCorner.CornerRadius = UDim.new(0, 2)
                satBlackCorner.Parent = satBlack
                local satBlackGradient = Instance.new("UIGradient")
                satBlackGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
                satBlackGradient.Rotation = 90
                satBlackGradient.Parent = satBlack

                local saturationButton = Instance.new("TextButton")
                saturationButton.Parent = saturationFrame
                saturationButton.BackgroundTransparency = 1
                saturationButton.Size = UDim2.new(1, 0, 1, 0)
                saturationButton.Text = ""
                saturationButton.ZIndex = 504

                hueSlider.Name = "hueSlider"
                hueSlider.Parent = colorPickerFrame
                hueSlider.Position = UDim2.new(0, 360, 0, 10)
                hueSlider.Size = UDim2.new(0, 26, 0, 140)
                hueSlider.ZIndex = 501

                hueSliderCorner.CornerRadius = UDim.new(0, 2)
                hueSliderCorner.Parent = hueSlider

                local hueGradient = Instance.new("UIGradient")
                hueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }
                hueGradient.Rotation = 90
                hueGradient.Parent = hueSlider

                local hueSliderButton = Instance.new("TextButton")
                hueSliderButton.Parent = hueSlider
                hueSliderButton.BackgroundTransparency = 1
                hueSliderButton.Size = UDim2.new(1, 0, 1, 0)
                hueSliderButton.Text = ""
                hueSliderButton.ZIndex = 502

                local hue, sat, val = Color3.toHSV(defaultColor)
                local selectedColor = defaultColor
                local isOpen = false

                local function updateColor()
                    selectedColor = Color3.fromHSV(hue, sat, val)
                    colorPreview.BackgroundColor3 = selectedColor
                    saturationFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                    colorCallback(selectedColor)
                end

                local function togglePicker()
                    isOpen = not isOpen
                    colorPickerFrame.Visible = true
                    local targetHeight = isOpen and 160 or 0
                    TweenService:Create(colorPickerFrame, TweenTable["colorpicker"] or TweenInfo.new(0.2), {Size = UDim2.new(0, 396, 0, targetHeight)}):Play()
                    if not isOpen then
                        wait(0.2)
                        colorPickerFrame.Visible = false
                    end
                end

                colorPreview.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        togglePicker()
                    end
                end)

                local hueDragging = false
                hueSliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = true
                        local function update()
                            local mousePos = UserInputService:GetMouseLocation().Y
                            local relativePos = math.clamp((mousePos - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                            hue = relativePos
                            updateColor()
                        end
                        update()
                        local moveConn
                        moveConn = UserInputService.InputChanged:Connect(function(inp)
                            if hueDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                                update()
                            end
                        end)
                        local releaseConn
                        releaseConn = UserInputService.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                                hueDragging = false
                                moveConn:Disconnect()
                                releaseConn:Disconnect()
                            end
                        end)
                    end
                end)

                local satDragging = false
                saturationButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        satDragging = true
                        local function update()
                            local mousePos = UserInputService:GetMouseLocation()
                            local relativeX = math.clamp((mousePos.X - saturationFrame.AbsolutePosition.X) / saturationFrame.AbsoluteSize.X, 0, 1)
                            local relativeY = math.clamp((mousePos.Y - saturationFrame.AbsolutePosition.Y) / saturationFrame.AbsoluteSize.Y, 0, 1)
                            sat = relativeX
                            val = 1 - relativeY
                            updateColor()
                        end
                        update()
                        local moveConn
                        moveConn = UserInputService.InputChanged:Connect(function(inp)
                            if satDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                                update()
                            end
                        end)
                        local releaseConn
                        releaseConn = UserInputService.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                                satDragging = false
                                moveConn:Disconnect()
                                releaseConn:Disconnect()
                            end
                        end)
                    end
                end)

                return ButtonFunctions
            end
            return ButtonFunctions
        end
        --

        function Components:NewSection(text)
            text = text or "section"

            local sectionFrame = Instance.new("Frame")
            local sectionLayout = Instance.new("UIListLayout")
            local leftBar = Instance.new("Frame")
            local sectionLabel = Instance.new("TextLabel")
            local sectionPadding = Instance.new("UIPadding")
            local rightBar = Instance.new("Frame")

            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = page
            sectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sectionFrame.BackgroundTransparency = 1.000
            sectionFrame.ClipsDescendants = true
            sectionFrame.Size = UDim2.new(0, 396, 0, 18)

            sectionLayout.Name = "sectionLayout"
            sectionLayout.Parent = sectionFrame
            sectionLayout.FillDirection = Enum.FillDirection.Horizontal
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            sectionLayout.Padding = UDim.new(0, 4)


            sectionLabel.Name = "sectionLabel"
            sectionLabel.Parent = sectionFrame
            sectionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sectionLabel.BackgroundTransparency = 1.000
            sectionLabel.ClipsDescendants = true
            sectionLabel.Position = UDim2.new(0.0252525248, 0, 0.020833334, 0)
            sectionLabel.Size = UDim2.new(0, 0, 0, 18)
            sectionLabel.Font = Enum.Font.Code
            sectionLabel.LineHeight = 1
            sectionLabel.Text = text
            sectionLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            sectionLabel.TextSize = 14.000
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.RichText = true

            sectionPadding.Name = "sectionPadding"
            sectionPadding.Parent = sectionLabel
            sectionPadding.PaddingBottom = UDim.new(0, 6)
            sectionPadding.PaddingLeft = UDim.new(0, 0)
            sectionPadding.PaddingRight = UDim.new(0, 6)
            sectionPadding.PaddingTop = UDim.new(0, 6)

            rightBar.Name = "rightBar"
            rightBar.Parent = sectionFrame
            rightBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            rightBar.BorderSizePixel = 0
            rightBar.Position = UDim2.new(0.308080822, 0, 0.479166657, 0)
            rightBar.Size = UDim2.new(0, 403, 0, 1)
            UpdatePageSize()

            local NewSectionSize = TextService:GetTextSize(sectionLabel.Text, sectionLabel.TextSize, sectionLabel.Font, Vector2.new(math.huge,math.huge))
            sectionLabel.Size = UDim2.new(0, NewSectionSize.X, 0, 18)

            local SectionFunctions = {}
            function SectionFunctions:Text(new)
                new = new or text
                sectionLabel.Text = new

                local NewSectionSize = TextService:GetTextSize(sectionLabel.Text, sectionLabel.TextSize, sectionLabel.Font, Vector2.new(math.huge,math.huge))
                sectionLabel.Size = UDim2.new(0, NewSectionSize.X, 0, 18)

                return SectionFunctions
            end
            function SectionFunctions:Hide()
                sectionFrame.Visible = false
                return SectionFunctions
            end
            function SectionFunctions:Show()
                sectionFrame.Visible = true
                return SectionFunctions
            end
            function SectionFunctions:Remove()
                sectionFrame:Destroy()
                return SectionFunctions
            end
            --
            return SectionFunctions
        end

        --

        function Components:NewToggle(text, default, callback)
            text = text or "toggle"
            default = default or false
            callback = callback or function() end

            local toggleButton = Instance.new("TextButton")
            local toggleLayout = Instance.new("UIListLayout")
            local toggleEdge = Instance.new("Frame")
            local toggleEdgeCorner = Instance.new("UICorner")
            local toggle = Instance.new("Frame")
            local toggleCorner = Instance.new("UICorner")
            local toggleGradient = Instance.new("UIGradient")
            local toggleDesign = Instance.new("Frame")
            local toggleDesignCorner = Instance.new("UICorner")
            local toggleDesignGradient = Instance.new("UIGradient")
            local toggleLabel = Instance.new("TextLabel")
            local toggleLabelPadding = Instance.new("UIPadding")
            local Extras = Instance.new("Folder")
            local ExtrasLayout = Instance.new("UIListLayout")

            toggleButton.Name = "toggleButton"
            toggleButton.Parent = page
            toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleButton.BackgroundTransparency = 1.000
            toggleButton.ClipsDescendants = false
            toggleButton.Size = UDim2.new(0, 396, 0, 22)
            toggleButton.Font = Enum.Font.Code
            toggleButton.Text = ""
            toggleButton.TextColor3 = Color3.fromRGB(190, 190, 190)
            toggleButton.TextSize = 14.000
            toggleButton.TextXAlignment = Enum.TextXAlignment.Left

            toggleLayout.Name = "toggleLayout"
            toggleLayout.Parent = toggleButton
            toggleLayout.FillDirection = Enum.FillDirection.Horizontal
            toggleLayout.SortOrder = Enum.SortOrder.LayoutOrder
            toggleLayout.VerticalAlignment = Enum.VerticalAlignment.Center

            toggleEdge.Name = "toggleEdge"
            toggleEdge.Parent = toggleButton
            toggleEdge.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggleEdge.Size = UDim2.new(0, 18, 0, 18)

            toggleEdgeCorner.CornerRadius = UDim.new(0, 2)
            toggleEdgeCorner.Name = "toggleEdgeCorner"
            toggleEdgeCorner.Parent = toggleEdge

            toggle.Name = "toggle"
            toggle.Parent = toggleEdge
            toggle.AnchorPoint = Vector2.new(0.5, 0.5)
            toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggle.Position = UDim2.new(0.5, 0, 0.5, 0)
            toggle.Size = UDim2.new(0, 16, 0, 16)

            toggleCorner.CornerRadius = UDim.new(0, 2)
            toggleCorner.Name = "toggleCorner"
            toggleCorner.Parent = toggle

            toggleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            toggleGradient.Rotation = 90
            toggleGradient.Name = "toggleGradient"
            toggleGradient.Parent = toggle

            toggleDesign.Name = "toggleDesign"
            toggleDesign.Parent = toggle
            toggleDesign.AnchorPoint = Vector2.new(0.5, 0.5)
            toggleDesign.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleDesign.BackgroundTransparency = 1.000
            toggleDesign.Position = UDim2.new(0.5, 0, 0.5, 0)

            toggleDesignCorner.CornerRadius = UDim.new(0, 2)
            toggleDesignCorner.Name = "toggleDesignCorner"
            toggleDesignCorner.Parent = toggleDesign

            toggleDesignGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(157, 115, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(106, 69, 181))}
            toggleDesignGradient.Rotation = 90
            toggleDesignGradient.Name = "toggleDesignGradient"
            toggleDesignGradient.Parent = toggleDesign

            toggleLabel.Name = "toggleLabel"
            toggleLabel.Parent = toggleButton
            toggleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleLabel.BackgroundTransparency = 1.000
            toggleLabel.Position = UDim2.new(0.0454545468, 0, 0, 0)
            toggleLabel.Size = UDim2.new(0, 377, 0, 22)
            toggleLabel.Font = Enum.Font.Code
            toggleLabel.LineHeight = 1.150
            toggleLabel.Text = text
            toggleLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            toggleLabel.TextSize = 14.000
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.RichText = true

            toggleLabelPadding.Name = "toggleLabelPadding"
            toggleLabelPadding.Parent = toggleLabel
            toggleLabelPadding.PaddingLeft = UDim.new(0, 6)

            Extras.Name = "Extras"
            Extras.Parent = toggleButton

            ExtrasLayout.Name = "ExtrasLayout"
            ExtrasLayout.Parent = Extras
            ExtrasLayout.FillDirection = Enum.FillDirection.Horizontal
            ExtrasLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            ExtrasLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ExtrasLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            ExtrasLayout.Padding = UDim.new(0, 2)

            local NewToggleLabelSize = TextService:GetTextSize(toggleLabel.Text, toggleLabel.TextSize, toggleLabel.Font, Vector2.new(math.huge,math.huge))
            toggleLabel.Size = UDim2.new(0, NewToggleLabelSize.X + 6, 0, 22)

            toggleButton.MouseEnter:Connect(function()
                TweenService:Create(toggleLabel, TweenTable["hover"], {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
            end)
            toggleButton.MouseLeave:Connect(function()
                TweenService:Create(toggleLabel, TweenTable["hover"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
            end)

            CreateTween("toggle_form", 0.13)
            local On = default
            if default then
                On = true
            else
                On = false
            end
            toggleButton.MouseButton1Click:Connect(function()
                On = not On
                local SizeOn = On and UDim2.new(0, 12, 0, 12) or UDim2.new(0, 0, 0, 0)
                local Transparency = On and 0 or 1
                TweenService:Create(toggleDesign, TweenTable["toggle_form"], {Size = SizeOn}):Play()
                TweenService:Create(toggleDesign, TweenTable["toggle_form"], {BackgroundTransparency = Transparency}):Play()
                callback(On)
            end)

            local ToggleFunctions = {}
            function ToggleFunctions:Text(new)
                new = new or text
                toggleLabel.Text = new
                return ToggleFunctions
            end
            --
            function ToggleFunctions:Hide()
                toggleButton.Visible = false
                return ToggleFunctions
            end
            --
            function ToggleFunctions:Show()
                toggleButton.Visible = true
                return ToggleFunctions
            end   
            --         
            function ToggleFunctions:Change()
                On = not On
                local SizeOn = On and UDim2.new(0, 12, 0, 12) or UDim2.new(0, 0, 0, 0)
                local Transparency = On and 0 or 1
                TweenService:Create(toggleDesign, TweenTable["toggle_form"], {Size = SizeOn}):Play()
                TweenService:Create(toggleDesign, TweenTable["toggle_form"], {BackgroundTransparency = Transparency}):Play()
                callback(On)
                return ToggleFunctions
            end
            --
            function ToggleFunctions:Remove()
                toggleButton:Destroy()
                return ToggleFunction
            end
            --
            function ToggleFunctions:Set(state)
                On = state
                local SizeOn = On and UDim2.new(0, 12, 0, 12) or UDim2.new(0, 0, 0, 0)
                local Transparency = On and 0 or 1
                TweenService:Create(toggleDesign, TweenTable["toggle_form"], {Size = SizeOn}):Play()
                TweenService:Create(toggleDesign, TweenTable["toggle_form"], {BackgroundTransparency = Transparency}):Play()
                callback(On)
                return ToggleFunctions
            end
            --
            local callback_t
            function ToggleFunctions:SetFunction(new)
                new = new or function() end
                callback = new
                callback_t = new
                return ToggleFunctions
            end
            UpdatePageSize()
            --
            function ToggleFunctions:AddKeybind(default_t)
                callback_t = callback
                default_t = default_t or Enum.KeyCode.P
                
                local keybind = Instance.new("TextButton")
                local keybindCorner = Instance.new("UICorner")
                local keybindBackground = Instance.new("Frame")
                local keybindGradient = Instance.new("UIGradient")
                local keybindBackCorner = Instance.new("UICorner")
                local keybindButtonLabel = Instance.new("TextLabel")
                local keybindLabelStraint = Instance.new("UISizeConstraint")
                local keybindBackgroundStraint = Instance.new("UISizeConstraint")
                local keybindStraint = Instance.new("UISizeConstraint")

                keybind.Name = "keybind"
                keybind.Parent = Extras
                keybind.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                keybind.Position = UDim2.new(0.780303001, 0, 0, 0)
                keybind.Size = UDim2.new(0, 87, 0, 22)
                keybind.AutoButtonColor = false
                keybind.Font = Enum.Font.SourceSans
                keybind.Text = ""
                keybind.TextColor3 = Color3.fromRGB(0, 0, 0)
                keybind.TextSize = 14.000
                keybind.Active = false
    
                keybindCorner.CornerRadius = UDim.new(0, 2)
                keybindCorner.Name = "keybindCorner"
                keybindCorner.Parent = keybind
    
                keybindBackground.Name = "keybindBackground"
                keybindBackground.Parent = keybind
                keybindBackground.AnchorPoint = Vector2.new(0.5, 0.5)
                keybindBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                keybindBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
                keybindBackground.Size = UDim2.new(0, 85, 0, 20)
    
                keybindGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                keybindGradient.Rotation = 90
                keybindGradient.Name = "keybindGradient"
                keybindGradient.Parent = keybindBackground
    
                keybindBackCorner.CornerRadius = UDim.new(0, 2)
                keybindBackCorner.Name = "keybindBackCorner"
                keybindBackCorner.Parent = keybindBackground
    
                keybindButtonLabel.Name = "keybindButtonLabel"
                keybindButtonLabel.Parent = keybindBackground
                keybindButtonLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                keybindButtonLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                keybindButtonLabel.BackgroundTransparency = 1.000
                keybindButtonLabel.ClipsDescendants = true
                keybindButtonLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                keybindButtonLabel.Size = UDim2.new(0, 85, 0, 20)
                keybindButtonLabel.Font = Enum.Font.Code
                keybindButtonLabel.Text = ". . ."
                keybindButtonLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
                keybindButtonLabel.TextSize = 14.000
                keybindButtonLabel.RichText = true
    
                keybindLabelStraint.Name = "keybindLabelStraint"
                keybindLabelStraint.Parent = keybindButtonLabel
                keybindLabelStraint.MinSize = Vector2.new(28, 20)
    
                keybindBackgroundStraint.Name = "keybindBackgroundStraint"
                keybindBackgroundStraint.Parent = keybindBackground
                keybindBackgroundStraint.MinSize = Vector2.new(28, 20)
    
                keybindStraint.Name = "keybindStraint"
                keybindStraint.Parent = keybind
                keybindStraint.MinSize = Vector2.new(30, 22)
    
                local Shortcuts = {
                    Return = "enter"
                }
    
                keybindButtonLabel.Text = Shortcuts[default_t.Name] or default_t.Name
                CreateTween("keybind", 0.08)
                
                local NewKeybindSize = TextService:GetTextSize(keybindButtonLabel.Text, keybindButtonLabel.TextSize, keybindButtonLabel.Font, Vector2.new(math.huge,math.huge))
                keybindButtonLabel.Size = UDim2.new(0, NewKeybindSize.X + 6, 0, 20)
                keybindBackground.Size = UDim2.new(0, NewKeybindSize.X + 6, 0, 20)
                keybind.Size = UDim2.new(0, NewKeybindSize.X + 8, 0, 22)
                
                function ResizeKeybind()
                    NewKeybindSize = TextService:GetTextSize(keybindButtonLabel.Text, keybindButtonLabel.TextSize, keybindButtonLabel.Font, Vector2.new(math.huge,math.huge))
                    TweenService:Create(keybindButtonLabel, TweenTable["keybind"], {Size = UDim2.new(0, NewKeybindSize.X + 6, 0, 20)}):Play()
                    TweenService:Create(keybindBackground, TweenTable["keybind"], {Size = UDim2.new(0, NewKeybindSize.X + 6, 0, 20)}):Play()
                    TweenService:Create(keybind, TweenTable["keybind"], {Size = UDim2.new(0, NewKeybindSize.X + 8, 0, 22)}):Play()
                end
                keybindButtonLabel:GetPropertyChangedSignal("Text"):Connect(ResizeKeybind)
                ResizeKeybind()
                UpdatePageSize()
    
                local ChosenKey = default_t.Name
    
                keybind.MouseButton1Click:Connect(function()
                    keybindButtonLabel.Text = ". . ."
                    local InputWait = UserInputService.InputBegan:wait()
                    if UserInputService.WindowFocused and InputWait.KeyCode.Name ~= "Unknown" then
                        local Result = Shortcuts[InputWait.KeyCode.Name] or InputWait.KeyCode.Name
                        keybindButtonLabel.Text = Result
                        ChosenKey = InputWait.KeyCode.Name
                    end
                end)
    
                local ChatTextBox = Player.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar
                if UserInputService.WindowFocused then
                    UserInputService.InputBegan:Connect(function(c, p)
                        if not p then
                            if c.KeyCode.Name == ChosenKey and not ChatTextBox:IsFocused() then
                                On = not On
                                local SizeOn = On and UDim2.new(0, 12, 0, 12) or UDim2.new(0, 0, 0, 0)
                                local Transparency = On and 0 or 1
                                TweenService:Create(toggleDesign, TweenTable["toggle_form"], {Size = SizeOn}):Play()
                                TweenService:Create(toggleDesign, TweenTable["toggle_form"], {BackgroundTransparency = Transparency}):Play()
                                callback_t(On)
                                return
                            end
                        end
                    end)
                end
    
                local ExtraKeybindFunctions = {}
                function ExtraKeybindFunctions:SetKey(new)
                    new = new or ChosenKey.Name
                    ChosenKey = new.Name
                    keybindButtonLabel.Text = new.Name
                    return ExtraKeybindFunctions
                end
                --
                function ExtraKeybindFunctions:Fire()
                    callback_t(ChosenKey)
                    return ExtraKeybindFunctions
                end
                --
                function ExtraKeybindFunctions:SetFunction(new)
                    new = new or function() end
                    callback_t = new
                    return ExtraKeybindFunctions 
                end
                --
                function ExtraKeybindFunctions:Hide()
                    keybindFrame.Visible = false
                    return ExtraKeybindFunctions
                end
                --
                function ExtraKeybindFunctions:Show()
                    keybindFrame.Visible = true
                    return ExtraKeybindFunctions
                end
                return ExtraKeybindFunctions and ToggleFunctions
            end

            function ToggleFunctions:AddColorPicker(defaultColor, colorCallback)
                defaultColor = defaultColor or Color3.fromRGB(159, 115, 255)
                colorCallback = colorCallback or function() end

                local colorPreview = Instance.new("Frame")
                local colorPreviewCorner = Instance.new("UICorner")

                colorPreview.Name = "colorPreview"
                colorPreview.Parent = Extras
                colorPreview.BackgroundColor3 = defaultColor
                colorPreview.Size = UDim2.new(0, 22, 0, 18)
                colorPreview.ZIndex = 5

                colorPreviewCorner.CornerRadius = UDim.new(0, 2)
                colorPreviewCorner.Parent = colorPreview

                local colorPickerFrame = Instance.new("Frame")
                local colorPickerCorner = Instance.new("UICorner")
                local colorPickerGradient = Instance.new("UIGradient")
                local saturationFrame = Instance.new("Frame")
                local saturationCorner = Instance.new("UICorner")
                local hueSlider = Instance.new("Frame")
                local hueSliderCorner = Instance.new("UICorner")

                colorPickerFrame.Name = "colorPickerFrame"
                colorPickerFrame.Parent = toggleButton
                colorPickerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                colorPickerFrame.Position = UDim2.new(0, 0, 1, 2)
                colorPickerFrame.Size = UDim2.new(0, 396, 0, 0)
                colorPickerFrame.ClipsDescendants = true
                colorPickerFrame.Visible = false
                colorPickerFrame.ZIndex = 500

                colorPickerCorner.CornerRadius = UDim.new(0, 2)
                colorPickerCorner.Parent = colorPickerFrame

                colorPickerGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                colorPickerGradient.Rotation = 90
                colorPickerGradient.Parent = colorPickerFrame

                saturationFrame.Name = "saturationFrame"
                saturationFrame.Parent = colorPickerFrame
                saturationFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                saturationFrame.Position = UDim2.new(0, 10, 0, 10)
                saturationFrame.Size = UDim2.new(0, 340, 0, 140)
                saturationFrame.ZIndex = 501

                saturationCorner.CornerRadius = UDim.new(0, 2)
                saturationCorner.Parent = saturationFrame

                local satWhite = Instance.new("Frame")
                satWhite.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                satWhite.Size = UDim2.new(1, 0, 1, 0)
                satWhite.ZIndex = 502
                satWhite.Parent = saturationFrame
                local satWhiteCorner = Instance.new("UICorner")
                satWhiteCorner.CornerRadius = UDim.new(0, 2)
                satWhiteCorner.Parent = satWhite
                local satWhiteGradient = Instance.new("UIGradient")
                satWhiteGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
                satWhiteGradient.Rotation = 0
                satWhiteGradient.Parent = satWhite

                local satBlack = Instance.new("Frame")
                satBlack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                satBlack.Size = UDim2.new(1, 0, 1, 0)
                satBlack.ZIndex = 503
                satBlack.Parent = saturationFrame
                local satBlackCorner = Instance.new("UICorner")
                satBlackCorner.CornerRadius = UDim.new(0, 2)
                satBlackCorner.Parent = satBlack
                local satBlackGradient = Instance.new("UIGradient")
                satBlackGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
                satBlackGradient.Rotation = 90
                satBlackGradient.Parent = satBlack

                local saturationButton = Instance.new("TextButton")
                saturationButton.Parent = saturationFrame
                saturationButton.BackgroundTransparency = 1
                saturationButton.Size = UDim2.new(1, 0, 1, 0)
                saturationButton.Text = ""
                saturationButton.ZIndex = 504

                hueSlider.Name = "hueSlider"
                hueSlider.Parent = colorPickerFrame
                hueSlider.Position = UDim2.new(0, 360, 0, 10)
                hueSlider.Size = UDim2.new(0, 26, 0, 140)
                hueSlider.ZIndex = 501

                hueSliderCorner.CornerRadius = UDim.new(0, 2)
                hueSliderCorner.Parent = hueSlider

                local hueGradient = Instance.new("UIGradient")
                hueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }
                hueGradient.Rotation = 90
                hueGradient.Parent = hueSlider

                local hueSliderButton = Instance.new("TextButton")
                hueSliderButton.Parent = hueSlider
                hueSliderButton.BackgroundTransparency = 1
                hueSliderButton.Size = UDim2.new(1, 0, 1, 0)
                hueSliderButton.Text = ""
                hueSliderButton.ZIndex = 502

                local hue, sat, val = Color3.toHSV(defaultColor)
                local selectedColor = defaultColor
                local isOpen = false

                local function updateColor()
                    selectedColor = Color3.fromHSV(hue, sat, val)
                    colorPreview.BackgroundColor3 = selectedColor
                    saturationFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                    colorCallback(selectedColor)
                end

                local function togglePicker()
                    isOpen = not isOpen
                    colorPickerFrame.Visible = true
                    local targetHeight = isOpen and 160 or 0
                    TweenService:Create(colorPickerFrame, TweenTable["colorpicker"] or TweenInfo.new(0.2), {Size = UDim2.new(0, 396, 0, targetHeight)}):Play()
                    if not isOpen then
                        wait(0.2)
                        colorPickerFrame.Visible = false
                    end
                end

                colorPreview.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        togglePicker()
                    end
                end)

                local hueDragging = false
                hueSliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = true
                        local function update()
                            local mousePos = UserInputService:GetMouseLocation().Y
                            local relativePos = math.clamp((mousePos - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                            hue = relativePos
                            updateColor()
                        end
                        update()
                        local moveConn
                        moveConn = UserInputService.InputChanged:Connect(function(inp)
                            if hueDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                                update()
                            end
                        end)
                        local releaseConn
                        releaseConn = UserInputService.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                                hueDragging = false
                                moveConn:Disconnect()
                                releaseConn:Disconnect()
                            end
                        end)
                    end
                end)

                local satDragging = false
                saturationButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        satDragging = true
                        local function update()
                            local mousePos = UserInputService:GetMouseLocation()
                            local relativeX = math.clamp((mousePos.X - saturationFrame.AbsolutePosition.X) / saturationFrame.AbsoluteSize.X, 0, 1)
                            local relativeY = math.clamp((mousePos.Y - saturationFrame.AbsolutePosition.Y) / saturationFrame.AbsoluteSize.Y, 0, 1)
                            sat = relativeX
                            val = 1 - relativeY
                            updateColor()
                        end
                        update()
                        local moveConn
                        moveConn = UserInputService.InputChanged:Connect(function(inp)
                            if satDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                                update()
                            end
                        end)
                        local releaseConn
                        releaseConn = UserInputService.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                                satDragging = false
                                moveConn:Disconnect()
                                releaseConn:Disconnect()
                            end
                        end)
                    end
                end)

                return ToggleFunctions
            end

            if default then
                toggleDesign.Size = UDim2.new(0, 12, 0, 12)
                toggleDesign.BackgroundTransparency = 0
                callback(true)
            end
            return ToggleFunctions
        end

        function Components:NewKeybind(text, default, callback)
            text = text or "keybind"
            default = default or Enum.KeyCode.P
            callback = callback or function() end

            local keybindFrame = Instance.new("Frame")
            local keybindButton = Instance.new("TextButton")
            local keybindLayout = Instance.new("UIListLayout")
            local keybindLabel = Instance.new("TextLabel")
            local keybindPadding = Instance.new("UIPadding")
            local keybindFolder = Instance.new("Folder")
            local keybindFolderLayout = Instance.new("UIListLayout")
            local keybind = Instance.new("TextButton")
            local keybindCorner = Instance.new("UICorner")
            local keybindBackground = Instance.new("Frame")
            local keybindGradient = Instance.new("UIGradient")
            local keybindBackCorner = Instance.new("UICorner")
            local keybindButtonLabel = Instance.new("TextLabel")
            local keybindLabelStraint = Instance.new("UISizeConstraint")
            local keybindBackgroundStraint = Instance.new("UISizeConstraint")
            local keybindStraint = Instance.new("UISizeConstraint")

            keybindFrame.Name = "keybindFrame"
            keybindFrame.Parent = page
            keybindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindFrame.BackgroundTransparency = 1.000
            keybindFrame.ClipsDescendants = true
            keybindFrame.Size = UDim2.new(0, 396, 0, 24)

            keybindButton.Name = "keybindButton"
            keybindButton.Parent = keybindFrame
            keybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindButton.BackgroundTransparency = 1.000
            keybindButton.Size = UDim2.new(0, 396, 0, 24)
            keybindButton.AutoButtonColor = false
            keybindButton.Font = Enum.Font.SourceSans
            keybindButton.Text = ""
            keybindButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            keybindButton.TextSize = 14.000

            keybindLayout.Name = "keybindLayout"
            keybindLayout.Parent = keybindButton
            keybindLayout.FillDirection = Enum.FillDirection.Horizontal
            keybindLayout.SortOrder = Enum.SortOrder.LayoutOrder
            keybindLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            keybindLayout.Padding = UDim.new(0, 4)

            keybindLabel.Name = "keybindLabel"
            keybindLabel.Parent = keybindButton
            keybindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindLabel.BackgroundTransparency = 1.000
            keybindLabel.Size = UDim2.new(0, 396, 0, 24)
            keybindLabel.Font = Enum.Font.Code
            keybindLabel.Text = text
            keybindLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            keybindLabel.TextSize = 14.000
            keybindLabel.TextWrapped = true
            keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            keybindLabel.RichText = true

            keybindPadding.Name = "keybindPadding"
            keybindPadding.Parent = keybindLabel
            keybindPadding.PaddingBottom = UDim.new(0, 6)
            keybindPadding.PaddingLeft = UDim.new(0, 2)
            keybindPadding.PaddingRight = UDim.new(0, 6)
            keybindPadding.PaddingTop = UDim.new(0, 6)

            keybindFolder.Name = "keybindFolder"
            keybindFolder.Parent = keybindFrame

            keybindFolderLayout.Name = "keybindFolderLayout"
            keybindFolderLayout.Parent = keybindFolder
            keybindFolderLayout.FillDirection = Enum.FillDirection.Horizontal
            keybindFolderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            keybindFolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
            keybindFolderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            keybindFolderLayout.Padding = UDim.new(0, 4)

            keybind.Name = "keybind"
            keybind.Parent = keybindFolder
            keybind.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            keybind.Position = UDim2.new(0.780303001, 0, 0, 0)
            keybind.Size = UDim2.new(0, 87, 0, 22)
            keybind.AutoButtonColor = false
            keybind.Font = Enum.Font.SourceSans
            keybind.Text = ""
            keybind.TextColor3 = Color3.fromRGB(0, 0, 0)
            keybind.TextSize = 14.000
            keybind.Active = false

            keybindCorner.CornerRadius = UDim.new(0, 2)
            keybindCorner.Name = "keybindCorner"
            keybindCorner.Parent = keybind

            keybindBackground.Name = "keybindBackground"
            keybindBackground.Parent = keybind
            keybindBackground.AnchorPoint = Vector2.new(0.5, 0.5)
            keybindBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
            keybindBackground.Size = UDim2.new(0, 85, 0, 20)

            keybindGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            keybindGradient.Rotation = 90
            keybindGradient.Name = "keybindGradient"
            keybindGradient.Parent = keybindBackground

            keybindBackCorner.CornerRadius = UDim.new(0, 2)
            keybindBackCorner.Name = "keybindBackCorner"
            keybindBackCorner.Parent = keybindBackground

            keybindButtonLabel.Name = "keybindButtonLabel"
            keybindButtonLabel.Parent = keybindBackground
            keybindButtonLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            keybindButtonLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindButtonLabel.BackgroundTransparency = 1.000
            keybindButtonLabel.ClipsDescendants = true
            keybindButtonLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            keybindButtonLabel.Size = UDim2.new(0, 85, 0, 20)
            keybindButtonLabel.Font = Enum.Font.Code
            keybindButtonLabel.Text = ". . ."
            keybindButtonLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            keybindButtonLabel.TextSize = 14.000
            keybindButtonLabel.RichText = true

            keybindLabelStraint.Name = "keybindLabelStraint"
            keybindLabelStraint.Parent = keybindButtonLabel
            keybindLabelStraint.MinSize = Vector2.new(28, 20)

            keybindBackgroundStraint.Name = "keybindBackgroundStraint"
            keybindBackgroundStraint.Parent = keybindBackground
            keybindBackgroundStraint.MinSize = Vector2.new(28, 20)

            keybindStraint.Name = "keybindStraint"
            keybindStraint.Parent = keybind
            keybindStraint.MinSize = Vector2.new(30, 22)

            local Shortcuts = {
                Return = "enter"
            }

            keybindButtonLabel.Text = Shortcuts[default.Name] or default.Name
            CreateTween("keybind", 0.08)
            
            local NewKeybindSize = TextService:GetTextSize(keybindButtonLabel.Text, keybindButtonLabel.TextSize, keybindButtonLabel.Font, Vector2.new(math.huge,math.huge))
            keybindButtonLabel.Size = UDim2.new(0, NewKeybindSize.X + 6, 0, 20)
            keybindBackground.Size = UDim2.new(0, NewKeybindSize.X + 6, 0, 20)
            keybind.Size = UDim2.new(0, NewKeybindSize.X + 8, 0, 22)
            
            function ResizeKeybind()
                NewKeybindSize = TextService:GetTextSize(keybindButtonLabel.Text, keybindButtonLabel.TextSize, keybindButtonLabel.Font, Vector2.new(math.huge,math.huge))
                TweenService:Create(keybindButtonLabel, TweenTable["keybind"], {Size = UDim2.new(0, NewKeybindSize.X + 6, 0, 20)}):Play()
                TweenService:Create(keybindBackground, TweenTable["keybind"], {Size = UDim2.new(0, NewKeybindSize.X + 6, 0, 20)}):Play()
                TweenService:Create(keybind, TweenTable["keybind"], {Size = UDim2.new(0, NewKeybindSize.X + 8, 0, 22)}):Play()
            end
            keybindButtonLabel:GetPropertyChangedSignal("Text"):Connect(ResizeKeybind)
            ResizeKeybind()

            local ChosenKey = default
            keybindButton.MouseButton1Click:Connect(function()
                keybindButtonLabel.Text = "..."
                local InputWait = UserInputService.InputBegan:wait()
                if UserInputService.WindowFocused and InputWait.KeyCode.Name ~= "Unknown" then
                    local Result = Shortcuts[InputWait.KeyCode.Name] or InputWait.KeyCode.Name
                    keybindButtonLabel.Text = Result
                    ChosenKey = InputWait.KeyCode.Name
                end
            end)

            keybind.MouseButton1Click:Connect(function()
                keybindButtonLabel.Text = ". . ."
                local InputWait = UserInputService.InputBegan:wait()
                if UserInputService.WindowFocused and InputWait.KeyCode.Name ~= "Unknown" then
                    local Result = Shortcuts[InputWait.KeyCode.Name] or InputWait.KeyCode.Name
                    keybindButtonLabel.Text = Result
                    ChosenKey = InputWait.KeyCode.Name
                end
            end)

            local ChatTextBox = Player.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar
            if UserInputService.WindowFocused then
                UserInputService.InputBegan:Connect(function(c, p)
                    if not p then
                        if c.KeyCode.Name == ChosenKey and not ChatTextBox:IsFocused() then
                            callback(ChosenKey)
                            return
                        end
                    end
                end)
            end

            UpdatePageSize()

            local KeybindFunctions = {}
            function KeybindFunctions:Fire()
                callback(ChosenKey)
                return KeybindFunctions
            end
            --
            function KeybindFunctions:SetFunction(new)
                new = new or function() end
                callback = new
                return KeybindFunctions 
            end
            --
            function KeybindFunctions:SetKey(new)
                new = new or ChosenKey.Name
                ChosenKey = new.Name
                keybindButtonLabel.Text = new.Name
                return KeybindFunctions
            end
            --
            function KeybindFunctions:Text(new)
                new = new or keybindLabel.Text
                keybindLabel.Text = new
                return KeybindFunctions
            end
            --
            function KeybindFunctions:Hide()
                keybindFrame.Visible = false
                return KeybindFunctions
            end
            --
            function KeybindFunctions:Show()
                keybindFrame.Visible = true
                return KeybindFunctions
            end
            return KeybindFunctions
        end
        --
        function Components:NewTextbox(text, default, place, format, type, autoexec, autoclear, callback)
            text = text or "text box"
            default = default or ""
            place = place or ""
            format = format or "all" -- all, numbers, lower, upper
            type = type or "small" -- small, medium, large
            autoexec = autoexec or true
            autoclear = autoclear or false
            callback = callback or function() end

            if type == "small" then
                local textboxFrame = Instance.new("Frame")
                local textboxFolder = Instance.new("Folder")
                local textboxFolderLayout = Instance.new("UIListLayout")
                local textbox = Instance.new("Frame")
                local textboxLayout = Instance.new("UIListLayout")
                local textboxStraint = Instance.new("UISizeConstraint")
                local textboxCorner = Instance.new("UICorner")
                local textboxTwo = Instance.new("Frame")
                local textboxTwoStraint = Instance.new("UISizeConstraint")
                local textboxTwoGradient = Instance.new("UIGradient")
                local textboxTwoCorner = Instance.new("UICorner")
                local textBoxValues = Instance.new("TextBox")
                local textBoxValuesStraint = Instance.new("UISizeConstraint")
                local textboxTwoLayout = Instance.new("UIListLayout")
                local textboxLabel = Instance.new("TextLabel")
                local textboxPadding = Instance.new("UIPadding")
                local textBoxValuesPadding = Instance.new("UIPadding")
    
                textboxFrame.Name = "textboxFrame"
                textboxFrame.Parent = page
                textboxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxFrame.BackgroundTransparency = 1.000
                textboxFrame.ClipsDescendants = true
                textboxFrame.Size = UDim2.new(0, 396, 0, 24)
    
                textboxFolder.Name = "textboxFolder"
                textboxFolder.Parent = textboxFrame
    
                textboxFolderLayout.Name = "textboxFolderLayout"
                textboxFolderLayout.Parent = textboxFolder
                textboxFolderLayout.FillDirection = Enum.FillDirection.Horizontal
                textboxFolderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                textboxFolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxFolderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                textboxFolderLayout.Padding = UDim.new(0, 4)
    
                textbox.Name = "textbox"
                textbox.Parent = textboxFolder
                textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                textbox.Size = UDim2.new(0, 133, 0, 22)
    
                textboxLayout.Name = "textboxLayout"
                textboxLayout.Parent = textbox
                textboxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxLayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    
                textboxStraint.Name = "textboxStraint"
                textboxStraint.Parent = textbox
                textboxStraint.MinSize = Vector2.new(50, 22)
    
                textboxCorner.CornerRadius = UDim.new(0, 2)
                textboxCorner.Name = "textboxCorner"
                textboxCorner.Parent = textbox
    
                textboxTwo.Name = "textboxTwo"
                textboxTwo.Parent = textbox
                textboxTwo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxTwo.Size = UDim2.new(0, 131, 0, 20)
    
                textboxTwoStraint.Name = "textboxTwoStraint"
                textboxTwoStraint.Parent = textboxTwo
                textboxTwoStraint.MinSize = Vector2.new(48, 20)
    
                textboxTwoGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                textboxTwoGradient.Rotation = 90
                textboxTwoGradient.Name = "textboxTwoGradient"
                textboxTwoGradient.Parent = textboxTwo
    
                textboxTwoCorner.CornerRadius = UDim.new(0, 2)
                textboxTwoCorner.Name = "textboxTwoCorner"
                textboxTwoCorner.Parent = textboxTwo
    
                textBoxValues.Name = "textBoxValues"
                textBoxValues.Parent = textboxTwo
                textBoxValues.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textBoxValues.BackgroundTransparency = 1.000
                textBoxValues.Position = UDim2.new(0.664141417, 0, 0.0416666679, 0)
                textBoxValues.Size = UDim2.new(0, 131, 0, 20)
                textBoxValues.Font = Enum.Font.Code
                textBoxValues.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
                textBoxValues.PlaceholderText = place
                textBoxValues.Text = ""
                textBoxValues.TextColor3 = Color3.fromRGB(190, 190, 190)
                textBoxValues.TextSize = 14.000
                textBoxValues.ClearTextOnFocus = autoclear
                textBoxValues.ClipsDescendants = true
                textBoxValues.TextXAlignment = Enum.TextXAlignment.Right

                textBoxValuesPadding.Name = "textBoxValuesPadding"
                textBoxValuesPadding.Parent = textBoxValues
                textBoxValuesPadding.PaddingBottom = UDim.new(0, 6)
                textBoxValuesPadding.PaddingLeft = UDim.new(0, 6)
                textBoxValuesPadding.PaddingRight = UDim.new(0, 4)
                textBoxValuesPadding.PaddingTop = UDim.new(0, 6)
    
                textBoxValuesStraint.Name = "textBoxValuesStraint"
                textBoxValuesStraint.Parent = textBoxValues
                textBoxValuesStraint.MinSize = Vector2.new(48, 20)
    
                textboxTwoLayout.Name = "textboxTwoLayout"
                textboxTwoLayout.Parent = textboxTwo
                textboxTwoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxTwoLayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxTwoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    
                textboxLabel.Name = "textboxLabel"
                textboxLabel.Parent = textboxFrame
                textboxLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxLabel.BackgroundTransparency = 1.000
                textboxLabel.Size = UDim2.new(0, 396, 0, 24)
                textboxLabel.Font = Enum.Font.Code
                textboxLabel.Text = text
                textboxLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
                textboxLabel.TextSize = 14.000
                textboxLabel.TextWrapped = true
                textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                textboxLabel.RichText = true
    
                textboxPadding.Name = "textboxPadding"
                textboxPadding.Parent = textboxLabel
                textboxPadding.PaddingBottom = UDim.new(0, 6)
                textboxPadding.PaddingLeft = UDim.new(0, 2)
                textboxPadding.PaddingRight = UDim.new(0, 6)
                textboxPadding.PaddingTop = UDim.new(0, 6)
    
                local ForcedMinSize = TextService:GetTextSize(textBoxValues.PlaceholderText, textBoxValues.TextSize, textBoxValues.Font, Vector2.new(math.huge,math.huge))
                local ForcedMaxSize = TextService:GetTextSize(textboxLabel.Text, textboxLabel.TextSize, textboxLabel.Font, Vector2.new(math.huge,math.huge))
                local NewTextboxSize = TextService:GetTextSize(textBoxValues.Text, textBoxValues.TextSize, textBoxValues.Font, Vector2.new(math.huge,math.huge))

                CreateTween("TextBox", 0.07)

                textboxStraint.MinSize = Vector2.new(ForcedMinSize.X + 4, 22)
                textboxTwoStraint.MinSize = Vector2.new(ForcedMinSize.X + 2, 20)
                textBoxValuesStraint.MinSize = Vector2.new(ForcedMinSize.X + 2, 20)
                textboxStraint.MaxSize = Vector2.new(386 - ForcedMaxSize.X, 22)
                textboxTwoStraint.MaxSize = Vector2.new(388 - ForcedMaxSize.X, 20)
                textBoxValuesStraint.MaxSize = Vector2.new(388 - ForcedMaxSize.X, 20)
                
                function ResizeTextStraints()
                    ForcedMinSize = TextService:GetTextSize(textBoxValues.PlaceholderText, textBoxValues.TextSize, textBoxValues.Font, Vector2.new(math.huge,math.huge))
                    if place ~= "" then
                        textboxStraint.MinSize = Vector2.new(ForcedMinSize.X + 10, 22)
                        textboxTwoStraint.MinSize = Vector2.new(ForcedMinSize.X + 8, 20)
                        textBoxValuesStraint.MinSize = Vector2.new(ForcedMinSize.X + 8, 20)
                    else
                        textboxStraint.MinSize = Vector2.new(28, 22)
                        textboxTwoStraint.MinSize = Vector2.new(26, 20)
                        textBoxValuesStraint.MinSize = Vector2.new(26, 20)
                    end
                end
                function ResizeTextBox()
                    NewTextboxSize = TextService:GetTextSize(textBoxValues.Text, textBoxValues.TextSize, textBoxValues.Font, Vector2.new(math.huge,math.huge))
                    if NewTextboxSize.X < (396 - ForcedMaxSize.X) - 10 then
                        TweenService:Create(textBoxValues, TweenTable["TextBox"], {Size = UDim2.new(0, NewTextboxSize.X + 8, 0, 20)}):Play()
                        TweenService:Create(textboxTwo, TweenTable["TextBox"], {Size = UDim2.new(0, NewTextboxSize.X + 8, 0, 20)}):Play()
                        TweenService:Create(textbox, TweenTable["TextBox"], {Size = UDim2.new(0, NewTextboxSize.X + 10, 0, 22)}):Play()
                    else
                        TweenService:Create(textBoxValues, TweenTable["TextBox"], {Size = UDim2.new(0, (396 - ForcedMaxSize.X) - 12, 0, 20)}):Play()
                        TweenService:Create(textboxTwo, TweenTable["TextBox"], {Size = UDim2.new(0, (396 - ForcedMaxSize.X) - 12, 0, 20)}):Play()
                        TweenService:Create(textbox, TweenTable["TextBox"], {Size = UDim2.new(0, (396 - ForcedMaxSize.X) - 10, 0, 22)}):Play()
                    end
                end
                function SetMaxSize()
                    ForcedMaxSize = TextService:GetTextSize(textboxLabel.Text, textboxLabel.TextSize, textboxLabel.Font, Vector2.new(math.huge,math.huge))
                    local def = 396 - ForcedMaxSize.X
                    textboxStraint.MaxSize = Vector2.new(def - 10, 22)
                    textboxTwoStraint.MaxSize = Vector2.new(def - 12, 20)
                    textBoxValuesStraint.MaxSize = Vector2.new(def - 12, 20)
                end

                ResizeTextBox()
                ResizeTextStraints()
                SetMaxSize()
                UpdatePageSize()

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(ResizeTextBox)
                textBoxValues:GetPropertyChangedSignal("Text"):Connect(SetMaxSize)
                textBoxValues:GetPropertyChangedSignal("Text"):Connect(ResizeTextStraints)
                textBoxValues:GetPropertyChangedSignal("PlaceholderText"):Connect(ResizeTextStraints)
                textBoxValues:GetPropertyChangedSignal("PlaceholderText"):Connect(SetMaxSize)
                textBoxValues:GetPropertyChangedSignal("PlaceholderText"):Connect(ResizeTextBox)
                textboxLabel:GetPropertyChangedSignal("Text"):Connect(SetMaxSize)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "numbers" then
                        textBoxValues.Text = textBoxValues.Text:gsub("%D+", "")
                    end
                end)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "lower" then
                        textBoxValues.Text = textBoxValues.Text:lower()
                    end
                end)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "upper" then
                        textBoxValues.Text = textBoxValues.Text:upper()
                    end
                end)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "all" or format == "" then
                        textBoxValues.Text = textBoxValues.Text
                    end
                end)

                textboxFrame.MouseEnter:Connect(function()
                    TweenService:Create(textboxLabel, TweenTable["TextBox"], {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                end)

                textboxFrame.MouseLeave:Connect(function()
                    TweenService:Create(textboxLabel, TweenTable["TextBox"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
                end)

                textBoxValues.Focused:Connect(function()
                    textBoxValues:GetPropertyChangedSignal("Text"):Connect(ResizeTextBox)
                    TweenService:Create(textbox, TweenTable["TextBox"], {BackgroundColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                end)

                textBoxValues.FocusLost:Connect(function()
                    TweenService:Create(textbox, TweenTable["TextBox"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end)

                textBoxValues.FocusLost:Connect(function(enterPressed)
                    if not autoexec then
                        if enterPressed then
                            callback(textBoxValues.Text)
                        end
                    else
                        callback(textBoxValues.Text)
                    end
                end)

                UpdatePageSize()

                local TextboxFunctions = {}
                function TextboxFunctions:Input(new)
                    new = new or textBoxValues.Text
                    textBoxValues = new
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Fire()
                    callback(textBoxValues.Text)
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:SetFunction(new)
                    new = new or callback
                    callback = new
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Text(new)
                    new = new or textboxLabel.Text
                    textboxLabel.Text = new
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Hide()
                    textboxFrame.Visible = false
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Show()
                    textboxFrame.Visible = true
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Remove()
                    textboxFrame:Destroy()
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Place(new)
                    new = new or textBoxValues.PlaceholderText
                    textBoxValues.PlaceholderText = new
                    return TextboxFunctions
                end
                return TextboxFunctions
            elseif type == "medium" then
                local textboxFrame = Instance.new("Frame")
                local textboxFolder = Instance.new("Folder")
                local textboxFolderLayout = Instance.new("UIListLayout")
                local textbox = Instance.new("Frame")
                local textboxLayout = Instance.new("UIListLayout")
                local textboxStraint = Instance.new("UISizeConstraint")
                local textboxCorner = Instance.new("UICorner")
                local textboxTwo = Instance.new("Frame")
                local textboxTwoStraint = Instance.new("UISizeConstraint")
                local textboxTwoGradient = Instance.new("UIGradient")
                local textboxTwoCorner = Instance.new("UICorner")
                local textBoxValues = Instance.new("TextBox")
                local textBoxValuesStraint = Instance.new("UISizeConstraint")
                local textBoxValuesPadding = Instance.new("UIPadding")
                local textboxTwoLayout = Instance.new("UIListLayout")
                local textboxLabel = Instance.new("TextLabel")
                local textboxPadding = Instance.new("UIPadding")

                textboxFrame.Name = "textboxFrame"
                textboxFrame.Parent = page
                textboxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxFrame.BackgroundTransparency = 1.000
                textboxFrame.ClipsDescendants = true
                textboxFrame.Size = UDim2.new(0, 396, 0, 46)

                textboxFolder.Name = "textboxFolder"
                textboxFolder.Parent = textboxFrame

                textboxFolderLayout.Name = "textboxFolderLayout"
                textboxFolderLayout.Parent = textboxFolder
                textboxFolderLayout.FillDirection = Enum.FillDirection.Horizontal
                textboxFolderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxFolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxFolderLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                textboxFolderLayout.Padding = UDim.new(0, 4)

                textbox.Name = "textbox"
                textbox.Parent = textboxFolder
                textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                textbox.Size = UDim2.new(0, 396, 0, 22)

                textboxLayout.Name = "textboxLayout"
                textboxLayout.Parent = textbox
                textboxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxLayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                textboxStraint.Name = "textboxStraint"
                textboxStraint.Parent = textbox
                textboxStraint.MaxSize = Vector2.new(396, 22)
                textboxStraint.MinSize = Vector2.new(396, 22)

                textboxCorner.CornerRadius = UDim.new(0, 2)
                textboxCorner.Name = "textboxCorner"
                textboxCorner.Parent = textbox

                textboxTwo.Name = "textboxTwo"
                textboxTwo.Parent = textbox
                textboxTwo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxTwo.Size = UDim2.new(0, 394, 0, 20)

                textboxTwoStraint.Name = "textboxTwoStraint"
                textboxTwoStraint.Parent = textboxTwo
                textboxTwoStraint.MaxSize = Vector2.new(394, 20)
                textboxTwoStraint.MinSize = Vector2.new(394, 20)

                textboxTwoGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                textboxTwoGradient.Rotation = 90
                textboxTwoGradient.Name = "textboxTwoGradient"
                textboxTwoGradient.Parent = textboxTwo

                textboxTwoCorner.CornerRadius = UDim.new(0, 2)
                textboxTwoCorner.Name = "textboxTwoCorner"
                textboxTwoCorner.Parent = textboxTwo

                textBoxValues.Name = "textBoxValues"
                textBoxValues.Parent = textboxTwo
                textBoxValues.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textBoxValues.BackgroundTransparency = 1.000
                textBoxValues.ClipsDescendants = true
                textBoxValues.Position = UDim2.new(-0.587786257, 0, 0, 0)
                textBoxValues.Size = UDim2.new(0, 394, 0, 20)
                textBoxValues.Font = Enum.Font.Code
                textBoxValues.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
                textBoxValues.PlaceholderText = place
                textBoxValues.Text = default
                textBoxValues.TextColor3 = Color3.fromRGB(190, 190, 190)
                textBoxValues.TextSize = 14.000
                textBoxValues.TextXAlignment = Enum.TextXAlignment.Left

                textBoxValuesStraint.Name = "textBoxValuesStraint"
                textBoxValuesStraint.Parent = textBoxValues
                textBoxValuesStraint.MaxSize = Vector2.new(394, 20)
                textBoxValuesStraint.MinSize = Vector2.new(394, 20)

                textBoxValuesPadding.Name = "textBoxValuesPadding"
                textBoxValuesPadding.Parent = textBoxValues
                textBoxValuesPadding.PaddingBottom = UDim.new(0, 6)
                textBoxValuesPadding.PaddingLeft = UDim.new(0, 4)
                textBoxValuesPadding.PaddingRight = UDim.new(0, 6)
                textBoxValuesPadding.PaddingTop = UDim.new(0, 6)

                textboxTwoLayout.Name = "textboxTwoLayout"
                textboxTwoLayout.Parent = textboxTwo
                textboxTwoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxTwoLayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxTwoLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                textboxLabel.Name = "textboxLabel"
                textboxLabel.Parent = textboxFrame
                textboxLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxLabel.BackgroundTransparency = 1.000
                textboxLabel.Size = UDim2.new(0, 396, 0, 24)
                textboxLabel.Font = Enum.Font.Code
                textboxLabel.Text = text
                textboxLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
                textboxLabel.TextSize = 14.000
                textboxLabel.TextWrapped = true
                textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                textboxLabel.RichText = true

                textboxPadding.Name = "textboxPadding"
                textboxPadding.Parent = textboxLabel
                textboxPadding.PaddingBottom = UDim.new(0, 6)
                textboxPadding.PaddingLeft = UDim.new(0, 2)
                textboxPadding.PaddingRight = UDim.new(0, 6)
                textboxPadding.PaddingTop = UDim.new(0, 6)

                CreateTween("TextBox", 0.07)
                UpdatePageSize()

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "numbers" then
                        textBoxValues.Text = textBoxValues.Text:gsub("%D+", "")
                    end
                end)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "lower" then
                        textBoxValues.Text = textBoxValues.Text:lower()
                    end
                end)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "upper" then
                        textBoxValues.Text = textBoxValues.Text:upper()
                    end
                end)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "all" or format == "" then
                        textBoxValues.Text = textBoxValues.Text
                    end
                end)

                textboxFrame.MouseEnter:Connect(function()
                    TweenService:Create(textboxLabel, TweenTable["TextBox"], {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                end)

                textboxFrame.MouseLeave:Connect(function()
                    TweenService:Create(textboxLabel, TweenTable["TextBox"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
                end)

                textBoxValues.Focused:Connect(function()
                    TweenService:Create(textbox, TweenTable["TextBox"], {BackgroundColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                end)

                textBoxValues.FocusLost:Connect(function()
                    TweenService:Create(textbox, TweenTable["TextBox"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end)

                textBoxValues.FocusLost:Connect(function(enterPressed)
                    if not autoexec then
                        if enterPressed then
                            callback(textBoxValues.Text)
                        end
                    else
                        callback(textBoxValues.Text)
                    end
                end)

                local TextboxFunctions = {}
                function TextboxFunctions:Input(new)
                    new = new or textBoxValues.Text
                    textBoxValues = new
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Fire()
                    callback(textBoxValues.Text)
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:SetFunction(new)
                    new = new or callback
                    callback = new
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Text(new)
                    new = new or textboxLabel.Text
                    textboxLabel.Text = new
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Hide()
                    textboxFrame.Visible = false
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Show()
                    textboxFrame.Visible = true
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Remove()
                    textboxFrame:Destroy()
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Place(new)
                    new = new or textBoxValues.PlaceholderText
                    textBoxValues.PlaceholderText = new
                    return TextboxFunctions
                end
                return TextboxFunctions
            elseif type == "large" then
                local textboxFrame = Instance.new("Frame")
                local textboxFolder = Instance.new("Folder")
                local textboxFolderLayout = Instance.new("UIListLayout")
                local textbox = Instance.new("Frame")
                local textboxLayout = Instance.new("UIListLayout")
                local textboxStraint = Instance.new("UISizeConstraint")
                local textboxCorner = Instance.new("UICorner")
                local textboxTwo = Instance.new("Frame")
                local textboxTwoStraint = Instance.new("UISizeConstraint")
                local textboxTwoGradient = Instance.new("UIGradient")
                local textboxTwoCorner = Instance.new("UICorner")
                local textBoxValues = Instance.new("TextBox")
                local textBoxValuesStraint = Instance.new("UISizeConstraint")
                local textBoxValuesPadding = Instance.new("UIPadding")
                local textboxTwoLayout = Instance.new("UIListLayout")
                local textboxLabel = Instance.new("TextLabel")
                local textboxPadding = Instance.new("UIPadding")

                textboxFrame.Name = "textboxFrame"
                textboxFrame.Parent = page
                textboxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxFrame.BackgroundTransparency = 1.000
                textboxFrame.ClipsDescendants = true
                textboxFrame.Position = UDim2.new(0.00499999989, 0, 0.268786132, 0)
                textboxFrame.Size = UDim2.new(0, 396, 0, 142)

                textboxFolder.Name = "textboxFolder"
                textboxFolder.Parent = textboxFrame

                textboxFolderLayout.Name = "textboxFolderLayout"
                textboxFolderLayout.Parent = textboxFolder
                textboxFolderLayout.FillDirection = Enum.FillDirection.Horizontal
                textboxFolderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxFolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxFolderLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                textboxFolderLayout.Padding = UDim.new(0, 4)

                textbox.Name = "textbox"
                textbox.Parent = textboxFolder
                textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                textbox.Position = UDim2.new(0, 0, 0.169014081, 0)
                textbox.Size = UDim2.new(0, 396, 0, 118)

                textboxLayout.Name = "textboxLayout"
                textboxLayout.Parent = textbox
                textboxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxLayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                textboxStraint.Name = "textboxStraint"
                textboxStraint.Parent = textbox
                textboxStraint.MaxSize = Vector2.new(396, 118)
                textboxStraint.MinSize = Vector2.new(396, 118)

                textboxCorner.CornerRadius = UDim.new(0, 2)
                textboxCorner.Name = "textboxCorner"
                textboxCorner.Parent = textbox

                textboxTwo.Name = "textboxTwo"
                textboxTwo.Parent = textbox
                textboxTwo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxTwo.Size = UDim2.new(0, 394, 0, 114)

                textboxTwoStraint.Name = "textboxTwoStraint"
                textboxTwoStraint.Parent = textboxTwo
                textboxTwoStraint.MaxSize = Vector2.new(394, 116)
                textboxTwoStraint.MinSize = Vector2.new(394, 116)

                textboxTwoGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                textboxTwoGradient.Rotation = 90
                textboxTwoGradient.Name = "textboxTwoGradient"
                textboxTwoGradient.Parent = textboxTwo

                textboxTwoCorner.CornerRadius = UDim.new(0, 2)
                textboxTwoCorner.Name = "textboxTwoCorner"
                textboxTwoCorner.Parent = textboxTwo

                textBoxValues.Name = "textBoxValues"
                textBoxValues.Parent = textboxTwo
                textBoxValues.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textBoxValues.BackgroundTransparency = 1.000
                textBoxValues.ClipsDescendants = true
                textBoxValues.Size = UDim2.new(0, 394, 0, 114)
                textBoxValues.Font = Enum.Font.Code
                textBoxValues.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
                textBoxValues.PlaceholderText = place
                textBoxValues.Text = default
                textBoxValues.TextColor3 = Color3.fromRGB(190, 190, 190)
                textBoxValues.TextSize = 14.000
                textBoxValues.TextWrapped = true
                textBoxValues.TextXAlignment = Enum.TextXAlignment.Left
                textBoxValues.TextYAlignment = Enum.TextYAlignment.Top

                textBoxValuesStraint.Name = "textBoxValuesStraint"
                textBoxValuesStraint.Parent = textBoxValues
                textBoxValuesStraint.MaxSize = Vector2.new(394, 116)
                textBoxValuesStraint.MinSize = Vector2.new(394, 116)

                textBoxValuesPadding.Name = "textBoxValuesPadding"
                textBoxValuesPadding.Parent = textBoxValues
                textBoxValuesPadding.PaddingBottom = UDim.new(0, 2)
                textBoxValuesPadding.PaddingLeft = UDim.new(0, 2)
                textBoxValuesPadding.PaddingRight = UDim.new(0, 2)
                textBoxValuesPadding.PaddingTop = UDim.new(0, 2)

                textboxTwoLayout.Name = "textboxTwoLayout"
                textboxTwoLayout.Parent = textboxTwo
                textboxTwoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxTwoLayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxTwoLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                textboxLabel.Name = "textboxLabel"
                textboxLabel.Parent = textboxFrame
                textboxLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxLabel.BackgroundTransparency = 1.000
                textboxLabel.Size = UDim2.new(0, 396, 0, 24)
                textboxLabel.Font = Enum.Font.Code
                textboxLabel.Text = text
                textboxLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
                textboxLabel.TextSize = 14.000
                textboxLabel.TextWrapped = true
                textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                textboxLabel.RichText = true

                textboxPadding.Name = "textboxPadding"
                textboxPadding.Parent = textboxLabel
                textboxPadding.PaddingBottom = UDim.new(0, 6)
                textboxPadding.PaddingLeft = UDim.new(0, 2)
                textboxPadding.PaddingRight = UDim.new(0, 6)
                textboxPadding.PaddingTop = UDim.new(0, 6)

                CreateTween("TextBox", 0.07)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "numbers" then
                        textBoxValues.Text = textBoxValues.Text:gsub("%D+", "")
                    end
                end)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "lower" then
                        textBoxValues.Text = textBoxValues.Text:lower()
                    end
                end)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "upper" then
                        textBoxValues.Text = textBoxValues.Text:upper()
                    end
                end)

                textBoxValues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "all" or format == "" then
                        textBoxValues.Text = textBoxValues.Text
                    end
                end)

                textboxFrame.MouseEnter:Connect(function()
                    TweenService:Create(textboxLabel, TweenTable["TextBox"], {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                end)

                textboxFrame.MouseLeave:Connect(function()
                    TweenService:Create(textboxLabel, TweenTable["TextBox"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
                end)

                textBoxValues.Focused:Connect(function()
                    TweenService:Create(textbox, TweenTable["TextBox"], {BackgroundColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                end)

                textBoxValues.FocusLost:Connect(function()
                    TweenService:Create(textbox, TweenTable["TextBox"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end)

                textBoxValues.FocusLost:Connect(function(enterPressed)
                    if not autoexec then
                        if enterPressed then
                            callback(textBoxValues.Text)
                        end
                    else
                        callback(textBoxValues.Text)
                    end
                end)

                UpdatePageSize()

                local TextboxFunctions = {}
                function TextboxFunctions:Input(new)
                    new = new or textBoxValues.Text
                    textBoxValues = new
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Fire()
                    callback(textBoxValues.Text)
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:SetFunction(new)
                    new = new or callback
                    callback = new
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Text(new)
                    new = new or textboxLabel.Text
                    textboxLabel.Text = new
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Hide()
                    textboxFrame.Visible = false
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Show()
                    textboxFrame.Visible = true
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Remove()
                    textboxFrame:Destroy()
                    return TextboxFunctions
                end
                --
                function TextboxFunctions:Place(new)
                    new = new or textBoxValues.PlaceholderText
                    textBoxValues.PlaceholderText = new
                    return TextboxFunctions
                end
                return TextboxFunctions
            end
        end
        --
        function Components:NewSelector(text, default, list, callback)
            text = text or "selector"
            default = default or ". . ."
            list = list or {}
            callback = callback or function() end

            local selectorFrame = Instance.new("Frame")
            local selectorLabel = Instance.new("TextLabel")
            local selectorLabelPadding = Instance.new("UIPadding")
            local selectorFrameLayout = Instance.new("UIListLayout")
            local selector = Instance.new("TextButton")
            local selectorCorner = Instance.new("UICorner")
            local selectorLayout = Instance.new("UIListLayout")
            local selectorPadding = Instance.new("UIPadding")
            local selectorTwo = Instance.new("Frame")
            local selectorText = Instance.new("TextLabel")
            local textBoxValuesPadding = Instance.new("UIPadding")
            local Frame = Instance.new("Frame")
            local selectorTwoLayout = Instance.new("UIListLayout")
            local selectorTwoGradient = Instance.new("UIGradient")
            local selectorTwoCorner = Instance.new("UICorner")
            local selectorPadding_2 = Instance.new("UIPadding")
            local selectorContainer = Instance.new("Frame")
            local selectorTwoLayout_2 = Instance.new("UIListLayout")
            
            selectorFrame.Name = "selectorFrame"
            selectorFrame.Parent = page
            selectorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectorFrame.BackgroundTransparency = 1.000
            selectorFrame.ClipsDescendants = true
            selectorFrame.Position = UDim2.new(0.00499999989, 0, 0.0895953774, 0)
            selectorFrame.Size = UDim2.new(0, 396, 0, 46)

            
            selectorLabel.Name = "selectorLabel"
            selectorLabel.Parent = selectorFrame
            selectorLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectorLabel.BackgroundTransparency = 1.000
            selectorLabel.Size = UDim2.new(0, 396, 0, 24)
            selectorLabel.Font = Enum.Font.Code
            selectorLabel.Text = text
            selectorLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            selectorLabel.TextSize = 14.000
            selectorLabel.TextWrapped = true
            selectorLabel.TextXAlignment = Enum.TextXAlignment.Left
            selectorLabel.RichText = true
            
            selectorLabelPadding.Name = "selectorLabelPadding"
            selectorLabelPadding.Parent = selectorLabel
            selectorLabelPadding.PaddingBottom = UDim.new(0, 6)
            selectorLabelPadding.PaddingLeft = UDim.new(0, 2)
            selectorLabelPadding.PaddingRight = UDim.new(0, 6)
            selectorLabelPadding.PaddingTop = UDim.new(0, 6)
            
            selectorFrameLayout.Name = "selectorFrameLayout"
            selectorFrameLayout.Parent = selectorFrame
            selectorFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            selectorFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            selector.Name = "selector"
            selector.Parent = selectorFrame
            selector.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            selector.ClipsDescendants = true
            selector.Position = UDim2.new(0, 0, 0.0926640928, 0)
            selector.Size = UDim2.new(0, 396, 0, 21)
            selector.AutoButtonColor = false
            selector.Font = Enum.Font.SourceSans
            selector.Text = ""
            selector.TextColor3 = Color3.fromRGB(0, 0, 0)
            selector.TextSize = 14.000
            
            selectorCorner.CornerRadius = UDim.new(0, 2)
            selectorCorner.Name = "selectorCorner"
            selectorCorner.Parent = selector
            
            selectorLayout.Name = "selectorLayout"
            selectorLayout.Parent = selector
            selectorLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            selectorLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            selectorPadding.Name = "selectorPadding"
            selectorPadding.Parent = selector
            selectorPadding.PaddingTop = UDim.new(0, 1)
            
            selectorTwo.Name = "selectorTwo"
            selectorTwo.Parent = selector
            selectorTwo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectorTwo.ClipsDescendants = true
            selectorTwo.Position = UDim2.new(0.00252525252, 0, 0, 0)
            selectorTwo.Size = UDim2.new(0, 394, 0, 20)
            
            selectorText.Name = "selectorText"
            selectorText.Parent = selectorTwo
            selectorText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectorText.BackgroundTransparency = 1.000
            selectorText.Size = UDim2.new(0, 394, 0, 20)
            selectorText.Font = Enum.Font.Code
            selectorText.LineHeight = 1.150
            selectorText.TextColor3 = Color3.fromRGB(160, 160, 160)
            selectorText.TextSize = 14.000
            selectorText.TextXAlignment = Enum.TextXAlignment.Left
            selectorText.Text = default
            
            textBoxValuesPadding.Name = "textBoxValuesPadding"
            textBoxValuesPadding.Parent = selectorText
            textBoxValuesPadding.PaddingBottom = UDim.new(0, 6)
            textBoxValuesPadding.PaddingLeft = UDim.new(0, 6)
            textBoxValuesPadding.PaddingRight = UDim.new(0, 6)
            textBoxValuesPadding.PaddingTop = UDim.new(0, 6)
            
            Frame.Parent = selectorText
            Frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Frame.BorderSizePixel = 0
            Frame.Position = UDim2.new(-0.008, 0, 1.78, 0)
            Frame.Size = UDim2.new(0, 388, 0, 1)
            
            selectorTwoLayout.Name = "selectorTwoLayout"
            selectorTwoLayout.Parent = selectorTwo
            selectorTwoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            selectorTwoLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            selectorTwoGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            selectorTwoGradient.Rotation = 90
            selectorTwoGradient.Name = "selectorTwoGradient"
            selectorTwoGradient.Parent = selectorTwo
            
            selectorTwoCorner.CornerRadius = UDim.new(0, 2)
            selectorTwoCorner.Name = "selectorTwoCorner"
            selectorTwoCorner.Parent = selectorTwo
            
            selectorPadding_2.Name = "selectorPadding"
            selectorPadding_2.Parent = selectorTwo
            selectorPadding_2.PaddingTop = UDim.new(0, 1)
            
            selectorContainer.Name = "selectorContainer"
            selectorContainer.Parent = selectorTwo
            selectorContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectorContainer.BackgroundTransparency = 1.000
            selectorContainer.Size = UDim2.new(0, 394, 0, 20)
        
            selectorTwoLayout_2.Name = "selectorTwoLayout"
            selectorTwoLayout_2.Parent = selectorContainer
            selectorTwoLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
            selectorTwoLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

            CreateTween("selector", 0.08)

            selectorContainer.ChildAdded:Connect(UpdatePageSize)
            selectorContainer.ChildAdded:Connect(UpdatePageSize)

            UpdatePageSize()

            local Amount = #list
            local Val = (Amount * 20)
            function checkSizes()
                Amount = #list
                Val = (Amount * 20) + 20
            end
            for i,v in next, list do
                local optionButton = Instance.new("TextButton")

                optionButton.Name = "optionButton"
                optionButton.Parent = selectorContainer
                optionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.BackgroundTransparency = 1.000
                optionButton.Size = UDim2.new(0, 394, 0, 20)
                optionButton.AutoButtonColor = false
                optionButton.Font = Enum.Font.Code
                optionButton.Text = v
                optionButton.TextColor3 = Color3.fromRGB(160, 160, 160)
                optionButton.TextSize = 14.000
                if optionButton.Text == default then
                    optionButton.TextColor3 = Color3.fromRGB(159, 115, 255)
                    callback(selectorText.Text)
                end

                optionButton.MouseButton1Click:Connect(function()
                    for z,x in next, selectorContainer:GetChildren() do
                        if x:IsA("TextButton") then
                            TweenService:Create(x, TweenTable["selector"], {TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
                        end
                    end
                    TweenService:Create(optionButton, TweenTable["selector"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                    selectorText.Text = optionButton.Text
                    callback(optionButton.Text)
                end)

                selectorContainer.Size = UDim2.new(0, 394, 0, Val)
                selectorTwo.Size = UDim2.new(0, 394, 0, Val)
                selector.Size = UDim2.new(0, 396, 0, Val + 2)
                selectorFrame.Size = UDim2.new(0, 396, 0, Val + 26)

                UpdatePageSize()
                checkSizes()
            end

            UpdatePageSize()
            local SelectorFunctions = {}
            local AddAmount = 0
            function SelectorFunctions:AddOption(new, callback_f)
                new = new or "option"
                list[new] = new

                local optionButton = Instance.new("TextButton")

                AddAmount = AddAmount + 20

                optionButton.Name = "optionButton"
                optionButton.Parent = selectorContainer
                optionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.BackgroundTransparency = 1.000
                optionButton.Size = UDim2.new(0, 394, 0, 20)
                optionButton.AutoButtonColor = false
                optionButton.Font = Enum.Font.Code
                optionButton.Text = new
                optionButton.TextColor3 = Color3.fromRGB(140, 140, 140)
                optionButton.TextSize = 14.000
                if optionButton.Text == default then
                    optionButton.TextColor3 = Color3.fromRGB(159, 115, 255)
                    callback(selectorText.Text)
                end

                optionButton.MouseButton1Click:Connect(function()
                    for z,x in next, selectorContainer:GetChildren() do
                        if x:IsA("TextButton") then
                            TweenService:Create(x, TweenTable["selector"], {TextColor3 = Color3.fromRGB(140, 140, 140)}):Play()
                        end
                    end
                    TweenService:Create(optionButton, TweenTable["selector"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                    selectorText.Text = optionButton.Text
                    callback(optionButton.Text)
                end)

                checkSizes()
                selectorContainer.Size = UDim2.new(0, 394, 0, Val + AddAmount)
                selectorTwo.Size = UDim2.new(0, 394, 0, Val + AddAmount)
                selector.Size = UDim2.new(0, 396, 0, (Val + AddAmount) + 2)
                selectorFrame.Size = UDim2.new(0, 396, 0, (Val + AddAmount) + 26)

                UpdatePageSize()
                checkSizes()
                return SelectorFunctions
            end
            --
            local RemoveAmount = 0
            function SelectorFunctions:RemoveOption(option)
                list[option] = nil

                RemoveAmount = RemoveAmount + 20
                AddAmount = AddAmount - 20

                for i,v in pairs(selectorContainer:GetDescendants()) do
                    if v:IsA("TextButton") then
                        if v.Text == option then
                            v:Destroy()
                            selectorContainer.Size = UDim2.new(0, 394, 0, Val - RemoveAmount)
                            selectorTwo.Size = UDim2.new(0, 394, 0, Val - RemoveAmount)
                            selector.Size = UDim2.new(0, 396, 0, (Val - RemoveAmount) + 2)
                            selectorFrame.Size = UDim2.new(0, 396, 0, (Val + 6) - 20)
                        end
                    end
                end

                if selectorText.Text == option then
                    selectorText.Text = ". . ."
                end

                UpdatePageSize()
                checkSizes()
                return SelectorFunctions
            end
            --
            function SelectorFunctions:SetFunction(new)
                new = new or callback
                callback = new
                return SelectorFunctions
            end
            --
            function SelectorFunctions:Text(new)
                new = new or selectorLabel.Text
                selectorLabel.Text = new
                return SelectorFunctions
            end
            --
            function SelectorFunctions:Hide()
                selectorFrame.Visible = false
                return SelectorFunctions
            end
            --
            function SelectorFunctions:Show()
                selectorFrame.Visible = true
                return SelectorFunctions
            end
            --
            function SelectorFunctions:Remove()
                selectorFrame:Destroy()
                return SelectorFunctions
            end
            return SelectorFunctions
        end
        --
        function Components:NewDropdown(text, list, default, callback)
            text = text or "dropdown"
            list = list or {}
            default = default or ""
            callback = callback or function() end

            local dropdownFrame = Instance.new("Frame")
            local dropdownButton = Instance.new("TextButton")
            local dropdownButtonCorner = Instance.new("UICorner")
            local dropdownButtonBackground = Instance.new("Frame")
            local dropdownButtonGradient = Instance.new("UIGradient")
            local dropdownButtonCorner_2 = Instance.new("UICorner")
            local dropdownLabel = Instance.new("TextLabel")
            local dropdownLabelPadding = Instance.new("UIPadding")
            local dropdownArrow = Instance.new("TextLabel")
            local dropdownListFrame = Instance.new("Frame")
            local dropdownListCorner = Instance.new("UICorner")
            local dropdownListBackground = Instance.new("ScrollingFrame")
            local dropdownListGradient = Instance.new("UIGradient")
            local dropdownListCorner_2 = Instance.new("UICorner")
            local dropdownListLayout = Instance.new("UIListLayout")

            dropdownFrame.Name = "dropdownFrame"
            dropdownFrame.Parent = page
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dropdownFrame.BackgroundTransparency = 1.000
            dropdownFrame.ClipsDescendants = false
            dropdownFrame.Size = UDim2.new(0, 396, 0, 24)
            dropdownFrame.ZIndex = 5000

            dropdownButton.Name = "dropdownButton"
            dropdownButton.Parent = dropdownFrame
            dropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownButton.Size = UDim2.new(0, 396, 0, 24)
            dropdownButton.AutoButtonColor = false
            dropdownButton.Font = Enum.Font.SourceSans
            dropdownButton.Text = ""
            dropdownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            dropdownButton.TextSize = 14.000
            dropdownButton.ZIndex = 5001

            dropdownButtonCorner.CornerRadius = UDim.new(0, 2)
            dropdownButtonCorner.Name = "dropdownButtonCorner"
            dropdownButtonCorner.Parent = dropdownButton

            dropdownButtonBackground.Name = "dropdownButtonBackground"
            dropdownButtonBackground.Parent = dropdownButton
            dropdownButtonBackground.AnchorPoint = Vector2.new(0.5, 0.5)
            dropdownButtonBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dropdownButtonBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
            dropdownButtonBackground.Size = UDim2.new(0, 394, 0, 22)
            dropdownButtonBackground.ZIndex = 5002

            dropdownButtonGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            dropdownButtonGradient.Rotation = 90
            dropdownButtonGradient.Name = "dropdownButtonGradient"
            dropdownButtonGradient.Parent = dropdownButtonBackground

            dropdownButtonCorner_2.CornerRadius = UDim.new(0, 2)
            dropdownButtonCorner_2.Name = "dropdownButtonCorner"
            dropdownButtonCorner_2.Parent = dropdownButtonBackground

            dropdownLabel.Name = "dropdownLabel"
            dropdownLabel.Parent = dropdownButtonBackground
            dropdownLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dropdownLabel.BackgroundTransparency = 1.000
            dropdownLabel.Position = UDim2.new(0, 0, 0, 0)
            dropdownLabel.Size = UDim2.new(0, 340, 0, 22)
            dropdownLabel.Font = Enum.Font.Code
            dropdownLabel.Text = text .. ": " .. default
            dropdownLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            dropdownLabel.TextSize = 14.000
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.RichText = true
            dropdownLabel.ZIndex = 5003

            dropdownLabelPadding.Name = "dropdownLabelPadding"
            dropdownLabelPadding.Parent = dropdownLabel
            dropdownLabelPadding.PaddingLeft = UDim.new(0, 6)

            dropdownArrow.Name = "dropdownArrow"
            dropdownArrow.Parent = dropdownButtonBackground
            dropdownArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dropdownArrow.BackgroundTransparency = 1.000
            dropdownArrow.Position = UDim2.new(1, -30, 0, 0)
            dropdownArrow.Size = UDim2.new(0, 30, 0, 22)
            dropdownArrow.Font = Enum.Font.Code
            dropdownArrow.Text = "▼"
            dropdownArrow.TextColor3 = Color3.fromRGB(159, 115, 255)
            dropdownArrow.TextSize = 12.000
            dropdownArrow.ZIndex = 5003

            dropdownListFrame.Name = "dropdownListFrame"
            dropdownListFrame.Parent = dropdownFrame
            dropdownListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownListFrame.Position = UDim2.new(0, 0, 0, 26)
            dropdownListFrame.Size = UDim2.new(0, 396, 0, 0)
            dropdownListFrame.ClipsDescendants = true
            dropdownListFrame.Visible = false
            dropdownListFrame.ZIndex = 999999

            dropdownListCorner.CornerRadius = UDim.new(0, 2)
            dropdownListCorner.Name = "dropdownListCorner"
            dropdownListCorner.Parent = dropdownListFrame

            dropdownListBackground.Name = "dropdownListBackground"
            dropdownListBackground.Parent = dropdownListFrame
            dropdownListBackground.AnchorPoint = Vector2.new(0.5, 0.5)
            dropdownListBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dropdownListBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
            dropdownListBackground.Size = UDim2.new(0, 380, 0, 0)
            dropdownListBackground.ScrollBarThickness = 8
            dropdownListBackground.BorderSizePixel = 0
            dropdownListBackground.ScrollBarImageColor3 = Color3.fromRGB(159, 115, 255)
            dropdownListBackground.ScrollBarImageTransparency = 0
            dropdownListBackground.CanvasSize = UDim2.new(0, 0, 0, 0)
            dropdownListBackground.ScrollingEnabled = true
            dropdownListBackground.ElasticBehavior = Enum.ElasticBehavior.Never
            dropdownListBackground.ScrollingDirection = Enum.ScrollingDirection.Y
            dropdownListBackground.ZIndex = 999999

            dropdownListGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            dropdownListGradient.Rotation = 90
            dropdownListGradient.Name = "dropdownListGradient"
            dropdownListGradient.Parent = dropdownListBackground

            dropdownListCorner_2.CornerRadius = UDim.new(0, 2)
            dropdownListCorner_2.Name = "dropdownListCorner"
            dropdownListCorner_2.Parent = dropdownListBackground

            dropdownListLayout.Name = "dropdownListLayout"
            dropdownListLayout.Parent = dropdownListBackground
            dropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownListLayout.Padding = UDim.new(0, 2)

            CreateTween("dropdown", 0.2)
            
            local isOpen = false
            local selectedValue = default

            local function updateDropdownSize()
                local itemCount = 0
                for _, child in ipairs(dropdownListBackground:GetChildren()) do
                    if child:IsA("TextButton") then
                        itemCount = itemCount + 1
                    end
                end
                local contentHeight = itemCount * 22 + math.max(0, itemCount - 1) * 2
                local displayHeight = math.min(contentHeight, 200)
                dropdownListBackground.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
                return displayHeight, contentHeight
            end

            local function checkDropdownPosition()
                -- Check if dropdown should expand upward or downward
                local screenGui = dropdownFrame:FindFirstAncestorOfClass("ScreenGui")
                if not screenGui then return false end
                
                local dropdownAbsPos = dropdownFrame.AbsolutePosition
                local dropdownAbsSize = dropdownFrame.AbsoluteSize
                local screenSize = screenGui.AbsoluteSize
                
                -- Calculate space below dropdown
                local spaceBelow = screenSize.Y - (dropdownAbsPos.Y + dropdownAbsSize.Y)
                
                -- If less than 220px space below, expand upward
                return spaceBelow < 220
            end

            local function toggleDropdown()
                isOpen = not isOpen
                local displayHeight, contentHeight = updateDropdownSize()
                local targetHeight = isOpen and displayHeight or 0
                local targetBgHeight = isOpen and displayHeight or 0
                
                -- Determine direction to expand
                local expandUpward = checkDropdownPosition()
                
                if isOpen then
                    if expandUpward then
                        -- Position dropdown list above the button
                        dropdownListFrame.Position = UDim2.new(0, 0, 0, -(targetHeight + 6))
                    else
                        -- Position dropdown list below the button (default)
                        dropdownListFrame.Position = UDim2.new(0, 0, 0, 26)
                    end
                end
                
                dropdownListFrame.Visible = true
                TweenService:Create(dropdownListFrame, TweenTable["dropdown"], {Size = UDim2.new(0, 396, 0, targetHeight + 4)}):Play()
                TweenService:Create(dropdownListBackground, TweenTable["dropdown"], {Size = UDim2.new(0, 394, 0, targetBgHeight)}):Play()
                TweenService:Create(dropdownArrow, TweenTable["dropdown"], {Rotation = isOpen and 180 or 0}):Play()
                
                if not isOpen then
                    task.wait(0.2)
                    dropdownListFrame.Visible = false
                end
            end

            local clickStartPos = nil
            local clickStartTime = 0
            
            dropdownButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    clickStartPos = input.Position
                    clickStartTime = tick()
                end
            end)
            
            dropdownButton.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if clickStartPos then
                        local dragDistance = (input.Position - clickStartPos).Magnitude
                        local clickDuration = tick() - clickStartTime
                        -- Only toggle if it's a click (not a drag/scroll)
                        if dragDistance < 10 and clickDuration < 0.5 then
                            toggleDropdown()
                        end
                        clickStartPos = nil
                    end
                end
            end)

            for i, option in ipairs(list) do
                local optionButton = Instance.new("TextButton")
                
                optionButton.Name = "option_" .. option
                optionButton.Parent = dropdownListBackground
                optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                optionButton.Size = UDim2.new(0, 372, 0, 20)
                optionButton.AutoButtonColor = false
                optionButton.Font = Enum.Font.Code
                optionButton.Text = option
                optionButton.TextColor3 = option == default and Color3.fromRGB(159, 115, 255) or Color3.fromRGB(190, 190, 190)
                optionButton.TextSize = 14.000
                optionButton.ZIndex = 999999

                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 2)
                optionCorner.Parent = optionButton

                local optionClickStartPos = nil
                local optionClickStartTime = 0
                
                optionButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        optionClickStartPos = input.Position
                        optionClickStartTime = tick()
                    end
                end)
                
                optionButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if optionClickStartPos then
                            local dragDistance = (input.Position - optionClickStartPos).Magnitude
                            local clickDuration = tick() - optionClickStartTime
                            -- Only select if it's a click (not a scroll)
                            if dragDistance < 10 and clickDuration < 0.5 then
                                selectedValue = option
                                dropdownLabel.Text = text .. ": " .. option
                                
                                for _, child in ipairs(dropdownListBackground:GetChildren()) do
                                    if child:IsA("TextButton") then
                                        child.TextColor3 = Color3.fromRGB(190, 190, 190)
                                    end
                                end
                                optionButton.TextColor3 = Color3.fromRGB(159, 115, 255)
                                
                                callback(option)
                                toggleDropdown()
                            end
                            optionClickStartPos = nil
                        end
                    end
                end)

                optionButton.MouseEnter:Connect(function()
                    if optionButton.TextColor3 ~= Color3.fromRGB(159, 115, 255) then
                        TweenService:Create(optionButton, TweenTable["hover"], {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                    end
                end)

                optionButton.MouseLeave:Connect(function()
                    TweenService:Create(optionButton, TweenTable["hover"], {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                end)
            end

            dropdownButton.MouseEnter:Connect(function()
                TweenService:Create(dropdownButton, TweenTable["hover"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end)

            dropdownButton.MouseLeave:Connect(function()
                TweenService:Create(dropdownButton, TweenTable["hover"], {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end)

            UpdatePageSize()

            local DropdownFunctions = {}
            
            function DropdownFunctions:SetValue(value)
                if table.find(list, value) then
                    selectedValue = value
                    dropdownLabel.Text = text .. ": " .. value
                    callback(value)
                end
                return DropdownFunctions
            end
            
            function DropdownFunctions:GetValue()
                return selectedValue
            end
            
            function DropdownFunctions:AddOption(option)
                if not table.find(list, option) then
                    table.insert(list, option)
                    
                    local optionButton = Instance.new("TextButton")
                    
                    optionButton.Name = "option_" .. option
                    optionButton.Parent = dropdownListBackground
                    optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    optionButton.Size = UDim2.new(0, 372, 0, 20)
                    optionButton.AutoButtonColor = false
                    optionButton.Font = Enum.Font.Code
                    optionButton.Text = option
                    optionButton.TextColor3 = Color3.fromRGB(190, 190, 190)
                    optionButton.TextSize = 14.000
                    optionButton.ZIndex = 999999

                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 2)
                    optionCorner.Parent = optionButton

                    local addOptClickStartPos = nil
                    local addOptClickStartTime = 0
                    
                    optionButton.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            addOptClickStartPos = input.Position
                            addOptClickStartTime = tick()
                        end
                    end)
                    
                    optionButton.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            if addOptClickStartPos then
                                local dragDistance = (input.Position - addOptClickStartPos).Magnitude
                                local clickDuration = tick() - addOptClickStartTime
                                -- Only select if it's a click (not a scroll)
                                if dragDistance < 10 and clickDuration < 0.5 then
                                    selectedValue = option
                                    dropdownLabel.Text = text .. ": " .. option
                                    
                                    for _, child in ipairs(dropdownListBackground:GetChildren()) do
                                        if child:IsA("TextButton") then
                                            child.TextColor3 = Color3.fromRGB(190, 190, 190)
                                        end
                                    end
                                    optionButton.TextColor3 = Color3.fromRGB(159, 115, 255)
                                    
                                    callback(option)
                                    toggleDropdown()
                                end
                                addOptClickStartPos = nil
                            end
                        end
                    end)

                    optionButton.MouseEnter:Connect(function()
                        if optionButton.TextColor3 ~= Color3.fromRGB(159, 115, 255) then
                            TweenService:Create(optionButton, TweenTable["hover"], {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                        end
                    end)

                    optionButton.MouseLeave:Connect(function()
                        TweenService:Create(optionButton, TweenTable["hover"], {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                    end)
                    
                    updateDropdownSize()
                end
                return DropdownFunctions
            end
            
            function DropdownFunctions:RemoveOption(option)
                local index = table.find(list, option)
                if index then
                    table.remove(list, index)
                    for _, child in ipairs(dropdownListBackground:GetChildren()) do
                        if child:IsA("TextButton") and child.Text == option then
                            child:Destroy()
                            break
                        end
                    end
                    updateDropdownSize()
                end
                return DropdownFunctions
            end
            
            function DropdownFunctions:Hide()
                dropdownFrame.Visible = false
                return DropdownFunctions
            end
            
            function DropdownFunctions:Show()
                dropdownFrame.Visible = true
                return DropdownFunctions
            end
            
            function DropdownFunctions:Remove()
                dropdownFrame:Destroy()
                return DropdownFunctions
            end
            
            return DropdownFunctions
        end
        --

        function Components:NewColorPicker(text, default, callback)
            text = text or "color picker"
            default = default or Color3.fromRGB(159, 115, 255)
            callback = callback or function() end

            local colorFrame = Instance.new("Frame")
            local colorButton = Instance.new("TextButton")
            local colorLayout = Instance.new("UIListLayout")
            local colorLabel = Instance.new("TextLabel")
            local colorLabelPadding = Instance.new("UIPadding")
            local colorPreview = Instance.new("Frame")
            local colorPreviewCorner = Instance.new("UICorner")
            local colorPickerFrame = Instance.new("Frame")
            local colorPickerCorner = Instance.new("UICorner")
            local colorPickerGradient = Instance.new("UIGradient")
            local hueSlider = Instance.new("Frame")
            local hueSliderCorner = Instance.new("UICorner")
            local hueSliderButton = Instance.new("TextButton")
            local saturationFrame = Instance.new("Frame")
            local saturationCorner = Instance.new("UICorner")
            local saturationButton = Instance.new("TextButton")

            colorFrame.Name = "colorFrame"
            colorFrame.Parent = page
            colorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            colorFrame.BackgroundTransparency = 1.000
            colorFrame.ClipsDescendants = false
            colorFrame.Size = UDim2.new(0, 396, 0, 22)
            colorFrame.ZIndex = 100

            colorButton.Name = "colorButton"
            colorButton.Parent = colorFrame
            colorButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            colorButton.BackgroundTransparency = 1.000
            colorButton.Size = UDim2.new(0, 396, 0, 22)
            colorButton.AutoButtonColor = false
            colorButton.Font = Enum.Font.SourceSans
            colorButton.Text = ""
            colorButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            colorButton.TextSize = 14.000

            colorLayout.Name = "colorLayout"
            colorLayout.Parent = colorButton
            colorLayout.FillDirection = Enum.FillDirection.Horizontal
            colorLayout.SortOrder = Enum.SortOrder.LayoutOrder
            colorLayout.VerticalAlignment = Enum.VerticalAlignment.Center

            colorLabel.Name = "colorLabel"
            colorLabel.Parent = colorButton
            colorLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            colorLabel.BackgroundTransparency = 1.000
            colorLabel.Size = UDim2.new(0, 350, 0, 22)
            colorLabel.Font = Enum.Font.Code
            colorLabel.Text = text
            colorLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            colorLabel.TextSize = 14.000
            colorLabel.TextXAlignment = Enum.TextXAlignment.Left
            colorLabel.RichText = true

            colorLabelPadding.Name = "colorLabelPadding"
            colorLabelPadding.Parent = colorLabel
            colorLabelPadding.PaddingLeft = UDim.new(0, 6)

            colorPreview.Name = "colorPreview"
            colorPreview.Parent = colorButton
            colorPreview.BackgroundColor3 = default
            colorPreview.Size = UDim2.new(0, 36, 0, 18)

            colorPreviewCorner.CornerRadius = UDim.new(0, 2)
            colorPreviewCorner.Parent = colorPreview

            colorPickerFrame.Name = "colorPickerFrame"
            colorPickerFrame.Parent = colorFrame
            colorPickerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            colorPickerFrame.Position = UDim2.new(0, 0, 0, 24)
            colorPickerFrame.Size = UDim2.new(0, 396, 0, 0)
            colorPickerFrame.ClipsDescendants = true
            colorPickerFrame.Visible = false
            colorPickerFrame.ZIndex = 150

            colorPickerCorner.CornerRadius = UDim.new(0, 2)
            colorPickerCorner.Parent = colorPickerFrame

            colorPickerGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            colorPickerGradient.Rotation = 90
            colorPickerGradient.Parent = colorPickerFrame

            saturationFrame.Name = "saturationFrame"
            saturationFrame.Parent = colorPickerFrame
            saturationFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            saturationFrame.Position = UDim2.new(0, 10, 0, 10)
            saturationFrame.Size = UDim2.new(0, 340, 0, 140)
            saturationFrame.ZIndex = 151

            saturationCorner.CornerRadius = UDim.new(0, 2)
            saturationCorner.Parent = saturationFrame

            local satWhite = Instance.new("Frame")
            satWhite.Name = "white"
            satWhite.Parent = saturationFrame
            satWhite.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            satWhite.Size = UDim2.new(1, 0, 1, 0)
            satWhite.ZIndex = 152
            local satWhiteCorner = Instance.new("UICorner")
            satWhiteCorner.CornerRadius = UDim.new(0, 2)
            satWhiteCorner.Parent = satWhite
            local satWhiteGradient = Instance.new("UIGradient")
            satWhiteGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
            satWhiteGradient.Rotation = 0
            satWhiteGradient.Parent = satWhite

            local satBlack = Instance.new("Frame")
            satBlack.Name = "black"
            satBlack.Parent = saturationFrame
            satBlack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            satBlack.Size = UDim2.new(1, 0, 1, 0)
            satBlack.ZIndex = 153
            local satBlackCorner = Instance.new("UICorner")
            satBlackCorner.CornerRadius = UDim.new(0, 2)
            satBlackCorner.Parent = satBlack
            local satBlackGradient = Instance.new("UIGradient")
            satBlackGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
            satBlackGradient.Rotation = 90
            satBlackGradient.Parent = satBlack

            saturationButton.Name = "saturationButton"
            saturationButton.Parent = saturationFrame
            saturationButton.BackgroundTransparency = 1
            saturationButton.Size = UDim2.new(1, 0, 1, 0)
            saturationButton.Text = ""
            saturationButton.ZIndex = 154

            hueSlider.Name = "hueSlider"
            hueSlider.Parent = colorPickerFrame
            hueSlider.Position = UDim2.new(0, 360, 0, 10)
            hueSlider.Size = UDim2.new(0, 26, 0, 140)
            hueSlider.ZIndex = 151

            hueSliderCorner.CornerRadius = UDim.new(0, 2)
            hueSliderCorner.Parent = hueSlider

            local hueGradient = Instance.new("UIGradient")
            hueGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            }
            hueGradient.Rotation = 90
            hueGradient.Parent = hueSlider

            hueSliderButton.Name = "hueSliderButton"
            hueSliderButton.Parent = hueSlider
            hueSliderButton.BackgroundTransparency = 1
            hueSliderButton.Size = UDim2.new(1, 0, 1, 0)
            hueSliderButton.Text = ""
            hueSliderButton.ZIndex = 152

            CreateTween("colorpicker", 0.2)

            local hue, sat, val = 0, 1, 1
            local selectedColor = default
            local isOpen = false

            local function updateColor()
                selectedColor = Color3.fromHSV(hue, sat, val)
                colorPreview.BackgroundColor3 = selectedColor
                saturationFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                callback(selectedColor)
            end

            local function togglePicker()
                isOpen = not isOpen
                colorPickerFrame.Visible = true
                local targetHeight = isOpen and 160 or 0
                TweenService:Create(colorPickerFrame, TweenTable["colorpicker"], {Size = UDim2.new(0, 396, 0, targetHeight)}):Play()
                if not isOpen then
                    wait(0.2)
                    colorPickerFrame.Visible = false
                end
            end

            colorButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    togglePicker()
                end
            end)

            local hueDragging = false
            hueSliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = true
                    local function update()
                        local mousePos = UserInputService:GetMouseLocation().Y
                        local relativePos = math.clamp((mousePos - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                        hue = relativePos
                        updateColor()
                    end
                    update()
                    local moveConn
                    moveConn = UserInputService.InputChanged:Connect(function(inp)
                        if hueDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                            update()
                        end
                    end)
                    local releaseConn
                    releaseConn = UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            hueDragging = false
                            moveConn:Disconnect()
                            releaseConn:Disconnect()
                        end
                    end)
                end
            end)

            local satDragging = false
            saturationButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    satDragging = true
                    local function update()
                        local mousePos = UserInputService:GetMouseLocation()
                        local relativeX = math.clamp((mousePos.X - saturationFrame.AbsolutePosition.X) / saturationFrame.AbsoluteSize.X, 0, 1)
                        local relativeY = math.clamp((mousePos.Y - saturationFrame.AbsolutePosition.Y) / saturationFrame.AbsoluteSize.Y, 0, 1)
                        sat = relativeX
                        val = 1 - relativeY
                        updateColor()
                    end
                    update()
                    local moveConn
                    moveConn = UserInputService.InputChanged:Connect(function(inp)
                        if satDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                            update()
                        end
                    end)
                    local releaseConn
                    releaseConn = UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            satDragging = false
                            moveConn:Disconnect()
                            releaseConn:Disconnect()
                        end
                    end)
                end
            end)

            colorButton.MouseEnter:Connect(function()
                TweenService:Create(colorLabel, TweenTable["hover"], {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
            end)

            colorButton.MouseLeave:Connect(function()
                TweenService:Create(colorLabel, TweenTable["hover"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
            end)

            UpdatePageSize()

            local ColorPickerFunctions = {}

            function ColorPickerFunctions:SetColor(color)
                selectedColor = color
                colorPreview.BackgroundColor3 = color
                local h, s, v = Color3.toHSV(color)
                hue, sat, val = h, s, v
                saturationFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                callback(color)
                return ColorPickerFunctions
            end

            function ColorPickerFunctions:GetColor()
                return selectedColor
            end

            function ColorPickerFunctions:Hide()
                colorFrame.Visible = false
                return ColorPickerFunctions
            end

            function ColorPickerFunctions:Show()
                colorFrame.Visible = true
                return ColorPickerFunctions
            end

            function ColorPickerFunctions:Remove()
                colorFrame:Destroy()
                return ColorPickerFunctions
            end

            return ColorPickerFunctions
        end
        --

        function Components:NewSlider(text, suffix, compare, compareSign, values, callback)
            text = text or "slider"
            suffix = suffix or ""
            compare = compare or false
            compareSign = compareSign or "/"
            values = values or {
                min = values.min or 0,
                max = values.max or 100,
                default = values.default or 0
            }
            callback = callback or function() end

            values.max = values.max + 1

            local sliderFrame = Instance.new("Frame")
            local sliderFolder = Instance.new("Folder")
            local textboxFolderLayout = Instance.new("UIListLayout")
            local sliderButton = Instance.new("TextButton")
            local sliderButtonCorner = Instance.new("UICorner")
            local sliderBackground = Instance.new("Frame")
            local sliderButtonCorner_2 = Instance.new("UICorner")
            local sliderBackgroundGradient = Instance.new("UIGradient")
            local sliderBackgroundLayout = Instance.new("UIListLayout")
            local sliderIndicator = Instance.new("Frame")
            local sliderIndicatorStraint = Instance.new("UISizeConstraint")
            local sliderIndicatorGradient = Instance.new("UIGradient")
            local sliderIndicatorCorner = Instance.new("UICorner")
            local sliderBackgroundPadding = Instance.new("UIPadding")
            local sliderButtonLayout = Instance.new("UIListLayout")
            local sliderLabel = Instance.new("TextLabel")
            local sliderPadding = Instance.new("UIPadding")
            local sliderValue = Instance.new("TextLabel")

            sliderFrame.Name = "sliderFrame"
            sliderFrame.Parent = page
            sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderFrame.BackgroundTransparency = 1.000
            sliderFrame.ClipsDescendants = true
            sliderFrame.Position = UDim2.new(0.00499999989, 0, 0.667630076, 0)
            sliderFrame.Size = UDim2.new(0, 396, 0, 40)

            sliderFolder.Name = "sliderFolder"
            sliderFolder.Parent = sliderFrame

            textboxFolderLayout.Name = "textboxFolderLayout"
            textboxFolderLayout.Parent = sliderFolder
            textboxFolderLayout.FillDirection = Enum.FillDirection.Horizontal
            textboxFolderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            textboxFolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
            textboxFolderLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            textboxFolderLayout.Padding = UDim.new(0, 4)

            sliderButton.Name = "sliderButton"
            sliderButton.Parent = sliderFolder
            sliderButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            sliderButton.Position = UDim2.new(0.348484844, 0, 0.600000024, 0)
            sliderButton.Size = UDim2.new(0, 396, 0, 16)
            sliderButton.AutoButtonColor = false
            sliderButton.Font = Enum.Font.SourceSans
            sliderButton.Text = ""
            sliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            sliderButton.TextSize = 14.000

            sliderButtonCorner.CornerRadius = UDim.new(0, 2)
            sliderButtonCorner.Name = "sliderButtonCorner"
            sliderButtonCorner.Parent = sliderButton

            sliderBackground.Name = "sliderBackground"
            sliderBackground.Parent = sliderButton
            sliderBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderBackground.Size = UDim2.new(0, 394, 0, 14)
            sliderBackground.ClipsDescendants = true

            sliderButtonCorner_2.CornerRadius = UDim.new(0, 2)
            sliderButtonCorner_2.Name = "sliderButtonCorner"
            sliderButtonCorner_2.Parent = sliderBackground

            sliderBackgroundGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            sliderBackgroundGradient.Rotation = 90
            sliderBackgroundGradient.Name = "sliderBackgroundGradient"
            sliderBackgroundGradient.Parent = sliderBackground

            sliderBackgroundLayout.Name = "sliderBackgroundLayout"
            sliderBackgroundLayout.Parent = sliderBackground
            sliderBackgroundLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sliderBackgroundLayout.VerticalAlignment = Enum.VerticalAlignment.Center

            sliderIndicator.Name = "sliderIndicator"
            sliderIndicator.Parent = sliderBackground
            sliderIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderIndicator.BorderSizePixel = 0
            sliderIndicator.Position = UDim2.new(0, 0, -0.100000001, 0)
            sliderIndicator.Size = UDim2.new(0, 0, 0, 12)

            sliderIndicatorStraint.Name = "sliderIndicatorStraint"
            sliderIndicatorStraint.Parent = sliderIndicator
            sliderIndicatorStraint.MaxSize = Vector2.new(392, 12)

            sliderIndicatorGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(159, 115, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(128, 94, 208))}
            sliderIndicatorGradient.Rotation = 90
            sliderIndicatorGradient.Name = "sliderIndicatorGradient"
            sliderIndicatorGradient.Parent = sliderIndicator

            sliderIndicatorCorner.CornerRadius = UDim.new(0, 2)
            sliderIndicatorCorner.Name = "sliderIndicatorCorner"
            sliderIndicatorCorner.Parent = sliderIndicator

            sliderBackgroundPadding.Name = "sliderBackgroundPadding"
            sliderBackgroundPadding.Parent = sliderBackground
            sliderBackgroundPadding.PaddingBottom = UDim.new(0, 2)
            sliderBackgroundPadding.PaddingLeft = UDim.new(0, 1)
            sliderBackgroundPadding.PaddingRight = UDim.new(0, 1)
            sliderBackgroundPadding.PaddingTop = UDim.new(0, 2)

            sliderButtonLayout.Name = "sliderButtonLayout"
            sliderButtonLayout.Parent = sliderButton
            sliderButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            sliderButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sliderButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center

            sliderLabel.Name = "sliderLabel"
            sliderLabel.Parent = sliderFrame
            sliderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderLabel.BackgroundTransparency = 1.000
            sliderLabel.Size = UDim2.new(0, 396, 0, 24)
            sliderLabel.Font = Enum.Font.Code
            sliderLabel.Text = text
            sliderLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            sliderLabel.TextSize = 14.000
            sliderLabel.TextWrapped = true
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.RichText = true

            sliderPadding.Name = "sliderPadding"
            sliderPadding.Parent = sliderLabel
            sliderPadding.PaddingBottom = UDim.new(0, 6)
            sliderPadding.PaddingLeft = UDim.new(0, 2)
            sliderPadding.PaddingRight = UDim.new(0, 6)
            sliderPadding.PaddingTop = UDim.new(0, 6)

            sliderValue.Name = "sliderValue"
            sliderValue.Parent = sliderLabel
            sliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderValue.BackgroundTransparency = 1.000
            sliderValue.Position = UDim2.new(0.577319562, 0, 0, 0)
            sliderValue.Size = UDim2.new(0, 169, 0, 15)
            sliderValue.Font = Enum.Font.Code
            sliderValue.Text = values.default
            sliderValue.TextColor3 = Color3.fromRGB(140, 140, 140)
            sliderValue.TextSize = 14.000
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right


            local calc1 = values.max - values.min
            local calc2 = values.default - values.min
            local calc3 = calc2 / calc1
            local calc4 = calc3 * sliderBackground.AbsoluteSize.X
            local Calculation = calc4
            sliderIndicator.Size = UDim2.new(0, Calculation, 0, 12)
            sliderValue.Text = values.default

            CreateTween("slider_drag", 0.008)

            local ValueNum = values.default
            local slideText = compare and ValueNum .. compareSign .. tostring(values.max - 1) .. suffix or ValueNum .. suffix
            sliderValue.Text = slideText
            local isDragging = false
            local moveconnection
            local releaseconnection
            
            local function UpdateSlider(inputPos)
                if not isDragging then return end
                
                local relativePos = inputPos.X - sliderBackground.AbsolutePosition.X
                local clampedSize = math.clamp(relativePos, 0, sliderBackground.AbsoluteSize.X)
                
                TweenService:Create(sliderIndicator, TweenTable["slider_drag"], {Size = UDim2.new(0, clampedSize, 0, 12)}):Play()

                ValueNum = math.floor((((tonumber(values.max) - tonumber(values.min)) / sliderBackground.AbsoluteSize.X) * clampedSize) + tonumber(values.min)) or 0.00

                slideText = compare and ValueNum .. compareSign .. tostring(values.max - 1) .. suffix or ValueNum .. suffix
                sliderValue.Text = slideText

                pcall(function()
                    callback(ValueNum)
                end)
            end

            sliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    UpdateSlider(input.Position)
                    
                    moveconnection = UserInputService.InputChanged:Connect(function(inp)
                        if isDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                            UpdateSlider(inp.Position)
                        end
                    end)

                    releaseconnection = UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            isDragging = false
                            if moveconnection then moveconnection:Disconnect() end
                            if releaseconnection then releaseconnection:Disconnect() end
                        end
                    end)
                end
            end)

            UpdatePageSize()

            local SliderFunctions = {}
            function SliderFunctions:Value(new)
                local ncalc1 = new - values.min
                local ncalc2 = ncalc1 / calc1
                local ncalc3 = ncalc2 * sliderBackground.AbsoluteSize.X
                local nCalculation = ncalc3
                sliderIndicator.Size = UDim2.new(0, nCalculation, 0, 12)
                slideText = compare and new .. compareSign .. tostring(values.max - 1) .. suffix or new .. suffix
                sliderValue.Text = slideText
                return SliderFunctions
            end
            --
            function SliderFunctions:Max(new)
                new = new or values.max
                values.max = new + 1
                slideText = compare and ValueNum .. compareSign .. tostring(values.max - 1) .. suffix or ValueNum .. suffix
                return SliderFunctions
            end
            --
            function SliderFunctions:Min(new)
                new = new or values.min
                values.min = new
                slideText = compare and new .. compareSign .. tostring(values.max - 1) .. suffix or ValueNum .. suffix
                TweenService:Create(sliderIndicator, TweenTable["slider_drag"], {Size = UDim2.new(0, math.clamp(Mouse.X - sliderIndicator.AbsolutePosition.X, 0, sliderBackground.AbsoluteSize.X), 0, 12)}):Play()
                return SliderFunctions
            end
            --
            function SliderFunctions:SetFunction(new)
                new = new or callback
                callback = new
                return SliderFunctions
            end
            --
            function SliderFunctions:Text(new)
                new = new or sliderLabel.Text
                sliderLabel.Text = new
                return SliderFunctions
            end
            --
            function SliderFunctions:Hide()
                sliderFrame.Visible = false
                return SliderFunctions
            end
            --
            function SliderFunctions:Show()
                sliderFrame.Visible = true
                return SliderFunctions
            end
            --
            function SliderFunctions:Remove()
                sliderFrame:Destroy()
                return SliderFunctions
            end
            return SliderFunctions
        end
        --
        function Components:NewSeperator()
            local sectionFrame = Instance.new("Frame")
            local sectionLayout = Instance.new("UIListLayout")
            local rightBar = Instance.new("Frame")

            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = page
            sectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sectionFrame.BackgroundTransparency = 1.000
            sectionFrame.ClipsDescendants = true
            sectionFrame.Position = UDim2.new(0.00499999989, 0, 0.361271679, 0)
            sectionFrame.Size = UDim2.new(0, 396, 0, 12)

            sectionLayout.Name = "sectionLayout"
            sectionLayout.Parent = sectionFrame
            sectionLayout.FillDirection = Enum.FillDirection.Horizontal
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            sectionLayout.Padding = UDim.new(0, 4)

            rightBar.Name = "rightBar"
            rightBar.Parent = sectionFrame
            rightBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            rightBar.BorderSizePixel = 0
            rightBar.Position = UDim2.new(0.308080822, 0, 0.479166657, 0)
            rightBar.Size = UDim2.new(0, 403, 0, 1)

            UpdatePageSize()

            local SeperatorFunctions = {}
            function SeperatorFunctions:Hide()
                sectionFrame.Visible = false
                return SeperatorFunctions
            end
            --
            function SeperatorFunctions:Show()
                sectionFrame.Visible = true
                return SeperatorFunctions
            end
            --
            function SeperatorFunctions:Remove()
                sectionFrame:Destroy()
                return SeperatorFunctions
            end
            return SeperatorFunctions
        end
        --
        function Components:Open()
            TabLibrary.CurrentTab = title
            for i,v in pairs(container:GetChildren()) do 
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            page.Visible = true

            for i,v in pairs(tabButtons:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenTable["tab_text_colour"], {TextColor3 = Color3.fromRGB(170, 170, 170)}):Play()
                end
            end
            TweenService:Create(tabButton, TweenTable["tab_text_colour"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()

            return Components
        end
        --
        function Components:Remove()
            tabButton:Destroy()
            page:Destroy()

            return Components
        end
        --
        function Components:Hide()
            tabButton.Visible = false
            page.Visible = false

            return Components
        end
        --
        function Components:Show()
            tabButton.Visible = true

            return Components
        end
        --
        function Components:Text(text)
            text = text or "new text"
            tabButton.Text = text

            return Components
        end
        return Components
    end
    --
    function TabLibrary:Remove()
        screen:Destroy()

        return TabLibrary
    end
    --
    function TabLibrary:Text(text)
        text = text or "new text"
        headerLabel.Text = text

        return TabLibrary
    end
    --
    function TabLibrary:UpdateKeybind(new)
        new = new or key
        key = new
        return TabLibrary
    end
    return TabLibrary
end
return library
