# DubuLib - Enhanced Pink & Black Theme + Demo

## 🎨 Theme Updates

### Color Scheme Changed to Pink & Black
The DubuLib now features a modern **pink and black** color scheme:

- **Background**: Charcoal black (#0A0A0F)
- **Accent**: Vibrant pink (#FF1493 - Deep Pink)
- **Secondary Accent**: Darker pink (#DB2777)
- **Text**: White (#FFFFFF)
- **Surfaces**: Dark gray (#1A1A23, #191914)
- **Borders**: Subtle gray (#323C3C)

### Gradient Support
Two gradient effects have been added:

1. **Main Frame Gradient**: Subtle black-to-dark-pink diagonal gradient (45°)
   - Creates depth and visual interest
   - Background to darker purple-black tone

2. **Title Bar Gradient**: Eye-catching pink gradient (90°)
   - Black NavBackground to vibrant Deep Pink
   - Makes the header pop while maintaining readability

### Utility Function: `applyGradient()`
```lua
local gradient = applyGradient(frame, color1, color2, rotation)
```
- **frame**: The UI element to apply gradient to
- **color1**: Starting color (Color3)
- **color2**: Ending color (Color3)
- **rotation**: Gradient angle in degrees (default: 0)

---

## 📦 Demo Script

### Features Demonstrated
The **DemoScript.lua** showcases all DubuLib components:

#### **Home Tab**
- Welcome section with descriptive paragraph
- Interactive button with notification callback
- Introduction to DubuLib

#### **Components Tab**
All interactive components with examples:

1. **Input Components**
   - Text input boxes with callbacks

2. **Toggles & Buttons**
   - Toggle switches with callbacks
   - Action buttons
   - Loading screen demo with progress bar

3. **Sliders & Advanced**
   - Value sliders (0-100)
   - Speed control sliders
   - KeyBind selector
   - Color picker with RGB sliders

4. **Dropdowns** (Enhanced features)
   - Simple dropdown with search
   - Icon dropdown (with Roblox asset icons)
   - Multi-select dropdown with checkmarks

5. **Dividers** for visual separation

#### **Settings Tab**
- Theme toggle (dark mode)
- Auto-save configuration
- UI scale adjustment
- Animation settings
- Debug information button
- Settings reset button

---

## 🚀 Usage

### Running the Demo
1. Place `DubuLib.lua` in `ServerScriptService` or `ReplicatedStorage`
2. Place `DemoScript.lua` in `StarterPlayer > StarterCharacterScripts` or `StarterPlayer > StarterPlayerScripts`
3. Adjust the require path in DemoScript.lua to match your installation:
   ```lua
   local DubuLib = require(game.ServerScriptService:WaitForChild("DubuLib"))
   ```

### Creating Your Own UI
```lua
local DubuLib = require(script.Parent:WaitForChild("DubuLib"))

-- Create main UI window
local UI = DubuLib:CreateMain({
    Name = "MyUI",
    title = "My Custom UI",
    ToggleUI = "K",  -- Press K to toggle
})

-- Create a tab
local Tab = DubuLib:CreateTab("Main", "🏠")

-- Add components
DubuLib:CreateButton({
    parent = Tab,
    text = "Click Me",
    callback = function()
        print("Button clicked!")
    end
})
```

---

## 🎯 Key Enhancements

### 1. Dropdown Features (Already Implemented)
- **Searchable**: Real-time filtering with search box
- **Icons**: Display icons from Roblox assets or custom URLs
- **Multi-Select**: Select multiple options with checkmark indicators
- **Smart Positioning**: Auto-adjusts dropdown position if it goes off-screen
- **Option Pooling**: Efficient rendering of large option lists

### 2. Color Customization
```lua
-- You can override the default theme
local CustomTheme = {
    Background = Color3.fromRGB(10, 10, 15),
    Accent = Color3.fromRGB(255, 20, 147),
    -- ... other colors
}

local UI = DubuLib:CreateMain({
    Theme = CustomTheme,
    -- ...
})
```

### 3. Gradient System
All major UI frames now support gradients for better visuals. Use the `applyGradient()` function for custom elements.

---

## 📊 Component API Reference

### Buttons
```lua
DubuLib:CreateButton({
    parent = Tab,
    text = "Button Text",
    callback = function() end
})
```

### Toggles
```lua
DubuLib:CreateToggle({
    parent = Tab,
    text = "Toggle Text",
    default = false,
    callback = function(value) end
})
```

### Sliders
```lua
DubuLib:CreateSlider({
    parent = Tab,
    text = "Slider",
    min = 0,
    max = 100,
    default = 50,
    callback = function(value) end
})
```

### Dropdowns
```lua
DubuLib:CreateDropdown({
    parent = Tab,
    text = "Dropdown",
    options = {"A", "B", "C"},       -- Simple strings
    -- OR with icons:
    -- options = {{text = "A", icon = "url"}, ...},
    default = "A",
    multi = false,                   -- Set true for multi-select
    searchable = true,               -- Enable search (default: true)
    callback = function(value) end
})

-- Multi-select returns a table
dropdown:Refresh(newOptions)         -- Update options
dropdown:Set(value)                  -- Set value
dropdown:Get()                       -- Get current value
dropdown:Clear()                     -- Clear all options
```

### Input Boxes
```lua
DubuLib:CreateInput({
    parent = Tab,
    text = "Input Label",
    default = "placeholder text",
    callback = function(value) end
})
```

### Color Picker
```lua
DubuLib:CreateColorPicker({
    parent = Tab,
    text = "Color",
    default = Color3.fromRGB(255, 20, 147),
    callback = function(color) end
})
```

### KeyBind
```lua
DubuLib:CreateKeyBind({
    parent = Tab,
    text = "Keybind",
    default = "F",
    callback = function(key) end
})
```

### Notifications
```lua
DubuLib:CreateNotify({
    title = "Title",
    description = "Description text",
    duration = 3  -- seconds
})
```

### Sections & Dividers
```lua
DubuLib:CreateSection({
    parent = Tab,
    text = "Section Title"
})

DubuLib:CreateDivider({ parent = Tab })
```

---

## 🎨 Customization Tips

### Change Pink Accent Color
Edit these lines in the theme:
```lua
Accent = Color3.fromRGB(255, 20, 147),           -- Deep Pink
AccentSecondary = Color3.fromRGB(219, 39, 119),  -- Darker Pink
```

### Modify Gradient Angles
In `CreateMain()`:
```lua
-- Title bar gradient - change 90 to different angle
applyGradient(TitleBar, Theme.NavBackground, Color3.fromRGB(255, 20, 147), 90)

-- Main frame gradient - change 45 to different angle
applyGradient(Main, Theme.Background, Color3.fromRGB(15, 10, 20), 45)
```

### Create Your Own Gradient Elements
```lua
local customFrame = Instance.new("Frame")
-- ... set up frame properties ...
applyGradient(customFrame, color1, color2, angle)
```

---

## 📝 Notes

- **Performance**: Gradient rendering is GPU-accelerated, minimal performance impact
- **Compatibility**: Works with all Roblox games (tested on Lua 5.1+)
- **Click Outside to Close**: Dropdowns and popups close when clicking outside
- **Keyboard Support**: KeyBind component supports both Keys and Mouse buttons
- **Config Saving**: Use `GUI:SaveConfig()` and `GUI:LoadConfig()` for persistence

---

## 🔧 Troubleshooting

### Dropdown not appearing?
- Ensure `Config.parent` is set to a valid tab/frame
- Check that `SearchBox` is enabled (default: true)

### Colors not showing?
- Verify Color3 values are in RGB (0-255 range)
- Check that gradient parent frame has `BackgroundTransparency = 0`

### UI not responding?
- Check console for errors
- Verify all connections are being cleaned up on GUI destroy
- Ensure `DubuLib:Cleanup()` is called when closing

---

## 📄 License & Credits

DubuLib - UI Library for Roblox
Based on DubuUI with enhancements and improvements

Enjoy creating beautiful, modern UIs! 🎉
