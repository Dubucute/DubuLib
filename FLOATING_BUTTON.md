# 🎯 Draggable Floating Restore Button - Feature Guide

## What's New

DubuLib now features a **draggable floating restore button** that appears when you minimize the UI - inspired by Ash-Libs. This button works on **both PC and mobile** and can be moved anywhere on your screen!

---

## Features

### ✨ Draggable Restoration Button
- **Automatically appears** when you minimize the UI (click the minimize button "─")
- **Fully draggable** - drag it anywhere on your screen
- **Mobile & PC compatible** - works with mouse, touchscreen, and keyboard
- **Smart positioning** - stays within screen bounds automatically
- **Hover effects** - button grows slightly when you hover over it
- **Click to restore** - click the button to show the UI again

### 📍 Position Memory
- The button appears in the **top-right corner** by default
- You can **drag it anywhere** and it will stay in that position until you restore the UI
- When you minimize again, it will appear in the last position you left it

### 🎨 Visual Feedback
- **Button color**: Pink (Theme.Accent)
- **Stroke**: 2px pink border
- **Icon**: Up arrow (↑) indicating you can click to restore
- **Hover effect**: Grows to 65x65px and changes border color
- **Press effect**: Changes color when you press it

---

## How to Use

### For Users

1. **Minimize the UI**
   - Click the minimize button (─) in the top-right corner of the window

2. **See the floating button**
   - A pink floating button with an up arrow (↑) appears on screen

3. **Drag it around** (optional)
   - Click and drag the button to move it anywhere on screen
   - The button stays within screen bounds automatically

4. **Restore the UI**
   - Click the floating button to restore the main UI window
   - Or press your toggle key (K by default) to restore

---

## How It Works (For Developers)

### Minimize Function
```lua
function minimizeGUI()
    minimized = true
    MainFrame.Visible = false  -- Hide main window
    createFloatingRestoreButton()  -- Show floating button
end
```

### Floating Button Creation
```lua
-- Creates a 60x60px draggable button with:
-- - Pink background (Theme.Accent)
-- - Up arrow icon (↑)
-- - Hover scale animations
-- - Drag clamping to screen bounds
-- - Click-to-restore functionality
```

### Restore Function
```lua
function restoreGUI()
    minimized = false
    MainFrame.Visible = true  -- Show main window
    hideFloatingButton()  -- Destroy floating button
end
```

---

## Technical Details

### Dragging Implementation

The floating button uses a **sophisticated dragging system**:

1. **Input Detection**
   - Detects MouseButton1 and Touch inputs
   - Tracks drag distance to distinguish clicks from drags

2. **Clamped Movement**
   - Prevents button from going off-screen
   - Uses `math.clamp()` to keep button within viewport
   - Works with any screen resolution

3. **Visual Feedback During Drag**
   - Color changes to Theme.Secondary while dragging
   - Hover effects disabled during drag (smooth UX)
   - Restores normal colors when drag ends

4. **Smart Click Detection**
   - If drag distance < 10 pixels, treats as click
   - If drag distance >= 10 pixels, treats as drag only
   - Prevents accidental restores while dragging

### Code Structure

```lua
floatingButton.InputBegan:Connect(function(input)
    -- Start drag: track initial position
end)

UserInputService.InputChanged:Connect(function(input)
    -- During drag: update button position with clamping
    local delta = input.Position - dragStart
    local newX = math.clamp(startPos.X.Offset + delta.X, 0, screenSize.X - 60)
    local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, screenSize.Y - 60)
    floatingButton.Position = UDim2.new(0, newX, 0, newY)
end)

UserInputService.InputEnded:Connect(function(input)
    -- End drag: check if it was a click (dragDistance < 10)
    if dragDistance < 10 then
        restoreGUI()
    end
end)
```

---

## Mobile Support

The floating button works perfectly on mobile devices:

✅ **Touch support** - Drag with your finger
✅ **Responsive** - Adapts to any screen size
✅ **Auto-clamping** - Prevents off-screen positioning
✅ **Haptic feedback** - Works with device vibration (if enabled)

---

## Customization

### Change Button Size
```lua
floatingButton.Size = UDim2.new(0, 70, 0, 70)  -- Make it larger
```

### Change Start Position
In the `createFloatingRestoreButton()` function:
```lua
floatingButton.Position = UDim2.new(0, 100, 0, 100)  -- Top-left corner
-- or
floatingButton.Position = UDim2.new(1, -80, 1, -80)  -- Bottom-right corner
```

### Change Button Icon
```lua
buttonText.Text = "✕"  -- Use X instead of arrow
-- or
buttonText.Text = "⬆"  -- Use different arrow style
```

### Change Button Colors
```lua
floatingButton.BackgroundColor3 = Theme.Secondary
floatingStroke.Color = Theme.Warning
```

---

## Demo

The `DemoScript.lua` now includes:
- Instructions on how to use the minimize feature
- A tip showing where the minimize button is
- A dedicated "Minimize/Restore" section in Settings tab
- Console output when you minimize

Try it out:
1. Run DemoScript.lua
2. Click the minimize button (─) in the top-right
3. See the floating restore button appear
4. Drag it around your screen
5. Click it to restore the UI

---

## Comparison: Before vs After

### Before
- Minimize button collapsed the window (reduced height)
- No restore button when minimized
- Hard to find the UI again
- Didn't work well on mobile

### After
- **Minimize hides the entire window** (MainFrame.Visible = false)
- **Floating restore button appears** (60x60px pink button)
- **Easy to restore**: click the floating button or press toggle key
- **Works on mobile**: touchscreen support
- **Draggable**: move button anywhere on screen
- **Visual feedback**: hover and press effects

---

## Troubleshooting

### Button doesn't appear when I minimize
- Make sure you're clicking the correct minimize button (─ in top-right)
- Check that your CoreGui is accessible
- The floating button should appear in the top-right corner

### Button is off-screen
- The button has automatic clamping, so it should never go off-screen
- If it does, refresh the page or restart the game

### Button sticks when dragging
- This usually means InputChanged or InputEnded events aren't firing properly
- Try releasing the mouse/touch and clicking again
- Check if the game is experiencing lag

### Restoring doesn't work
- Make sure you're clicking the button (short tap/press, not a long drag)
- Try pressing your toggle key (K by default) instead
- Check console for any error messages

---

## Related Features

- **Minimize Button**: Click the "─" button in top-right of window
- **Close Button**: Click the "✕" button to close the UI
- **Toggle Key**: Press K to toggle UI visibility
- **Notifications**: Appear when you minimize the UI

---

## Examples

### Minimize from Code
You currently minimize by clicking the button, but you could add this:
```lua
-- To minimize and show floating button
minimizeGUI()

-- To restore the UI
restoreGUI()
```

### Custom Floating Button Styling
The floating button inherits from the current Theme, so changing the theme
automatically updates the floating button colors:

```lua
-- All floating button elements use Theme colors:
floatingButton.BackgroundColor3 = Theme.Accent  -- Pink
floatingStroke.Color = Theme.Accent  -- Pink border
buttonText.TextColor3 = Theme.Text  -- White text
```

---

## Future Improvements

Possible enhancements:
- [ ] Save button position to local storage
- [ ] Allow customizable button icon
- [ ] Add animation when button first appears
- [ ] Support for Windows 10/11 taskbar integration
- [ ] Custom hotkey to minimize
- [ ] Floating button notification badge

---

Enjoy the new draggable floating restore button! Happy UI building! 🎨✨
