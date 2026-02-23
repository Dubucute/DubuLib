-- DubuLib Demo Script
-- Shows all UI components with pink/black theme

local DubuLib = require(game.ServerScriptService:WaitForChild("DubuLib"))

-- Create main UI
local UI = DubuLib:CreateMain({
    Name = "DubuLib Demo",
    title = "DubuLib - All Components Demo",
    ToggleUI = "K",
})

-- Create tabs
local HomeTab = DubuLib:CreateTab("Home", "🏠")
local ComponentsTab = DubuLib:CreateTab("Components", "⚙️")
local SettingsTab = DubuLib:CreateTab("Settings", "⚡")

-- ===== HOME TAB =====
DubuLib:CreateSection({
    parent = HomeTab,
    text = "Welcome to DubuLib!"
})

DubuLib:CreateParagraph({
    parent = HomeTab,
    text = "This is a demonstration of DubuLib's UI components. You can customize all elements with callbacks and themes. The pink and black color scheme provides a modern, stylish appearance."
})

local WelcomeButton = DubuLib:CreateButton({
    parent = HomeTab,
    text = "Click Me!",
    callback = function()
        DubuLib:CreateNotify({
            title = "Button Clicked!",
            description = "You just clicked the welcome button.",
            duration = 2
        })
    end
})

DubuLib:CreateParagraph({
    parent = HomeTab,
    text = "TIP: Click the minimize button (─) in the top-right corner to hide the UI and reveal a draggable floating restore button!"
})

-- ===== COMPONENTS TAB =====
DubuLib:CreateSection({
    parent = ComponentsTab,
    text = "Input Components"
})

local TextInput = DubuLib:CreateInput({
    parent = ComponentsTab,
    text = "Text Input",
    default = "Type something...",
    callback = function(value)
        print("Input:", value)
    end
})

DubuLib:CreateSection({
    parent = ComponentsTab,
    text = "Toggles & Buttons"
})

local MainToggle = DubuLib:CreateToggle({
    parent = ComponentsTab,
    text = "Enable Feature",
    default = true,
    callback = function(value)
        print("Toggle enabled:", value)
        if value then
            DubuLib:CreateNotify({
                title = "Feature Enabled",
                description = "The feature is now active.",
                duration = 1.5
            })
        end
    end
})

local Button1 = DubuLib:CreateButton({
    parent = ComponentsTab,
    text = "Action Button",
    callback = function()
        DubuLib:CreateNotify({
            title = "Action Executed",
            description = "Your action has been completed.",
            duration = 2
        })
    end
})

local Button2 = DubuLib:CreateButton({
    parent = ComponentsTab,
    text = "Show Loading",
    callback = function()
        local loading = DubuLib:ShowLoading("Processing")
        for i = 0, 100, 10 do
            task.wait(0.2)
            DubuLib:UpdateLoading(i)
        end
        DubuLib:HideLoading()
        DubuLib:CreateNotify({
            title = "Complete!",
            description = "Loading finished successfully.",
            duration = 2
        })
    end
})

DubuLib:CreateSection({
    parent = ComponentsTab,
    text = "Sliders & Advanced"
})

local Slider1 = DubuLib:CreateSlider({
    parent = ComponentsTab,
    text = "Value Slider",
    min = 0,
    max = 100,
    default = 50,
    callback = function(value)
        print("Slider value:", value)
    end
})

local Slider2 = DubuLib:CreateSlider({
    parent = ComponentsTab,
    text = "Speed Control",
    min = 0.1,
    max = 5,
    default = 1,
    callback = function(value)
        print("Speed:", value)
    end
})

local KeyBind = DubuLib:CreateKeyBind({
    parent = ComponentsTab,
    text = "Toggle KeyBind",
    default = "F",
    callback = function(key)
        print("KeyBind set to:", key)
        DubuLib:CreateNotify({
            title = "KeyBind Updated",
            description = "Key set to: " .. key,
            duration = 1.5
        })
    end
})

local ColorPicker = DubuLib:CreateColorPicker({
    parent = ComponentsTab,
    text = "Pick a Color",
    default = Color3.fromRGB(255, 20, 147),
    callback = function(color)
        print("Color picked:", color)
    end
})

DubuLib:CreateSection({
    parent = ComponentsTab,
    text = "Dropdowns"
})

-- Simple dropdown
local SimpleDropdown = DubuLib:CreateDropdown({
    parent = ComponentsTab,
    text = "Simple Dropdown",
    options = {"Option 1", "Option 2", "Option 3", "Option 4"},
    default = "Option 1",
    searchable = true,
    callback = function(value)
        print("Selected:", value)
    end
})

-- Dropdown with icons
local IconDropdown = DubuLib:CreateDropdown({
    parent = ComponentsTab,
    text = "Dropdown with Icons",
    options = {
        {text = "Home", icon = "rbxasset://textures/Lucide/home.png"},
        {text = "Settings", icon = "rbxasset://textures/Lucide/settings.png"},
        {text = "User", icon = "rbxasset://textures/Lucide/user.png"},
        {text = "Logout", icon = "rbxasset://textures/Lucide/log-out.png"},
    },
    default = "Home",
    searchable = true,
    callback = function(value)
        print("Icon selected:", value)
    end
})

-- Multi-select dropdown
local MultiDropdown = DubuLib:CreateDropdown({
    parent = ComponentsTab,
    text = "Multi-Select Dropdown",
    options = {"Red", "Green", "Blue", "Yellow", "Purple", "Orange"},
    default = "Red",
    multi = true,
    searchable = true,
    callback = function(values)
        print("Selected:", table.concat(values, ", "))
    end
})

DubuLib:CreateDivider({parent = ComponentsTab})

-- ===== SETTINGS TAB =====
DubuLib:CreateSection({
    parent = SettingsTab,
    text = "Theme Settings"
})

DubuLib:CreateParagraph({
    parent = SettingsTab,
    text = "Configure UI appearance and behavior options. The current theme is 'Pink & Black' - a modern dark theme with vibrant pink accents."
})

local ThemeToggle = DubuLib:CreateToggle({
    parent = SettingsTab,
    text = "Dark Mode",
    default = true,
    callback = function(value)
        print("Dark mode:", value)
    end
})

local AutoSaveToggle = DubuLib:CreateToggle({
    parent = SettingsTab,
    text = "Auto-Save Config",
    default = true,
    callback = function(value)
        print("Auto-save:", value)
    end
})

DubuLib:CreateSection({
    parent = SettingsTab,
    text = "UI Customization"
})

local UIScaleSlider = DubuLib:CreateSlider({
    parent = SettingsTab,
    text = "UI Scale",
    min = 0.8,
    max = 1.5,
    default = 1,
    callback = function(value)
        print("UI Scale:", value)
    end
})

local AnimationToggle = DubuLib:CreateToggle({
    parent = SettingsTab,
    text = "Smooth Animations",
    default = true,
    callback = function(value)
        print("Animations:", value)
    end
})

DubuLib:CreateSection({
    parent = SettingsTab,
    text = "Minimize/Restore"
})

DubuLib:CreateParagraph({
    parent = SettingsTab,
    text = "Click the minimize button (─) to hide the UI and show a draggable floating restore button. You can drag it anywhere on screen or click it to restore the UI."
})

DubuLib:CreateButton({
    parent = SettingsTab,
    text = "Test Minimize",
    callback = function()
        print("Testing minimize feature...")
        DubuLib:CreateNotify({
            title = "Minimizing Now",
            description = "The UI will minimize in 1 second. Look for the floating restore button!",
            duration = 1
        })
        task.wait(1)
    end
})

DubuLib:CreateSection({
    parent = SettingsTab,
    text = "Debug & Info"
})

local DebugButton = DubuLib:CreateButton({
    parent = SettingsTab,
    text = "Print Debug Info",
    callback = function()
        print("=== DubuLib Debug Info ===")
        print("Main Frame:", DubuLib.MainFrame and "Exists" or "Not Found")
        print("Active Connections:", #DubuLib._connections)
        print("========================")
        DubuLib:CreateNotify({
            title = "Debug Printed",
            description = "Check console for information.",
            duration = 2
        })
    end
})

local ResetButton = DubuLib:CreateButton({
    parent = SettingsTab,
    text = "Reset All Settings",
    callback = function()
        DubuLib:CreateNotify({
            title = "Settings Reset",
            description = "All settings have been reset to defaults.",
            duration = 2
        })
    end
})

print("✓ DubuLib Demo UI loaded successfully!")
print("↓ Press K to toggle the UI")
print("↓ Click minimize button (─) to show floating restore button")
print("↓ Try dragging the floating button around the screen")
