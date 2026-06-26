local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Elements = {}

function Elements.AddButton(parent, theme, title, callback)
    local Base = Instance.new("Frame")
    Base.Size = UDim2.new(1, -5, 0, 38)
    Base.BackgroundColor3 = theme.Element
    Base.BorderSizePixel = 0
    Base.Parent = parent

    Instance.new("UICorner", Base).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Base).Color = theme.Border

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -110, 1, 0)
    TextLabel.Position = UDim2.fromOffset(10, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = title
    TextLabel.TextColor3 = theme.Text
    TextLabel.TextSize = 13
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Base

    local RealButton = Instance.new("TextButton")
    RealButton.Size = UDim2.fromOffset(90, 26)
    RealButton.Position = UDim2.new(1, -100, 0.5, 0)
    RealButton.AnchorPoint = Vector2.new(0, 0.5)
    RealButton.BackgroundColor3 = theme.Accent
    RealButton.Text = "Trigger"
    RealButton.TextColor3 = Color3.new(1, 1, 1)
    RealButton.TextSize = 12
    RealButton.Font = Enum.Font.GothamBold
    RealButton.Parent = Base

    Instance.new("UICorner", RealButton).CornerRadius = UDim.new(0, 4)

    RealButton.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)
end

function Elements.AddToggle(parent, theme, title, default, callback)
    local state = default
    local Base = Instance.new("Frame")
    Base.Size = UDim2.new(1, -5, 0, 38)
    Base.BackgroundColor3 = theme.Element
    Base.BorderSizePixel = 0
    Base.Parent = parent

    Instance.new("UICorner", Base).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Base).Color = theme.Border

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -60, 1, 0)
    TextLabel.Position = UDim2.fromOffset(10, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = title
    TextLabel.TextColor3 = theme.Text
    TextLabel.TextSize = 13
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Base

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.fromOffset(40, 20)
    Switch.Position = UDim2.new(1, -50, 0.5, 0)
    Switch.AnchorPoint = Vector2.new(0, 0.5)
    Switch.BackgroundColor3 = state and theme.Accent or Color3.fromRGB(60, 60, 70)
    Switch.Text = ""
    Switch.Parent = Base

    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.fromOffset(14, 14)
    Dot.Position = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    Dot.AnchorPoint = Vector2.new(0, 0.5)
    Dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Dot.Parent = Switch

    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    Switch.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local targetColor = state and theme.Accent or Color3.fromRGB(60, 60, 70)
        
        TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        
        task.spawn(callback, state)
    end)
end

function Elements.AddSlider(parent, theme, title, min, max, default, callback)
    local Base = Instance.new("Frame")
    Base.Size = UDim2.new(1, -5, 0, 48)
    Base.BackgroundColor3 = theme.Element
    Base.BorderSizePixel = 0
    Base.Parent = parent

    Instance.new("UICorner", Base).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Base).Color = theme.Border

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -120, 0, 20)
    TextLabel.Position = UDim2.fromOffset(10, 5)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = title
    TextLabel.TextColor3 = theme.Text
    TextLabel.TextSize = 13
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Base

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 100, 0, 20)
    ValueLabel.Position = UDim2.new(1, -110, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = theme.SubText
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Base

    local Bar = Instance.new("TextButton")
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.Position = UDim2.fromOffset(10, 32)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Bar.Text = ""
    Bar.Parent = Base

    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.fromScale((default - min) / (max - min), 1)
    Fill.BackgroundColor3 = theme.Accent
    Fill.Parent = Bar

    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local function updateSlider(input)
        local percentage = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * percentage))
        
        Fill.Size = UDim2.fromScale(percentage, 1)
        ValueLabel.Text = tostring(value)
        task.spawn(callback, value)
    end

    local dragging = false
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

return Elements
