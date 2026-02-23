# DubuLib - Quick Start Guide

## 📥 Installation

### Step 1: Place the Library
1. Copy `DubuLib.lua` to your game's `ServerScriptService`

### Step 2: Create a Script
```lua
local DubuLib = require(game.ServerScriptService:WaitForChild("DubuLib"))

-- Your code here
```

---

## ⚡ 30-Second Example

```lua
local DubuLib = require(game.ServerScriptService:WaitForChild("DubuLib"))

-- Create the UI window
local UI = DubuLib:CreateMain({
    Name = "MyUI",
    title = "My First UI",
    ToggleUI = "K",  -- Press K to toggle
})

-- Create a tab
local MainTab = DubuLib:CreateTab("Main", "🎮")

-- Add a button
DubuLib:CreateButton({
    parent = MainTab,
    text = "Say Hello",
    callback = function()
        print("Hello World!")
        DubuLib:CreateNotify({
            title = "Success!",
            description = "Button works!",
            duration = 2
        })
    end
})

-- Add a toggle
DubuLib:CreateToggle({
    parent = MainTab,
    text = "Feature Enabled",
    default = false,
    callback = function(value)
        print("Feature is", value and "enabled" or "disabled")
    end
})

-- Add a slider
DubuLib:CreateSlider({
    parent = MainTab,
    text = "Volume",
    min = 0,
    max = 100,
    default = 50,
    callback = function(value)
        print("Volume:", value)
    end
})

print("✓ UI Created! Press K to toggle")
```

---

## 🎨 Current Theme: Pink & Black

The library comes with a beautiful **pink and black** color scheme:

- **Dark backgrounds** with black/charcoal tones
- **Vibrant pink accents** (#FF1493)
- **Gradient effects** on main window and title bar
- **High contrast** for readability

---

## 📚 Common Tasks

### Add More Tabs
```lua
local Tab2 = DubuLib:CreateTab("Settings", "⚙️")
local Tab3 = DubuLib:CreateTab("Advanced", "🔧")
```

### Create Multi-Line Content
```lua
DubuLib:CreateSection({
    parent = MainTab,
    text = "My Section"
})

DubuLib:CreateParagraph({
    parent = MainTab,
    text = "This is descriptive text that can span multiple lines and explain features."
})

DubuLib:CreateDivider({ parent = MainTab })
```

### Multi-Select Dropdown
```lua
local choices = DubuLib:CreateDropdown({
    parent = MainTab,
    text = "Pick Multiple",
    options = {"Red", "Green", "Blue", "Yellow"},
    multi = true,  -- Enable multi-select!
    searchable = true,
    callback = function(selected)
        print("Selected:", table.concat(selected, ", "))
    end
})
```

### Dropdown with Icons & Search
```lua
DubuLib:CreateDropdown({
    parent = MainTab,
    text = "Choose",
    options = {
        {text = "Home", icon = "rbxasset://textures/Lucide/home.png"},
        {text = "Settings", icon = "rbxasset://textures/Lucide/settings.png"},
    },
    searchable = true,  -- Shows search box
    callback = function(value)
        print("Selected:", value)
    end
})
```

### Show Loading Screen
```lua
local loading = DubuLib:ShowLoading("Processing Data")

-- Simulate progress
for i = 0, 100, 10 do
    task.wait(0.2)
    DubuLib:UpdateLoading(i)
end

DubuLib:HideLoading()
```

### Save & Load Configuration
```lua
-- Save configuration
local data = {
    myValue = "test",
    myNumber = 42
}
DubuLib:SaveConfig("config.json", data)

-- Load configuration
local loaded = DubuLib:LoadConfig("config.json")
print(loaded.myValue)  -- "test"
```

---

## 🎮 Full Component List

| Component | Usage |
|-----------|-------|
| **Button** | Click to perform action |
| **Toggle** | On/Off switch |
| **Slider** | Numeric value selection |
| **Input** | Text box for user input |
| **Dropdown** | Select from list (single/multi) |
| **KeyBind** | Select keyboard key |
| **Color Picker** | RGB color selection |
| **Paragraph** | Display text content |
| **Section** | Group components with title |
| **Divider** | Visual separator |
| **Notification** | Toast-style message |
| **Tab** | Organize content |

---

## 🎯 Tips & Tricks

### Hide UI on Startup
```lua
local UI = DubuLib:CreateMain({
    Name = "MyUI",
    title = "My UI",
    ToggleUI = "K",
})

-- Hide it initially
UI.MainFrame.Enabled = false

-- Show with toggle key (K) or button
```

### Get Component Values
```lua
local dropdown = DubuLib:CreateDropdown({
    parent = MainTab,
    text = "Choose",
    options = {"A", "B", "C"},
    callback = function() end
})

-- Later, get the value
local current = dropdown:Get()
print(current)
```

### Update Dropdown Options
```lua
dropdown:Refresh({"NewOption1", "NewOption2"})
```

### Dark Mode Always Enabled
The pink & black theme is a dark mode by default. All components automatically use dark backgrounds with bright pink accents.

---

## 🚀 Demo Script

Check out `DemoScript.lua` for a complete working example showing:
- ✓ All UI components  
- ✓ Multi-tab navigation
- ✓ Callbacks and interactions
- ✓ Notifications and loading screens
- ✓ Settings and debug info

---

## ❓ FAQ

**Q: How do I change the toggle key?**
A: Change `ToggleUI` in CreateMain():
```lua
DubuLib:CreateMain({ ToggleUI = "J" })  -- Now press J
```

**Q: Can I customize colors?**
A: Yes! Create a custom theme table:
```lua
local MyTheme = {
    Background = Color3.fromRGB(10, 10, 15),
    Accent = Color3.fromRGB(255, 20, 147),
    -- ... other colors
}

DubuLib:CreateMain({ Theme = MyTheme })
```

**Q: How do I close the dropdown without clicking outside?**
A: Click the dropdown button again to toggle it closed.

**Q: Do dropdowns support emojis?**
A: Yes! Include emojis in option text: `{"🔴 Red", "🟢 Green", "🔵 Blue"}`

---

## 📖 Next Steps

1. **Check out the demo**: Run `DemoScript.lua` to see all features
2. **Read the full docs**: Open `README.md` for detailed API reference
3. **Create your UI**: Start building with the components you need
4. **Share your creation**: Show off your UI to others!

---

## 💬 Support

- Check console for error messages
- Ensure DubuLib is loaded before use
- Verify parent frames exist before adding components
- Use `game:GetService("HttpService"):JSONEncode()` for complex data saving

Happy UIing! 🎨✨
