local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Acrylic = require(script.Parent.Acrylic)
local Creator = require(script.Parent.Creator)
local Elements = require(script.Parent.Elements)

local Libu = {
    Theme = {
        Background = Color3.fromRGB(20, 20, 25),
        Element = Color3.fromRGB(30, 30, 38),
        Border = Color3.fromRGB(50, 50, 60),
        Accent = Color3.fromRGB(0, 180, 255),
        Text = Color3.fromRGB(240, 240, 250),
        SubText = Color3.fromRGB(160, 160, 175)
    },
    MinimizeKey = Enum.KeyCode.LeftControl,
    Open = true,
    Window = nil
}

function Libu:CreateWindow(config)
    local title = config.Title or "libu.net"
    local size = config.Size or UDim2.fromOffset(500, 380)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "libu_net_gui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = size
    MainFrame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    MainFrame.BackgroundColor3 = self.Theme.Background
    MainFrame.BackgroundTransparency = 0.35
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = self.Theme.Border
    Stroke.Thickness = 1

    -- Активация размытия
    Acrylic.CreateBlur(MainFrame)
    Creator.Dragify(MainFrame)

    -- Сайдбар
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -50)
    Sidebar.Position = UDim2.fromOffset(10, 45)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = MainFrame

    local UIListLayout_Side = Instance.new("UIListLayout")
    UIListLayout_Side.Padding = UDim.new(0, 5)
    UIListLayout_Side.Parent = Sidebar

    -- Заголовок
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 35)
    TitleLabel.Position = UDim2.fromOffset(10, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextSize = 15
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = MainFrame

    -- Контейнер страниц
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -170, 1, -55)
    Container.Position = UDim2.fromOffset(160, 45)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local Window = { MainFrame = MainFrame, Tabs = {}, ActiveTab = nil }
    self.Window = Window

    function Window:AddTab(tabTitle)
        local Tab = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = Libu.Theme.Element
        TabButton.BackgroundTransparency = 1
        TabButton.Text = tabTitle
        TabButton.TextColor3 = Libu.Theme.SubText
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Parent = Sidebar

        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)

        local ScrollPage = Instance.new("ScrollingFrame")
        ScrollPage.Size = UDim2.fromScale(1, 1)
        ScrollPage.BackgroundTransparency = 1
        ScrollPage.BorderSizePixel = 0
        ScrollPage.Visible = false
        ScrollPage.ScrollBarThickness = 2
        ScrollPage.ScrollBarImageColor3 = Libu.Theme.Border
        ScrollPage.Parent = Container

        local UIListLayout_Page = Instance.new("UIListLayout")
        UIListLayout_Page.Padding = UDim.new(0, 6)
        UIListLayout_Page.Parent = ScrollPage

        UIListLayout_Page:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrollPage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_Page.AbsoluteContentSize.Y + 10)
        end)

        function Tab:Select()
            if Window.ActiveTab then
                Window.ActiveTab.ScrollPage.Visible = false
                TweenService:Create(Window.ActiveTab.TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Libu.Theme.SubText}):Play()
            end
            Window.ActiveTab = Tab
            ScrollPage.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, TextColor3 = Libu.Theme.Text}):Play()
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)

        function Tab:AddButton(btnTitle, callback)
            Elements.AddButton(ScrollPage, Libu.Theme, btnTitle, callback)
        end

        function Tab:AddToggle(togTitle, default, callback)
            Elements.AddToggle(ScrollPage, Libu.Theme, togTitle, default, callback)
        end

        function Tab:AddSlider(sldTitle, min, max, default, callback)
            Elements.AddSlider(ScrollPage, Libu.Theme, sldTitle, min, max, default, callback)
        end

        Tab.TabButton = TabButton
        Tab.ScrollPage = ScrollPage

        if #Window.Tabs == 0 then
            task.defer(function() Tab:Select() end)
        end
        table.insert(Window.Tabs, Tab)
        return Tab
    end

    return Window
end

-- Скрытие на LeftControl
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Libu.MinimizeKey and Libu.Window then
        Libu.Open = not Libu.Open
        Libu.Window.MainFrame.Visible = Libu.Open
    end
end)

return Libu
