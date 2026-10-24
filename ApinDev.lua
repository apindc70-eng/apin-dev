
-- APIN ADMIN GUI
-- Contoh GUI untuk Roblox

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ApinAdminGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 240)
frame.Position = UDim2.new(0.5, -130, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
title.Text = "APIN ADMIN"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(text, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 38)
    button.Position = UDim2.new(0, 10, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = button

    button.Activated:Connect(callback)
end

local function getHumanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

createButton("Speed +", 55, function()
    local h = getHumanoid()
    if h then h.WalkSpeed = math.min(h.WalkSpeed + 5, 100) end
end)

createButton("Jump +", 100, function()
    local h = getHumanoid()
    if h then
        h.UseJumpPower = true
        h.JumpPower = math.min(h.JumpPower + 10, 150)
    end
end)

createButton("Reset Movement", 145, function()
    local h = getHumanoid()
    if h then
        h.WalkSpeed = 16
        h.UseJumpPower = true
        h.JumpPower = 50
    end
end)

createButton("Tutup Menu", 190, function()
    gui.Enabled = false
end)

gui.Parent = player:WaitForChild("PlayerGui")
