-- DubuLib - Simple UI Library with Rayfield-style Dropdowns
-- Based on DubuUI but simplified

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local GUI = {}
GUI.CurrentTab = nil
GUI._connections = {}
GUI._cleanup = {}

function GUI:AddConnection(conn)
    if conn then table.insert(GUI._connections, conn) end
end

function GUI:RegisterCleanup(func)
    if type(func) == "function" then table.insert(GUI._cleanup, func) end
end

function GUI:Cleanup()
    for _, c in ipairs(self._connections) do
        pcall(function()
            if c and c.Disconnect then c:Disconnect() end
        end)
    end
    for _, f in ipairs(self._cleanup) do
        pcall(f)
    end
    self._connections = {}
    self._cleanup = {}
end

local DefaultTheme = {
    Background = Color3.fromRGB(10, 10, 15),
    Secondary = Color3.fromRGB(20, 20, 25),
    Accent = Color3.fromRGB(255, 20, 147),
    AccentSecondary = Color3.fromRGB(219, 39, 119),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(170, 170, 180),
    Border = Color3.fromRGB(50, 50, 60),
    NavBackground = Color3.fromRGB(15, 15, 20),
    Surface = Color3.fromRGB(25, 25, 35),
    SurfaceVariant = Color3.fromRGB(35, 35, 50),
    Success = Color3.fromRGB(40, 201, 64),
    Warning = Color3.fromRGB(255, 189, 46),
    Error = Color3.fromRGB(255, 95, 87),
    Shadow = Color3.fromRGB(0, 0, 0)
}

local Theme = DefaultTheme

local function truncateText(text, maxLen)
    if #text > maxLen then
        return string.sub(text, 1, maxLen - 2) .. ".."
    end
    return text
end

local function fadeIn(object, duration)
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = object.BackgroundTransparency and 0 or object.BackgroundTransparency
    })
    tween:Play()
end

local function applyGradient(frame, color1, color2, rotation)
    rotation = rotation or 0
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }
    gradient.Rotation = rotation
    gradient.Parent = frame
    return gradient
end

function GUI:CreateMain(config)
    local settings = {
        Name = config.Name or "DubuLib",
        title = config.title or "DubuLib UI",
        ToggleUI = config.ToggleUI or "K",
        Theme = config.Theme or DefaultTheme,
    }

    if config.Theme then
        Theme = config.Theme
    end

    -- Create main frame
    local MainFrame = Instance.new("ScreenGui")
    MainFrame.Name = settings.Name
    MainFrame.ResetOnSpawn = false
    MainFrame.DisplayOrder = 999999999
    MainFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = MainFrame
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 680, 0, 450)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    -- Apply subtle gradient to main frame
    applyGradient(Main, Theme.Background, Color3.fromRGB(15, 10, 20), 45)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1
    MainStroke.Color = Theme.Border
    MainStroke.Parent = Main

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = Main
    TitleBar.BackgroundColor3 = Theme.NavBackground
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 40)

    -- Apply pink gradient to title bar
    applyGradient(TitleBar, Theme.NavBackground, Color3.fromRGB(255, 20, 147), 90)

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = settings.title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Font = Enum.Font.Gotham
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Theme.TextSecondary
    CloseButton.TextSize = 16
    CloseButton.ZIndex = 10
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Font = Enum.Font.Gotham
    MinimizeButton.Text = "─"
    MinimizeButton.TextColor3 = Theme.TextSecondary
    MinimizeButton.TextSize = 16
    MinimizeButton.ZIndex = 10

    -- Add hover effects to MinimizeButton
    MinimizeButton.MouseEnter:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {
            TextColor3 = Theme.Accent,
            TextSize = 18
        }):Play()
    end)

    MinimizeButton.MouseLeave:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {
            TextColor3 = Theme.TextSecondary,
            TextSize = 16
        }):Play()
    end)

    -- Add hover effects to CloseButton
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            TextColor3 = Theme.Error,
            TextSize = 18
        }):Play()
    end)

    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            TextColor3 = Theme.TextSecondary,
            TextSize = 16
        }):Play()
    end)

    -- Navigation
    local NavBar = Instance.new("Frame")
    NavBar.Name = "NavBar"
    NavBar.Parent = Main
    NavBar.BackgroundColor3 = Theme.NavBackground
    NavBar.BorderSizePixel = 0
    NavBar.Position = UDim2.new(0, 0, 0, 40)
    NavBar.Size = UDim2.new(0, 150, 1, -40)

    local NavCorner = Instance.new("UICorner")
    NavCorner.CornerRadius = UDim.new(0, 0)
    NavCorner.Parent = NavBar

    local NavList = Instance.new("UIListLayout")
    NavList.Parent = NavBar
    NavList.Padding = UDim.new(0, 5)
    NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local NavPadding = Instance.new("UIPadding")
    NavPadding.Parent = NavBar
    NavPadding.PaddingTop = UDim.new(0, 10)

    -- Content area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 150, 0, 40)
    Content.Size = UDim2.new(1, -150, 1, -40)

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = Content

    local ScrollTheme = Instance.new("ScrollingFrame")
    ScrollTheme.Name = "ScrollTheme"
    ScrollTheme.Parent = Content
    ScrollTheme.BackgroundTransparency = 1
    ScrollTheme.BorderSizePixel = 0
    ScrollTheme.Position = UDim2.new(0, 10, 0, 10)
    ScrollTheme.Size = UDim2.new(1, -20, 1, -20)
    ScrollTheme.ScrollBarThickness = 6
    ScrollTheme.ScrollBarImageColor3 = Theme.Accent
    ScrollTheme.CanvasSize = UDim2.new(0, 0, 0, 1)
    
    -- Create scrollbar padding to make it look better
    local ScrollPadding = Instance.new("UIPadding")
    ScrollPadding.Parent = ScrollTheme
    ScrollPadding.PaddingRight = UDim.new(0, 3)

    local ThemeList = Instance.new("UIListLayout")
    ThemeList.Parent = ScrollTheme
    ThemeList.Padding = UDim.new(0, 10)
    ThemeList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local ThemePadding = Instance.new("UIPadding")
    ThemePadding.Parent = ScrollTheme
    ThemePadding.PaddingTop = UDim.new(0, 5)

    MainFrame.Parent = game:GetService("CoreGui").RobloxGui

    -- Ensure cleanup when main GUI is destroyed
    local destroyConn = MainFrame.Destroying:Connect(function()
        GUI:Cleanup()
    end)
    GUI:AddConnection(destroyConn)

    -- Make draggable
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        MainFrame:Destroy()
    end)

    local minimized = false
    local floatingButton = nil
    local floatingGui = nil

    -- Create draggable floating restore button
    local function createFloatingRestoreButton()
        if floatingButton then return end

        floatingGui = Instance.new("ScreenGui")
        floatingGui.Name = "DubuLibFloatingRestore"
        floatingGui.ResetOnSpawn = false
        floatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        floatingGui.Parent = game:GetService("CoreGui")

        floatingButton = Instance.new("Frame")
        floatingButton.Name = "RestoreButton"
        floatingButton.Parent = floatingGui
        floatingButton.BackgroundColor3 = Theme.Accent
        floatingButton.BorderSizePixel = 0
        floatingButton.Size = UDim2.new(0, 60, 0, 60)
        floatingButton.Position = UDim2.new(1, -80, 0, 20) -- Top right corner
        floatingButton.AnchorPoint = Vector2.new(0, 0)

        local floatingCorner = Instance.new("UICorner")
        floatingCorner.CornerRadius = UDim.new(0, 12)
        floatingCorner.Parent = floatingButton

        local floatingStroke = Instance.new("UIStroke")
        floatingStroke.Thickness = 2
        floatingStroke.Color = Theme.Accent
        floatingStroke.Parent = floatingButton

        local buttonText = Instance.new("TextLabel")
        buttonText.Parent = floatingButton
        buttonText.Size = UDim2.new(1, 0, 1, 0)
        buttonText.BackgroundTransparency = 1
        buttonText.Font = Enum.Font.GothamBold
        buttonText.Text = "↑"
        buttonText.TextColor3 = Theme.Text
        buttonText.TextSize = 26

    -- Make floating button draggable
        local dragging = false
        local dragInput = nil
        local dragStart = nil
        local startPos = nil
        local dragDistance = 0

        floatingButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                dragDistance = 0
                startPos = floatingButton.Position
                
                -- Visual feedback
                TweenService:Create(floatingButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Theme.Secondary
                }):Play()
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                            input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                dragDistance = (delta).Magnitude
                local camera = workspace.CurrentCamera
                local screenSize = camera.ViewportSize
                
                -- Clamp position to screen bounds
                local newX = math.clamp(startPos.X.Offset + delta.X, 0, screenSize.X - 60)
                local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, screenSize.Y - 60)
                
                floatingButton.Position = UDim2.new(0, newX, 0, newY)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                -- Only trigger restore if drag distance is small (actual click, not drag)
                if dragDistance < 10 then
                    restoreGUI()
                end
                
                dragging = false
                
                -- Reset visual
                TweenService:Create(floatingButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = Theme.Accent
                }):Play()
            end
        end)

        -- Hover effects
        floatingButton.MouseEnter:Connect(function()
            if not dragging then
                TweenService:Create(floatingButton, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 65, 0, 65)
                }):Play()
                TweenService:Create(floatingStroke, TweenInfo.new(0.2), {
                    Color = Theme.Secondary,
                    Thickness = 3
                }):Play()
            end
        end)

        floatingButton.MouseLeave:Connect(function()
            if not dragging then
                TweenService:Create(floatingButton, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 60, 0, 60)
                }):Play()
                TweenService:Create(floatingStroke, TweenInfo.new(0.2), {
                    Color = Theme.Accent,
                    Thickness = 2
                }):Play()
            end
        end)

        -- Cleanup on destroy
        floatingGui.AncestryChanged:Connect(function()
            if not floatingGui.Parent then
                floatingButton = nil
                floatingGui = nil
            end
        end)
    end

    -- Hide floating button
    local function hideFloatingButton()
        if floatingButton and floatingButton.Parent then
            TweenService:Create(floatingButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.2)
            floatingGui:Destroy()
            floatingButton = nil
            floatingGui = nil
        end
    end

    -- Minimize GUI
    local function minimizeGUI()
        minimized = true
        MainFrame.Enabled = false
        createFloatingRestoreButton()
    end

    -- Restore GUI
    function restoreGUI()
        minimized = false
        MainFrame.Enabled = true
        hideFloatingButton()
    end

    MinimizeButton.MouseButton1Click:Connect(function()
        minimizeGUI()
    end)

    -- Toggle UI
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode[settings.ToggleUI] then
            MainFrame.Enabled = not MainFrame.Enabled
        end
    end)

    GUI.MainFrame = MainFrame
    GUI.Main = Main
    GUI.Content = ScrollTheme
    GUI.NavBar = NavBar

    return GUI
end

function GUI:CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Parent = self.NavBar
    TabButton.BackgroundColor3 = Theme.Secondary
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(0.9, 0, 0, 35)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = name
    TabButton.TextColor3 = Theme.TextSecondary
    TabButton.TextSize = 13

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton

    -- Add hover effects to TabButton
    TabButton.MouseEnter:Connect(function()
        if TabButton.BackgroundColor3 ~= Theme.Accent then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Surface
            }):Play()
        end
    end)

    TabButton.MouseLeave:Connect(function()
        if TabButton.BackgroundColor3 ~= Theme.Accent then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Secondary
            }):Play()
        end
    end)

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = self.Content
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.Size = UDim2.new(1, -20, 1, -20)
    TabContent.ScrollBarThickness = 6
    TabContent.ScrollBarImageColor3 = Theme.Accent
    TabContent.Visible = false

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContent
    TabList.Padding = UDim.new(0, 10)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContent
    TabPadding.PaddingTop = UDim.new(0, 5)

    local function hideAllTabs()
        for _, child in ipairs(self.Content:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        for _, child in ipairs(self.NavBar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Theme.Secondary
                child.TextColor3 = Theme.TextSecondary
            end
        end
    end

    TabButton.MouseButton1Click:Connect(function()
        hideAllTabs()
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Theme.Accent
        TabButton.TextColor3 = Theme.Text
    end)

    -- Select first tab by default
    if self.CurrentTab == nil then
        self.CurrentTab = name
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Theme.Accent
        TabButton.TextColor3 = Theme.Text
    end

    TabContent.ScrollCanvasPosition = Vector2.new(0, 0)

    return TabContent
end

function GUI:CreateSection(config)
    local parent = config.parent or config.Parent
    local text = config.text or config.Text or "Section"

    local Section = Instance.new("Frame")
    Section.Name = text
    Section.Parent = parent
    Section.BackgroundColor3 = Theme.Surface
    Section.BorderSizePixel = 0
    Section.Size = UDim2.new(1, 0, 0, 35)

    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
    SectionCorner.Parent = Section

    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Name = "Label"
    SectionLabel.Parent = Section
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Position = UDim2.new(0, 10, 0, 0)
    SectionLabel.Size = UDim2.new(1, -20, 1, 0)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Text = text
    SectionLabel.TextColor3 = Theme.Accent
    SectionLabel.TextSize = 12
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

    return Section
end

function GUI:CreateToggle(config)
    local parent = config.parent or config.Parent
    local text = config.text or config.Text or "Toggle"
    local default = config.default or false
    local callback = config.callback or function() end

    local flag = text:gsub("%s+", "")
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Theme.Secondary
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame:SetAttribute("Flag", flag)
    ToggleFrame:SetAttribute("Value", tostring(default))

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Theme.Text
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Toggle"
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = default and Theme.Success or Theme.Border
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -35, 0.5, -12)
    ToggleButton.Size = UDim2.new(0, 24, 0, 24)
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.Text = ""
    ToggleButton.TextColor3 = Theme.Text
    ToggleButton.TextSize = 12

    local ToggleCorner2 = Instance.new("UICorner")
    ToggleCorner2.CornerRadius = UDim.new(0, 6)
    ToggleCorner2.Parent = ToggleButton

    local ToggleLabel2 = Instance.new("TextLabel")
    ToggleLabel2.Name = "Indicator"
    ToggleLabel2.Parent = ToggleButton
    ToggleLabel2.BackgroundTransparency = 1
    ToggleLabel2.Size = UDim2.new(1, 0, 1, 0)
    ToggleLabel2.Font = Enum.Font.GothamBold
    ToggleLabel2.Text = default and "✔" or ""
    ToggleLabel2.TextColor3 = Theme.Text
    ToggleLabel2.TextSize = 12

    local currentValue = default
    ToggleButton.MouseButton1Click:Connect(function()
        currentValue = not currentValue
        ToggleButton.BackgroundColor3 = currentValue and Theme.Success or Theme.Border
        ToggleLabel2.Text = currentValue and "✔" or ""
        ToggleFrame:SetAttribute("Value", tostring(currentValue))
        callback(currentValue)
    end)

    return ToggleFrame
end

function GUI:CreateButton(config)
    local parent = config.parent or config.Parent
    local text = config.text or config.Text or "Button"
    local callback = config.callback or function() end

    local Button = Instance.new("TextButton")
    Button.Name = text
    Button.Parent = parent
    Button.BackgroundColor3 = Theme.Accent
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Font = Enum.Font.GothamBold
    Button.Text = text
    Button.TextColor3 = Theme.Text
    Button.TextSize = 13

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        callback()
    end)

    Button.MouseEnter:Connect(function()
        Button:TweenSize(UDim2.new(1, 0, 0, 37), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1)
    end)

    Button.MouseLeave:Connect(function()
        Button:TweenSize(UDim2.new(1, 0, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1)
    end)

    return Button
end

function GUI:CreateParagraph(config)
    local parent = config.parent or config.Parent
    local text = config.text or config.Text or "Paragraph"

    local Paragraph = Instance.new("Frame")
    Paragraph.Name = "Paragraph"
    Paragraph.Parent = parent
    Paragraph.BackgroundColor3 = Theme.SurfaceVariant
    Paragraph.BorderSizePixel = 0
    Paragraph.Size = UDim2.new(1, 0, 0, 70)

    local ParagraphCorner = Instance.new("UICorner")
    ParagraphCorner.CornerRadius = UDim.new(0, 6)
    ParagraphCorner.Parent = Paragraph

    local ParagraphLabel = Instance.new("TextLabel")
    ParagraphLabel.Name = "Text"
    ParagraphLabel.Parent = Paragraph
    ParagraphLabel.BackgroundTransparency = 1
    ParagraphLabel.Position = UDim2.new(0, 10, 0, 5)
    ParagraphLabel.Size = UDim2.new(1, -20, 1, -10)
    ParagraphLabel.Font = Enum.Font.Gotham
    ParagraphLabel.Text = text
    ParagraphLabel.TextColor3 = Theme.TextSecondary
    ParagraphLabel.TextSize = 11
    ParagraphLabel.TextWrapped = true
    ParagraphLabel.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphLabel.TextYAlignment = Enum.TextYAlignment.Top

    return Paragraph
end

function GUI:CreateInput(config)
    local parent = config.parent or config.Parent
    local text = config.text or config.Text or "Input"
    local default = config.default or ""
    local callback = config.callback or function() end

    local InputFrame = Instance.new("Frame")
    InputFrame.Name = text
    InputFrame.Parent = parent
    InputFrame.BackgroundColor3 = Theme.Secondary
    InputFrame.BorderSizePixel = 0
    InputFrame.Size = UDim2.new(1, 0, 0, 35)

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = InputFrame

    local InputLabel = Instance.new("TextLabel")
    InputLabel.Name = "Label"
    InputLabel.Parent = InputFrame
    InputLabel.BackgroundTransparency = 1
    InputLabel.Position = UDim2.new(0, 10, 0, 0)
    InputLabel.Size = UDim2.new(0.4, 0, 1, 0)
    InputLabel.Font = Enum.Font.Gotham
    InputLabel.Text = text
    InputLabel.TextColor3 = Theme.Text
    InputLabel.TextSize = 13
    InputLabel.TextXAlignment = Enum.TextXAlignment.Left

    local InputBox = Instance.new("TextBox")
    InputBox.Name = "Input"
    InputBox.Parent = InputFrame
    InputBox.BackgroundColor3 = Theme.Surface
    InputBox.BorderSizePixel = 0
    InputBox.Position = UDim2.new(0.45, 5, 0.5, -12)
    InputBox.Size = UDim2.new(0.53, -10, 0, 24)
    InputBox.Font = Enum.Font.Gotham
    InputBox.PlaceholderColor3 = Theme.TextSecondary
    InputBox.PlaceholderText = default
    InputBox.Text = ""
    InputBox.TextColor3 = Theme.Text
    InputBox.TextSize = 12

    local InputBoxCorner = Instance.new("UICorner")
    InputBoxCorner.CornerRadius = UDim.new(0, 4)
    InputBoxCorner.Parent = InputBox

    InputBox.FocusLost:Connect(function()
        callback(InputBox.Text)
    end)

    return InputFrame
end

-- Rayfield-style Dropdown
function GUI:CreateDropdown(config)
    local parent = config.parent or config.Parent
    local text = config.text or config.Text or "Dropdown"
    local rawOptions = config.options or config.Options or {}
    local default = config.default or (type(rawOptions[1]) == "table" and rawOptions[1].text) or rawOptions[1]
    local callback = config.callback or function() end
    local multi = config.multi or false
    local searchable = config.searchable ~= false
    local maxHeight = config.maxHeight or 200

    local flag = text:gsub("%s+", "")
    local selected = {}
    local currentOptions = {}
    for i, v in ipairs(rawOptions) do
        if type(v) == "string" then
            table.insert(currentOptions, {text = v, icon = nil})
        elseif type(v) == "table" then
            table.insert(currentOptions, {text = v.text or v[1], icon = v.icon})
        end
    end

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = text
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundColor3 = Theme.Secondary
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame:SetAttribute("Flag", flag)
    DropdownFrame:SetAttribute("Value", tostring(default))

    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = DropdownFrame

    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Name = "Label"
    DropdownLabel.Parent = DropdownFrame
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    DropdownLabel.Size = UDim2.new(1, -90, 1, 0)
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.Text = text
    DropdownLabel.TextColor3 = Theme.Text
    DropdownLabel.TextSize = 13
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "Dropdown"
    DropdownButton.Parent = DropdownFrame
    DropdownButton.BackgroundColor3 = Theme.Surface
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Position = UDim2.new(1, -160, 0.5, -12)
    DropdownButton.Size = UDim2.new(0, 150, 0, 24)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Text = truncateText(default or "Select...", 24)
    DropdownButton.TextColor3 = Theme.Text
    DropdownButton.TextSize = 12

    local DropdownButtonCorner = Instance.new("UICorner")
    DropdownButtonCorner.CornerRadius = UDim.new(0, 4)
    DropdownButtonCorner.Parent = DropdownButton

    -- Dropdown List (Rayfield-style) parented to MainFrame for overlap
    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "DropdownList"
    DropdownList.Parent = GUI.MainFrame or game:GetService("CoreGui")
    DropdownList.BackgroundColor3 = Theme.Background
    DropdownList.BorderSizePixel = 0
    DropdownList.Size = UDim2.new(0, 200, 0, 150)
    DropdownList.Visible = false
    DropdownList.ZIndex = 10000

    local DropdownListCorner = Instance.new("UICorner")
    DropdownListCorner.CornerRadius = UDim.new(0, 6)
    DropdownListCorner.Parent = DropdownList

    local DropdownListStroke = Instance.new("UIStroke")
    DropdownListStroke.Thickness = 1
    DropdownListStroke.Color = Theme.Border
    DropdownListStroke.Parent = DropdownList

    -- Search box (optional)
    local SearchBox
    local DropdownScroll = Instance.new("ScrollingFrame")
    DropdownScroll.Name = "Scroll"
    DropdownScroll.Parent = DropdownList
    DropdownScroll.BackgroundTransparency = 1
    DropdownScroll.BorderSizePixel = 0
    DropdownScroll.Position = UDim2.new(0, 5, 0, 5)
    DropdownScroll.Size = UDim2.new(1, -10, 1, -10)
    DropdownScroll.ScrollBarThickness = 5
    DropdownScroll.ScrollBarImageColor3 = Theme.Accent

    local DropdownListLayout = Instance.new("UIListLayout")
    DropdownListLayout.Parent = DropdownScroll
    DropdownListLayout.Padding = UDim.new(0, 4)

    local DropdownPadding = Instance.new("UIPadding")
    DropdownPadding.Parent = DropdownScroll
    DropdownPadding.PaddingTop = UDim.new(0, 6)

    if searchable then
        SearchBox = Instance.new("TextBox")
        SearchBox.Name = "Search"
        SearchBox.Parent = DropdownList
        SearchBox.BackgroundColor3 = Theme.Surface
        SearchBox.BorderSizePixel = 0
        SearchBox.Position = UDim2.new(0, 8, 0, 8)
        SearchBox.Size = UDim2.new(1, -16, 0, 26)
        SearchBox.Font = Enum.Font.Gotham
        SearchBox.PlaceholderText = "Search..."
        SearchBox.Text = ""
        SearchBox.TextColor3 = Theme.Text
        SearchBox.TextSize = 12

        local sbCorner = Instance.new("UICorner")
        sbCorner.CornerRadius = UDim.new(0, 6)
        sbCorner.Parent = SearchBox

        -- push scroll down
        DropdownScroll.Position = UDim2.new(0, 5, 0, 40)
        DropdownScroll.Size = UDim2.new(1, -10, 1, -45)
    end

    -- Option pooling
    local pool = {}
    local function getOptionButton()
        for i, btn in ipairs(pool) do
            if not btn.Parent then
                btn.Parent = DropdownScroll
                btn.Visible = true
                return btn
            end
        end
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = DropdownScroll
        OptionButton.BackgroundColor3 = Theme.Secondary
        OptionButton.BorderSizePixel = 0
        OptionButton.Size = UDim2.new(1, 0, 0, 28)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.TextColor3 = Theme.Text
        OptionButton.TextSize = 12

        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 4)
        OptionCorner.Parent = OptionButton

        table.insert(pool, OptionButton)
        return OptionButton
    end

    local filtered = {}
    local function refreshFiltered(query)
        filtered = {}
        local q = (query or ""):lower()
        for _, opt in ipairs(currentOptions) do
            if q == "" or opt.text:lower():find(q, 1, true) then
                table.insert(filtered, opt)
            end
        end
    end

    local function updatePosition()
        local buttonPos = DropdownButton.AbsolutePosition
        local buttonSize = DropdownButton.AbsoluteSize
        local screenSize = workspace.CurrentCamera.ViewportSize

        local listHeight = math.min(#filtered * 30 + 14 + (SearchBox and 40 or 10), maxHeight)
        local newY = buttonPos.Y + buttonSize.Y + 5

        if newY + listHeight > screenSize.Y then
            newY = buttonPos.Y - listHeight - 5
        end

        DropdownList.Size = UDim2.new(0, math.max(180, buttonSize.X), 0, listHeight)
        DropdownList.Position = UDim2.new(0, buttonPos.X, 0, newY)
    end

    local activeConns = {}
    local function bind(conn)
        table.insert(activeConns, conn)
        GUI:AddConnection(conn)
    end

    local function clearOptions()
        for _, btn in ipairs(pool) do
            if btn and btn.Parent then
                btn.Parent = nil
                btn.Visible = false
            end
        end
    end

    local function createOptionButtons()
        clearOptions()
        for i, opt in ipairs(filtered) do
            local btn = getOptionButton()
            btn.Name = tostring(i)
            btn.Text = opt.text
            btn.Parent = DropdownScroll
            btn.BackgroundColor3 = Theme.Secondary
            btn:SetAttribute("_opt_index", i)

            -- show icon if provided (simple support via ImageLabel as child)
            if opt.icon and type(opt.icon) == "string" then
                if not btn:FindFirstChild("Icon") then
                    local iv = Instance.new("ImageLabel")
                    iv.Name = "Icon"
                    iv.Parent = btn
                    iv.Size = UDim2.new(0, 18, 0, 18)
                    iv.Position = UDim2.new(0, 6, 0.5, -9)
                    iv.BackgroundTransparency = 1
                end
                btn.Icon.Image = opt.icon
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.Text = "    " .. opt.text
            else
                if btn:FindFirstChild("Icon") then btn.Icon:Destroy() end
                btn.TextXAlignment = Enum.TextXAlignment.Left
            end

            -- selection state
            local selectedState = selected[opt.text]
            if multi then
                btn.Text = (selectedState and "✔ ") .. btn.Text
            end

            -- Mouse handlers (use new per-button connections)
            local clickConn = btn.MouseButton1Click:Connect(function()
                if multi then
                    selected[opt.text] = not selected[opt.text]
                    createOptionButtons()
                    local selList = {}
                    for k, v in pairs(selected) do if v then table.insert(selList, k) end end
                    DropdownButton.Text = #selList > 0 and truncateText(table.concat(selList, ", "), 24) or "Select..."
                    DropdownFrame:SetAttribute("Value", HttpService:JSONEncode(selList))
                    callback(selList)
                else
                    DropdownButton.Text = truncateText(opt.text, 24)
                    DropdownFrame:SetAttribute("Value", tostring(opt.text))
                    DropdownList.Visible = false
                    callback(opt.text)
                end
            end)
            bind(clickConn)

            btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Theme.Accent end)
            btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Theme.Secondary end)
        end
        DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, #filtered * 32)
    end

    -- initialize
    refreshFiltered("")
    createOptionButtons()

    if SearchBox then
        local lastQ = ""
        local changeConn = SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local q = SearchBox.Text or ""
            if q == lastQ then return end
            lastQ = q
            refreshFiltered(q)
            createOptionButtons()
            updatePosition()
        end)
        bind(changeConn)
    end

    -- Toggle
    local toggleConn = DropdownButton.MouseButton1Click:Connect(function()
        if DropdownList.Visible then
            DropdownList.Visible = false
        else
            refreshFiltered((SearchBox and SearchBox.Text) or "")
            createOptionButtons()
            updatePosition()
            DropdownList.Visible = true
        end
    end)
    bind(toggleConn)

    -- click outside closes
    local outsideConn = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and DropdownList.Visible then
            local mousePos = UserInputService:GetMouseLocation()
            local listPos = DropdownList.AbsolutePosition
            local listSize = DropdownList.AbsoluteSize
            local buttonPos = DropdownButton.AbsolutePosition
            local buttonSize = DropdownButton.AbsoluteSize

            local inList = mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X and
                           mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y
            local inButton = mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and
                            mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y

            if not inList and not inButton then
                DropdownList.Visible = false
            end
        end
    end)
    bind(outsideConn)

    -- expose object methods
    local DropdownObject = {}
    function DropdownObject:Set(value)
        if multi and type(value) == "table" then
            selected = {}
            for _, v in ipairs(value) do selected[v] = true end
            local selList = {}
            for k, v in pairs(selected) do if v then table.insert(selList, k) end end
            DropdownButton.Text = #selList > 0 and truncateText(table.concat(selList, ", "), 24) or "Select..."
            DropdownFrame:SetAttribute("Value", HttpService:JSONEncode(selList))
            callback(selList)
        else
            DropdownButton.Text = truncateText(tostring(value), 24)
            DropdownFrame:SetAttribute("Value", tostring(value))
            callback(value)
        end
    end
    function DropdownObject:Get()
        if multi then
            local selList = {}
            for k, v in pairs(selected) do if v then table.insert(selList, k) end end
            return selList
        end
        return DropdownFrame:GetAttribute("Value")
    end
    function DropdownObject:Refresh(options)
        currentOptions = {}
        for _, v in ipairs(options) do
            if type(v) == "string" then table.insert(currentOptions, {text=v}) else table.insert(currentOptions, v) end
        end
        refreshFiltered(SearchBox and SearchBox.Text or "")
        createOptionButtons()
    end
    function DropdownObject:Clear()
        currentOptions = {}
        refreshFiltered("")
        createOptionButtons()
    end

    -- cleanup when mainframe destroyed
    GUI:RegisterCleanup(function()
        if DropdownList and DropdownList.Parent then
            DropdownList:Destroy()
        end
    end)

    return DropdownObject
end

function GUI:CreateNotify(config)
    local title = config.title or config.Title or "Notification"
    local description = config.description or config.Description or ""
    local duration = config.duration or 3

    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.Name = "Notify"
    NotifyFrame.Parent = GUI.MainFrame
    NotifyFrame.BackgroundColor3 = Theme.Surface
    NotifyFrame.BorderSizePixel = 0
    NotifyFrame.Size = UDim2.new(0, 250, 0, 70)
    NotifyFrame.Position = UDim2.new(1, -270, 0, 20)
    NotifyFrame.AnchorPoint = Vector2.new(0, 0)
    NotifyFrame.ZIndex = 10001

    local NotifyCorner = Instance.new("UICorner")
    NotifyCorner.CornerRadius = UDim.new(0, 6)
    NotifyCorner.Parent = NotifyFrame

    local NotifyStroke = Instance.new("UIStroke")
    NotifyStroke.Thickness = 1
    NotifyStroke.Color = Theme.Border
    NotifyStroke.Parent = NotifyFrame

    local NotifyTitle = Instance.new("TextLabel")
    NotifyTitle.Name = "Title"
    NotifyTitle.Parent = NotifyFrame
    NotifyTitle.BackgroundTransparency = 1
    NotifyTitle.Position = UDim2.new(0, 10, 0, 10)
    NotifyTitle.Size = UDim2.new(1, -20, 0, 20)
    NotifyTitle.Font = Enum.Font.GothamBold
    NotifyTitle.Text = title
    NotifyTitle.TextColor3 = Theme.Text
    NotifyTitle.TextSize = 13
    NotifyTitle.TextXAlignment = Enum.TextXAlignment.Left

    local NotifyDesc = Instance.new("TextLabel")
    NotifyDesc.Name = "Description"
    NotifyDesc.Parent = NotifyFrame
    NotifyDesc.BackgroundTransparency = 1
    NotifyDesc.Position = UDim2.new(0, 10, 0, 32)
    NotifyDesc.Size = UDim2.new(1, -20, 0, 28)
    NotifyDesc.Font = Enum.Font.Gotham
    NotifyDesc.Text = description
    NotifyDesc.TextColor3 = Theme.TextSecondary
    NotifyDesc.TextSize = 11
    NotifyDesc.TextWrapped = true
    NotifyDesc.TextXAlignment = Enum.TextXAlignment.Left

    -- Animate in
    NotifyFrame.Size = UDim2.new(0, 0, 0, 70)
    NotifyFrame.Position = UDim2.new(1, 0, 0, 20)
    NotifyFrame:TweenSize(UDim2.new(0, 250, 0, 70), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)

    -- Animate out after duration
    task.delay(duration, function()
        NotifyFrame:TweenSize(UDim2.new(0, 0, 0, 70), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2)
        task.wait(0.25)
        NotifyFrame:Destroy()
    end)

    return NotifyFrame
end

function GUI:CreateSlider(config)
    local parent = config.parent or config.Parent
    local text = config.text or config.Text or "Slider"
    local min = config.min or config.Min or 0
    local max = config.max or config.Max or 100
    local default = config.default or config.Default or min
    local callback = config.callback or function() end

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider"
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Theme.Secondary
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, 0, 0, 45)

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = SliderFrame

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "Label"
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 10, 0, 3)
    SliderLabel.Size = UDim2.new(1, -70, 0, 20)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = text
    SliderLabel.TextColor3 = Theme.Text
    SliderLabel.TextSize = 13
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Name = "Value"
    ValueLabel.Parent = SliderFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -60, 0, 3)
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Theme.Text
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local Bar = Instance.new("Frame")
    Bar.Name = "Bar"
    Bar.Parent = SliderFrame
    Bar.BackgroundColor3 = Theme.Border
    Bar.BorderSizePixel = 0
    Bar.Position = UDim2.new(0, 10, 0, 30)
    Bar.Size = UDim2.new(1, -20, 0, 8)

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 4)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Parent = Bar
    Fill.BackgroundColor3 = Theme.Accent
    Fill.BorderSizePixel = 0
    Fill.Size = UDim2.new(0, 0, 1, 0)

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Name = "Knob"
    Knob.Parent = Bar
    Knob.BackgroundColor3 = Theme.Accent
    Knob.BorderSizePixel = 0
    Knob.Size = UDim2.new(0, 16, 1.5, 0)
    Knob.Position = UDim2.new(0, -8, -0.25, 0)

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local function updateSlider(value)
        local clampedValue = math.max(min, math.min(max, value))
        local percentage = (clampedValue - min) / (max - min)
        Fill.Size = UDim2.new(0, math.floor(percentage * Bar.AbsoluteSize.X), 1, 0)
        Knob.Position = UDim2.new(0, math.floor(percentage * Bar.AbsoluteSize.X) - 8, -0.25, 0)
        ValueLabel.Text = tostring(math.floor(clampedValue))
        callback(clampedValue)
    end

    local sliding = false
    local moveConn
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            local function capture()
                local mousePos = UserInputService:GetMouseLocation()
                local barPos = Bar.AbsolutePosition
                local barSize = Bar.AbsoluteSize
                local relativeX = math.clamp(mousePos.X - barPos.X, 0, barSize.X)
                local value = min + (relativeX / barSize.X) * (max - min)
                updateSlider(value)
            end
            capture()
            moveConn = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    capture()
                end
            end)
            GUI:AddConnection(moveConn)
        end
    end)

    Bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
            if moveConn and moveConn.Disconnect then moveConn:Disconnect() end
        end
    end)

    -- Ensure initial sizes after layout
    Bar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        updateSlider(default)
    end)

    return SliderFrame
end

function GUI:CreateKeyBind(config)
    local parent = config.parent or config.Parent
    local text = config.text or config.Text or "KeyBind"
    local default = config.default or config.Default or "None"
    local callback = config.callback or function() end

    local KeyBindFrame = Instance.new("Frame")
    KeyBindFrame.Name = "KeyBind"
    KeyBindFrame.Parent = parent
    KeyBindFrame.BackgroundColor3 = Theme.Secondary
    KeyBindFrame.BorderSizePixel = 0
    KeyBindFrame.Size = UDim2.new(1, 0, 0, 35)

    local KeyBindCorner = Instance.new("UICorner")
    KeyBindCorner.CornerRadius = UDim.new(0, 6)
    KeyBindCorner.Parent = KeyBindFrame

    local KeyBindLabel = Instance.new("TextLabel")
    KeyBindLabel.Name = "Label"
    KeyBindLabel.Parent = KeyBindFrame
    KeyBindLabel.BackgroundTransparency = 1
    KeyBindLabel.Position = UDim2.new(0, 10, 0, 0)
    KeyBindLabel.Size = UDim2.new(1, -90, 1, 0)
    KeyBindLabel.Font = Enum.Font.Gotham
    KeyBindLabel.Text = text
    KeyBindLabel.TextColor3 = Theme.Text
    KeyBindLabel.TextSize = 13
    KeyBindLabel.TextXAlignment = Enum.TextXAlignment.Left

    local KeyBindButton = Instance.new("TextButton")
    KeyBindButton.Name = "Button"
    KeyBindButton.Parent = KeyBindFrame
    KeyBindButton.BackgroundColor3 = Theme.Border
    KeyBindButton.BorderSizePixel = 0
    KeyBindButton.Position = UDim2.new(1, -75, 0.5, -12)
    KeyBindButton.Size = UDim2.new(0, 65, 0, 24)
    KeyBindButton.Font = Enum.Font.Gotham
    KeyBindButton.Text = tostring(default)
    KeyBindButton.TextColor3 = Theme.Text
    KeyBindButton.TextSize = 12

    local KeyBindButtonCorner = Instance.new("UICorner")
    KeyBindButtonCorner.CornerRadius = UDim.new(0, 8)
    KeyBindButtonCorner.Parent = KeyBindButton

    local currentKey = tostring(default)
    local isListening = false

    local function getKeyName(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            return "M1"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            return "M2"
        elseif input.UserInputType == Enum.UserInputType.Keyboard then
            return input.KeyCode.Name
        else
            return "Unknown"
        end
    end

    KeyBindButton.MouseButton1Click:Connect(function()
        if isListening then return end
        
        isListening = true
        KeyBindButton.Text = "Press..."
        KeyBindButton.BackgroundColor3 = Theme.Accent

        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            currentKey = getKeyName(input)
            KeyBindButton.Text = currentKey
            KeyBindButton.BackgroundColor3 = Theme.Border
            isListening = false
            connection:Disconnect()
            callback(currentKey)
        end)
    end)

    return KeyBindFrame
end

function GUI:CreateColorPicker(config)
    local parent = config.parent or config.Parent
    local text = config.text or config.Text or "Color Picker"
    local default = config.default or config.Default or Color3.fromRGB(255, 0, 0)
    local callback = config.callback or function() end

    local ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Name = "ColorPicker"
    ColorPickerFrame.Parent = parent
    ColorPickerFrame.BackgroundColor3 = Theme.Secondary
    ColorPickerFrame.BorderSizePixel = 0
    ColorPickerFrame.Size = UDim2.new(1, 0, 0, 35)

    local ColorPickerCorner = Instance.new("UICorner")
    ColorPickerCorner.CornerRadius = UDim.new(0, 6)
    ColorPickerCorner.Parent = ColorPickerFrame

    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Name = "Label"
    ColorLabel.Parent = ColorPickerFrame
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Position = UDim2.new(0, 10, 0, 0)
    ColorLabel.Size = UDim2.new(1, -120, 1, 0)
    ColorLabel.Font = Enum.Font.Gotham
    ColorLabel.Text = text
    ColorLabel.TextColor3 = Theme.Text
    ColorLabel.TextSize = 13
    ColorLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ColorButton = Instance.new("TextButton")
    ColorButton.Name = "Color"
    ColorButton.Parent = ColorPickerFrame
    ColorButton.BackgroundColor3 = default
    ColorButton.BorderSizePixel = 0
    ColorButton.Position = UDim2.new(1, -60, 0.5, -12)
    ColorButton.Size = UDim2.new(0, 50, 0, 24)
    ColorButton.Text = ""

    local ColorButtonCorner = Instance.new("UICorner")
    ColorButtonCorner.CornerRadius = UDim.new(0, 8)
    ColorButtonCorner.Parent = ColorButton

    local currentColor = default
    local isPickerOpen = false

    ColorButton.MouseButton1Click:Connect(function()
        if isPickerOpen then return end
        isPickerOpen = true

        local ColorPickerGui = Instance.new("ScreenGui")
        ColorPickerGui.Name = "ColorPicker"
        ColorPickerGui.Parent = game.CoreGui
        ColorPickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local ColorWindow = Instance.new("Frame")
        ColorWindow.Name = "Window"
        ColorWindow.Parent = ColorPickerGui
        ColorWindow.BackgroundColor3 = Theme.Background
        ColorWindow.BorderSizePixel = 0
        ColorWindow.Size = UDim2.new(0, 200, 0, 180)

        local WindowCorner = Instance.new("UICorner")
        WindowCorner.CornerRadius = UDim.new(0, 6)
        WindowCorner.Parent = ColorWindow

        local WindowStroke = Instance.new("UIStroke")
        WindowStroke.Thickness = 1
        WindowStroke.Color = Theme.Border
        WindowStroke.Parent = ColorWindow

        -- Color preview
        local Preview = Instance.new("Frame")
        Preview.Name = "Preview"
        Preview.Parent = ColorWindow
        Preview.BackgroundColor3 = currentColor
        Preview.BorderSizePixel = 0
        Preview.Position = UDim2.new(0, 10, 0, 10)
        Preview.Size = UDim2.new(0, 180, 0, 40)

        local PreviewCorner = Instance.new("UICorner")
        PreviewCorner.CornerRadius = UDim.new(0, 4)
        PreviewCorner.Parent = Preview

        -- RGB Sliders
        local function createSlider(y, colorName, colorValue)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = colorName
            SliderFrame.Parent = ColorWindow
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Position = UDim2.new(0, 10, 0, y)
            SliderFrame.Size = UDim2.new(0, 180, 0, 20)

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(0, 20, 1, 0)
            Label.Font = Enum.Font.GothamBold
            Label.Text = colorName
            Label.TextColor3 = colorValue
            Label.TextSize = 12

            local Bar = Instance.new("Frame")
            Bar.Name = "Bar"
            Bar.Parent = SliderFrame
            Bar.BackgroundColor3 = Theme.Border
            Bar.Position = UDim2.new(0, 25, 0.5, -4)
            Bar.Size = UDim2.new(1, -30, 0, 8)

            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(0, 4)
            BarCorner.Parent = Bar

            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            Fill.Parent = Bar
            Fill.BackgroundColor3 = colorValue
            Fill.Size = UDim2.new(0.5, 0, 1, 0)

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 4)
            FillCorner.Parent = Fill

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -30, 0, 0)
            ValueLabel.Size = UDim2.new(0, 25, 1, 0)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.Text = "127"
            ValueLabel.TextColor3 = Theme.Text
            ValueLabel.TextSize = 10

            return {Bar = Bar, Fill = Fill, Value = ValueLabel}
        end

        local rSlider = createSlider(60, "R", Color3.fromRGB(255, 85, 85))
        local gSlider = createSlider(90, "G", Color3.fromRGB(85, 255, 85))
        local bSlider = createSlider(120, "B", Color3.fromRGB(85, 85, 255))

        local function updateColor()
            local r = tonumber(rSlider.Value.Text) or 0
            local g = tonumber(gSlider.Value.Text) or 0
            local b = tonumber(bSlider.Value.Text) or 0
            currentColor = Color3.fromRGB(r, g, b)
            Preview.BackgroundColor3 = currentColor
            ColorButton.BackgroundColor3 = currentColor
            callback(currentColor)
        end

        local function setupSliderInteraction(sliderData, maxVal)
            local sliding = false
            sliderData.Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    local moveConn
                    local function capture()
                        local mousePos = UserInputService:GetMouseLocation()
                        local barPos = sliderData.Bar.AbsolutePosition
                        local relativeX = math.clamp(mousePos.X - barPos.X, 0, sliderData.Bar.AbsoluteSize.X)
                        local value = math.floor((relativeX / sliderData.Bar.AbsoluteSize.X) * maxVal)
                        sliderData.Fill.Size = UDim2.new(relativeX / sliderData.Bar.AbsoluteSize.X, 0, 1, 0)
                        sliderData.Value.Text = tostring(value)
                        updateColor()
                    end
                    capture()
                    moveConn = UserInputService.InputChanged:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseMovement then capture() end
                    end)
                    GUI:AddConnection(moveConn)
                end
            end)

            sliderData.Bar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)

            sliderData.Bar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                -- update fill representation when bar resizes
                local val = tonumber(sliderData.Value.Text) or 0
                local perc = math.clamp(val / maxVal, 0, 1)
                sliderData.Fill.Size = UDim2.new(perc, 0, 1, 0)
            end)
        end

        setupSliderInteraction(rSlider, 255)
        setupSliderInteraction(gSlider, 255)
        setupSliderInteraction(bSlider, 255)

        -- Close button
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Parent = ColorWindow
        CloseBtn.BackgroundColor3 = Theme.Accent
        CloseBtn.Position = UDim2.new(0.5, -30, 1, -30)
        CloseBtn.Size = UDim2.new(0, 60, 0, 25)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.Text = "Done"
        CloseBtn.TextColor3 = Theme.Text
        CloseBtn.TextSize = 12

        local CloseCorner = Instance.new("UICorner")
        CloseCorner.CornerRadius = UDim.new(0, 4)
        CloseCorner.Parent = CloseBtn

        CloseBtn.MouseButton1Click:Connect(function()
            isPickerOpen = false
            ColorPickerGui:Destroy()
        end)

        -- Position window near button
        local buttonPos = ColorButton.AbsolutePosition
        local screenSize = workspace.CurrentCamera.ViewportSize
        local windowX = math.min(buttonPos.X, screenSize.X - 210)
        local windowY = buttonPos.Y + 40
        if windowY + 180 > screenSize.Y then
            windowY = buttonPos.Y - 190
        end
        ColorWindow.Position = UDim2.new(0, windowX, 0, windowY)
    end)

    return ColorPickerFrame
end

function GUI:CreateDivider(config)
    local parent = config and (config.parent or config.Parent) or nil
    local height = (config and (config.height or config.Height)) or 10

    local DividerFrame = Instance.new("Frame")
    DividerFrame.Name = "Divider"
    DividerFrame.BackgroundColor3 = Theme.Border
    DividerFrame.BackgroundTransparency = 0.5
    DividerFrame.BorderSizePixel = 0
    DividerFrame.Size = UDim2.new(1, 0, 0, height)
    if parent then
        DividerFrame.Parent = parent
    end

    return DividerFrame
end

-- Loading UI (cool animated overlay)
function GUI:ShowLoading(name)
    if self.LoadScreen then return end
    local title = name or (self.MainFrame and self.MainFrame.Name) or "DubuLib"

    local sg = Instance.new("ScreenGui")
    sg.Name = title .. "_Loading"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = game:GetService("CoreGui")

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Parent = sg
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(6, 6, 10)
    overlay.BackgroundTransparency = 0.25
    overlay.BorderSizePixel = 0

    local box = Instance.new("Frame")
    box.Name = "Box"
    box.Parent = overlay
    box.Size = UDim2.new(0, 420, 0, 140)
    box.Position = UDim2.new(0.5, -210, 0.5, -70)
    box.BackgroundColor3 = Theme.Surface
    box.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = box

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Theme.Border
    stroke.Parent = box

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = box
    titleLabel.Size = UDim2.new(1, -30, 0, 36)
    titleLabel.Position = UDim2.new(0, 15, 0, 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local subLabel = Instance.new("TextLabel")
    subLabel.Parent = box
    subLabel.Size = UDim2.new(1, -30, 0, 18)
    subLabel.Position = UDim2.new(0, 15, 0, 50)
    subLabel.BackgroundTransparency = 1
    subLabel.Font = Enum.Font.Gotham
    subLabel.Text = "Loading"
    subLabel.TextColor3 = Theme.TextSecondary
    subLabel.TextSize = 14
    subLabel.TextXAlignment = Enum.TextXAlignment.Left

    local progressBg = Instance.new("Frame")
    progressBg.Parent = box
    progressBg.Size = UDim2.new(1, -30, 0, 14)
    progressBg.Position = UDim2.new(0, 15, 0, 84)
    progressBg.BackgroundColor3 = Theme.Border
    progressBg.BorderSizePixel = 0

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 8)
    progressCorner.Parent = progressBg

    local progressFill = Instance.new("Frame")
    progressFill.Parent = progressBg
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Theme.Accent
    progressFill.BorderSizePixel = 0

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 8)
    fillCorner.Parent = progressFill

    -- animated dots
    local dots = 0
    local running = true
    spawn(function()
        while running and sg.Parent do
            dots = (dots + 1) % 4
            subLabel.Text = "Loading" .. string.rep('.', dots)
            task.wait(0.5)
        end
    end)

    self.LoadScreen = {
        Screen = sg,
        Fill = progressFill,
        Stop = function()
            running = false
        end
    }

    return self.LoadScreen
end

function GUI:UpdateLoading(percent)
    if not self.LoadScreen then return end
    local p = math.clamp(percent or 0, 0, 100) / 100
    local bg = self.LoadScreen.Fill.Parent
    local width = bg.AbsoluteSize.X
    self.LoadScreen.Fill:TweenSize(UDim2.new(0, math.floor(width * p), 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2)
end

function GUI:HideLoading()
    if not self.LoadScreen then return end
    pcall(function()
        self.LoadScreen.Stop()
        if self.LoadScreen.Screen then
            self.LoadScreen.Screen:Destroy()
        end
    end)
    self.LoadScreen = nil
end

-- Config save/load helpers (uses writefile/readfile when available)
local HttpService = game:GetService("HttpService")
function GUI:SaveConfig(filename, data)
    local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
    if not ok then return false, "encode failed" end
    local success, err = pcall(function() writefile(filename, json) end)
    if success then return true end
    return false, err
end

function GUI:LoadConfig(filename)
    local success, content = pcall(function() return readfile(filename) end)
    if not success then return nil, content end
    local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok then return nil, "decode failed" end
    return data
end

-- Apply a theme at runtime for main containers
function GUI:SetTheme(themeTable)
    if type(themeTable) ~= "table" then return end
    Theme = themeTable
    if self.Main then
        self.Main.BackgroundColor3 = Theme.Background
    end
    if self.Main and self.Main:FindFirstChild("TitleBar") then
        self.Main.TitleBar.BackgroundColor3 = Theme.NavBackground
        if self.Main.TitleBar:FindFirstChild("Title") then
            self.Main.TitleBar.Title.TextColor3 = Theme.Text
        end
    end
    if self.NavBar then
        self.NavBar.BackgroundColor3 = Theme.NavBackground
    end
    if self.Content then
        self.Content.ScrollBarImageColor3 = Theme.Accent
    end
end
return GUI
