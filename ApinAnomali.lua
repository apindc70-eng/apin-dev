-- APIN ANOMALI | Mobile-friendly Roblox GUI
-- Use as a LocalScript in your own Roblox Studio experience.
-- This is a local character-settings UI, not a universal admin tool.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("ApinAnomaliGUI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "ApinAnomaliGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 16)
    c.Parent = obj
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(90, 190, 110)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.35
    s.Parent = obj
end

local function makeText(parent, text, size, pos, fontSize, color)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = size
    label.Position = pos
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(245,245,245)
    label.TextSize = fontSize or 16
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.new(0.92, 0, 0.72, 0)
panel.Position = UDim2.new(0.04, 0, 0.14, 0)
panel.BackgroundColor3 = Color3.fromRGB(12, 15, 17)
panel.BackgroundTransparency = 0.12
panel.Parent = gui
round(panel, 24)
stroke(panel, Color3.fromRGB(110, 120, 125), 1.2, 0.25)

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MinSize = Vector2.new(300, 360)
sizeLimit.MaxSize = Vector2.new(520, 650)
sizeLimit.Parent = panel

-- Drag by the header (mobile + mouse)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, -20, 0, 66)
header.Position = UDim2.new(0, 10, 0, 8)
header.BackgroundColor3 = Color3.fromRGB(25, 28, 31)
header.BackgroundTransparency = 0.12
header.Parent = panel
round(header, 18)

local title = makeText(header, "APIN ANOMALI", UDim2.new(0.58, 0, 0, 28), UDim2.new(0, 16, 0, 7), 20)
title.Font = Enum.Font.GothamBold
local status = makeText(header, "● Ready", UDim2.new(0.4, 0, 0, 20), UDim2.new(0, 16, 0, 37), 13, Color3.fromRGB(160, 220, 170))

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -46, 0, 15)
closeBtn.BackgroundColor3 = Color3.fromRGB(55, 58, 62)
closeBtn.Text = "—"
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
round(closeBtn, 18)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 72, 0, 34)
toggleBtn.Position = UDim2.new(1, -128, 0, 16)
toggleBtn.BackgroundColor3 = Color3.fromRGB(65, 68, 73)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = header
round(toggleBtn, 18)

local tabs = Instance.new("ScrollingFrame")
tabs.Name = "Tabs"
tabs.Size = UDim2.new(1, -24, 0, 44)
tabs.Position = UDim2.new(0, 12, 0, 84)
tabs.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
tabs.BackgroundTransparency = 0.18
tabs.BorderSizePixel = 0
tabs.ScrollBarThickness = 2
tabs.ScrollingDirection = Enum.ScrollingDirection.X
tabs.CanvasSize = UDim2.new(0, 590, 0, 0)
tabs.Parent = panel
round(tabs, 20)

local tabNames = {"All", "Favs", "Binds", "Custom", "States", "Size", "Others"}
local tabButtons = {}
local activeTab = "All"

local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -24, 1, -150)
content.Position = UDim2.new(0, 12, 0, 138)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.CanvasSize = UDim2.new(0, 0, 0, 420)
content.Parent = panel

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = content

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if child ~= list then child:Destroy() end
    end
end

local function addSection(text)
    local label = makeText(content, text, UDim2.new(1, -8, 0, 25), UDim2.new(), 13, Color3.fromRGB(175, 180, 185))
    label.Font = Enum.Font.GothamBold
    label.LayoutOrder = #content:GetChildren()
end

local function addToggle(text, initial, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 58)
    row.BackgroundColor3 = Color3.fromRGB(37, 42, 41)
    row.BackgroundTransparency = 0.12
    row.LayoutOrder = #content:GetChildren()
    row.Parent = content
    round(row, 17)

    local label = makeText(row, text, UDim2.new(0.72, -12, 1, 0), UDim2.new(0, 14, 0, 0), 14)
    label.TextWrapped = true

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 62, 0, 30)
    btn.Position = UDim2.new(1, -74, 0.5, -15)
    btn.BackgroundColor3 = initial and Color3.fromRGB(65, 170, 95) or Color3.fromRGB(70, 72, 80)
    btn.Text = initial and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = row
    round(btn, 16)

    local state = initial
    btn.Activated:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(65, 170, 95) or Color3.fromRGB(70, 72, 80)
        if callback then callback(state) end
    end)
end

local function addSlider(text, minValue, maxValue, defaultValue, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 82)
    row.BackgroundColor3 = Color3.fromRGB(37, 42, 41)
    row.BackgroundTransparency = 0.12
    row.LayoutOrder = #content:GetChildren()
    row.Parent = content
    round(row, 17)

    local label = makeText(row, text, UDim2.new(0.7, 0, 0, 24), UDim2.new(0, 14, 0, 9), 14)
    local valueLabel = makeText(row, tostring(defaultValue), UDim2.new(0.25, -8, 0, 24), UDim2.new(0.75, 0, 0, 9), 14, Color3.fromRGB(180, 190, 190))
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1, -28, 0, 10)
    bar.Position = UDim2.new(0, 14, 0, 51)
    bar.BackgroundColor3 = Color3.fromRGB(75, 80, 80)
    bar.Text = ""
    bar.AutoButtonColor = false
    bar.Parent = row
    round(bar, 8)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(95, 205, 120)
    fill.Size = UDim2.new((defaultValue-minValue)/(maxValue-minValue), 0, 1, 0)
    fill.Parent = bar
    round(fill, 8)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((defaultValue-minValue)/(maxValue-minValue), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(245,245,245)
    knob.Parent = bar
    round(knob, 12)

    local function update(inputX)
        local alpha = math.clamp((inputX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(minValue + (maxValue-minValue)*alpha + 0.5)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        valueLabel.Text = tostring(value)
        if callback then callback(value) end
    end
    bar.Activated:Connect(function()
        update(UserInputService:GetMouseLocation().X)
    end)
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            update(input.Position.X)
        end
    end)
end

local function getHumanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local speedValue, jumpValue = 16, 50
local function buildTab(tab)
    activeTab = tab
    for name, button in pairs(tabButtons) do
        button.BackgroundColor3 = (name == tab) and Color3.fromRGB(75, 85, 78) or Color3.fromRGB(42, 45, 49)
        button.TextColor3 = Color3.fromRGB(245,245,245)
    end
    clearContent()
    if tab == "All" or tab == "Custom" or tab == "States" then
        addSection("MOVEMENT")
        addSlider("WalkSpeed", 8, 60, speedValue, function(value)
            speedValue = value
            local h = getHumanoid()
            if h then h.WalkSpeed = value end
        end)
        addSlider("JumpPower", 20, 120, jumpValue, function(value)
            jumpValue = value
            local h = getHumanoid()
            if h then h.UseJumpPower = true; h.JumpPower = value end
        end)
        addToggle("Reset movement settings", false, function(on)
            if on then
                speedValue, jumpValue = 16, 50
                local h = getHumanoid()
                if h then h.WalkSpeed = 16; h.UseJumpPower = true; h.JumpPower = 50 end
                task.delay(0.15, function()
                    if activeTab == tab then buildTab(tab) end
                end)
            end
        end)
    elseif tab == "Favs" then
        addSection("FAVORITES")
        addToggle("Keep movement settings visible", true, function() end)
    elseif tab == "Binds" then
        addSection("CONTROLS")
        addToggle("Show keyboard-bind info", false, function(on)
            status.Text = on and "● Keyboard: RightShift" or "● Ready"
        end)
    elseif tab == "Size" then
        addSection("PANEL SIZE")
        addSlider("Panel width", 300, 520, 420, function(value)
            panel.Size = UDim2.new(0, value, panel.Size.Y.Scale, panel.Size.Y.Offset)
            panel.Position = UDim2.new(0.5, -value/2, panel.Position.Y.Scale, panel.Position.Y.Offset)
        end)
    elseif tab == "Others" then
        addSection("OTHER OPTIONS")
        addToggle("Show ready status", true, function(on)
            status.Visible = on
        end)
        addToggle("Dark translucent panel", true, function(on)
            panel.BackgroundTransparency = on and 0.12 or 0
        end)
    end
    task.defer(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 12)
    end)
end

for i, name in ipairs(tabNames) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, (name == "Custom" or name == "States" or name == "Others") and 88 or 70, 1, -8)
    b.Position = UDim2.new(0, 5, 0, 4)
    b.BackgroundColor3 = name == "All" and Color3.fromRGB(75,85,78) or Color3.fromRGB(42,45,49)
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.Parent = tabs
    round(b, 15)
    local x = 5
    for j = 1, i-1 do
        x = x + ((tabNames[j] == "Custom" or tabNames[j] == "States" or tabNames[j] == "Others") and 88 or 70) + 6
    end
    b.Position = UDim2.new(0, x, 0, 4)
    tabButtons[name] = b
    b.Activated:Connect(function() buildTab(name) end)
end

local minimized = false
closeBtn.Activated:Connect(function()
    minimized = not minimized
    tabs.Visible = not minimized
    content.Visible = not minimized
    panel.Size = minimized and UDim2.new(0.92, 0, 0, 82) or UDim2.new(0.92, 0, 0.72, 0)
    closeBtn.Text = minimized and "+" or "—"
end)

local enabled = false
toggleBtn.Activated:Connect(function()
    enabled = not enabled
    toggleBtn.Text = enabled and "ON" or "OFF"
    toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(65,170,95) or Color3.fromRGB(65,68,73)
    status.Text = enabled and "● Enabled" or "● Ready"
end)

-- Drag panel using header
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = dragStart or input.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        dragStart = nil
        startPos = nil
    end
end)

local keyConn = UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        panel.Visible = not panel.Visible
    end
end)

buildTab("All")
