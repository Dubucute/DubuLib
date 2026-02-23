-- DubuLib Theme Presets
-- Use these themes by passing them to CreateMain()

local Themes = {}

-- =============================================
-- PINK & BLACK (Default) - Modern & Vibrant
-- =============================================
Themes.PinkBlack = {
    Background = Color3.fromRGB(10, 10, 15),
    Secondary = Color3.fromRGB(20, 20, 25),
    Accent = Color3.fromRGB(255, 20, 147),           -- Deep Pink
    AccentSecondary = Color3.fromRGB(219, 39, 119),  -- Darker Pink
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

-- =============================================
-- CYBERPUNK - Neon Cyan & Purple
-- =============================================
Themes.Cyberpunk = {
    Background = Color3.fromRGB(5, 10, 15),
    Secondary = Color3.fromRGB(15, 25, 35),
    Accent = Color3.fromRGB(0, 255, 255),           -- Cyan
    AccentSecondary = Color3.fromRGB(200, 100, 255), -- Purple
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(150, 200, 255),
    Border = Color3.fromRGB(0, 200, 255),
    NavBackground = Color3.fromRGB(10, 15, 25),
    Surface = Color3.fromRGB(20, 30, 40),
    SurfaceVariant = Color3.fromRGB(30, 40, 50),
    Success = Color3.fromRGB(0, 255, 150),
    Warning = Color3.fromRGB(255, 200, 0),
    Error = Color3.fromRGB(255, 50, 100),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- =============================================
-- FOREST - Green & Dark
-- =============================================
Themes.Forest = {
    Background = Color3.fromRGB(10, 15, 10),
    Secondary = Color3.fromRGB(20, 35, 20),
    Accent = Color3.fromRGB(50, 200, 100),          -- Forest Green
    AccentSecondary = Color3.fromRGB(40, 150, 80),
    Text = Color3.fromRGB(220, 255, 220),
    TextSecondary = Color3.fromRGB(150, 180, 150),
    Border = Color3.fromRGB(40, 80, 40),
    NavBackground = Color3.fromRGB(15, 20, 15),
    Surface = Color3.fromRGB(25, 40, 25),
    SurfaceVariant = Color3.fromRGB(35, 50, 35),
    Success = Color3.fromRGB(80, 255, 100),
    Warning = Color3.fromRGB(255, 180, 40),
    Error = Color3.fromRGB(255, 80, 80),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- =============================================
-- SUNSET - Orange & Red
-- =============================================
Themes.Sunset = {
    Background = Color3.fromRGB(20, 10, 10),
    Secondary = Color3.fromRGB(35, 15, 15),
    Accent = Color3.fromRGB(255, 100, 50),          -- Orange
    AccentSecondary = Color3.fromRGB(255, 50, 50),  -- Red
    Text = Color3.fromRGB(255, 240, 200),
    TextSecondary = Color3.fromRGB(200, 150, 100),
    Border = Color3.fromRGB(100, 50, 30),
    NavBackground = Color3.fromRGB(25, 12, 12),
    Surface = Color3.fromRGB(40, 20, 20),
    SurfaceVariant = Color3.fromRGB(50, 30, 30),
    Success = Color3.fromRGB(100, 200, 50),
    Warning = Color3.fromRGB(255, 200, 50),
    Error = Color3.fromRGB(255, 100, 100),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- =============================================
-- OCEAN - Blue & Teal
-- =============================================
Themes.Ocean = {
    Background = Color3.fromRGB(10, 15, 25),
    Secondary = Color3.fromRGB(20, 35, 50),
    Accent = Color3.fromRGB(50, 150, 255),          -- Sky Blue
    AccentSecondary = Color3.fromRGB(30, 200, 200), -- Teal
    Text = Color3.fromRGB(220, 240, 255),
    TextSecondary = Color3.fromRGB(150, 180, 220),
    Border = Color3.fromRGB(40, 80, 120),
    NavBackground = Color3.fromRGB(15, 25, 40),
    Surface = Color3.fromRGB(25, 45, 65),
    SurfaceVariant = Color3.fromRGB(35, 55, 75),
    Success = Color3.fromRGB(50, 200, 100),
    Warning = Color3.fromRGB(255, 200, 80),
    Error = Color3.fromRGB(255, 100, 100),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- =============================================
-- MIDNIGHT - Deep Purple
-- =============================================
Themes.Midnight = {
    Background = Color3.fromRGB(15, 10, 25),
    Secondary = Color3.fromRGB(25, 20, 45),
    Accent = Color3.fromRGB(180, 100, 255),         -- Purple
    AccentSecondary = Color3.fromRGB(150, 50, 255), -- Deep Purple
    Text = Color3.fromRGB(240, 240, 255),
    TextSecondary = Color3.fromRGB(180, 170, 220),
    Border = Color3.fromRGB(60, 40, 100),
    NavBackground = Color3.fromRGB(20, 15, 35),
    Surface = Color3.fromRGB(30, 25, 50),
    SurfaceVariant = Color3.fromRGB(40, 35, 60),
    Success = Color3.fromRGB(80, 200, 100),
    Warning = Color3.fromRGB(255, 200, 50),
    Error = Color3.fromRGB(255, 100, 100),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- =============================================
-- NEON PINK - Bright & Bold
-- =============================================
Themes.NeonPink = {
    Background = Color3.fromRGB(5, 5, 10),
    Secondary = Color3.fromRGB(15, 10, 20),
    Accent = Color3.fromRGB(255, 0, 127),           -- Hot Pink
    AccentSecondary = Color3.fromRGB(255, 50, 150),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 150, 200),
    Border = Color3.fromRGB(255, 0, 127),
    NavBackground = Color3.fromRGB(10, 5, 15),
    Surface = Color3.fromRGB(20, 10, 25),
    SurfaceVariant = Color3.fromRGB(30, 20, 35),
    Success = Color3.fromRGB(0, 255, 100),
    Warning = Color3.fromRGB(255, 200, 0),
    Error = Color3.fromRGB(255, 50, 100),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- =============================================
-- LIGHT MODE - Clean & Bright
-- =============================================
Themes.Light = {
    Background = Color3.fromRGB(245, 245, 250),
    Secondary = Color3.fromRGB(230, 230, 240),
    Accent = Color3.fromRGB(100, 150, 255),         -- Blue
    AccentSecondary = Color3.fromRGB(150, 100, 255), -- Purple
    Text = Color3.fromRGB(30, 30, 40),
    TextSecondary = Color3.fromRGB(100, 100, 120),
    Border = Color3.fromRGB(200, 200, 220),
    NavBackground = Color3.fromRGB(240, 240, 250),
    Surface = Color3.fromRGB(235, 235, 245),
    SurfaceVariant = Color3.fromRGB(220, 220, 235),
    Success = Color3.fromRGB(40, 180, 80),
    Warning = Color3.fromRGB(255, 180, 40),
    Error = Color3.fromRGB(255, 80, 80),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- =============================================
-- MONOCHROME - Pure Black & White
-- =============================================
Themes.Monochrome = {
    Background = Color3.fromRGB(10, 10, 10),
    Secondary = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(255, 255, 255),         -- White
    AccentSecondary = Color3.fromRGB(200, 200, 200), -- Gray
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(150, 150, 150),
    Border = Color3.fromRGB(60, 60, 60),
    NavBackground = Color3.fromRGB(15, 15, 15),
    Surface = Color3.fromRGB(35, 35, 35),
    SurfaceVariant = Color3.fromRGB(45, 45, 45),
    Success = Color3.fromRGB(100, 200, 100),
    Warning = Color3.fromRGB(200, 200, 100),
    Error = Color3.fromRGB(200, 100, 100),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- =============================================
-- SAKURA - Pink & Purple (Soft)
-- =============================================
Themes.Sakura = {
    Background = Color3.fromRGB(20, 15, 18),
    Secondary = Color3.fromRGB(35, 25, 30),
    Accent = Color3.fromRGB(255, 150, 200),         -- Soft Pink
    AccentSecondary = Color3.fromRGB(220, 100, 180), -- Mauve
    Text = Color3.fromRGB(255, 245, 250),
    TextSecondary = Color3.fromRGB(200, 150, 180),
    Border = Color3.fromRGB(80, 50, 70),
    NavBackground = Color3.fromRGB(25, 18, 22),
    Surface = Color3.fromRGB(40, 30, 35),
    SurfaceVariant = Color3.fromRGB(50, 40, 45),
    Success = Color3.fromRGB(150, 200, 100),
    Warning = Color3.fromRGB(255, 180, 100),
    Error = Color3.fromRGB(255, 100, 120),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- =============================================
-- MATRIX - Bright Green & Black
-- =============================================
Themes.Matrix = {
    Background = Color3.fromRGB(5, 5, 5),
    Secondary = Color3.fromRGB(10, 20, 10),
    Accent = Color3.fromRGB(0, 255, 0),             -- Matrix Green
    AccentSecondary = Color3.fromRGB(100, 255, 100),
    Text = Color3.fromRGB(0, 255, 0),
    TextSecondary = Color3.fromRGB(100, 200, 100),
    Border = Color3.fromRGB(0, 200, 0),
    NavBackground = Color3.fromRGB(8, 8, 8),
    Surface = Color3.fromRGB(15, 25, 15),
    SurfaceVariant = Color3.fromRGB(25, 35, 25),
    Success = Color3.fromRGB(0, 255, 0),
    Warning = Color3.fromRGB(255, 200, 0),
    Error = Color3.fromRGB(255, 50, 50),
    Shadow = Color3.fromRGB(0, 0, 0)
}

-- Usage Example:
-- local DubuLib = require(script.Parent:WaitForChild("DubuLib"))
-- local UI = DubuLib:CreateMain({
--     Name = "MyUI",
--     title = "My Custom UI",
--     Theme = Themes.Cyberpunk,  -- Use any theme!
--     ToggleUI = "K"
-- })

return Themes
