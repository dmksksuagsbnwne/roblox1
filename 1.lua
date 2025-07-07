local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TeleportService")
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomMenu"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local neon, dark = Color3.fromRGB(0,178,255), Color3.fromRGB(20,20,20)
local MAX_SPEED = 250
local function center(w,h)
    local v = workspace.CurrentCamera.ViewportSize
    return UDim2.new(0, (v.X - w)/2, 0, (v.Y - h)/2)
end

local settings = { speed = 16, speedEnabled = true, infJump = false, god = false, noclip = false }
local data = TS:GetTeleportData()
if typeof(data) == "table" then
    for k,v in pairs(data) do if settings[k] ~= nil then settings[k] = v end end
end

-- Icon
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,50,0,50)
icon.Position = UDim2.new(1,-60,0.5,-25)
icon.Text = "1"
icon.Font = Enum.Font.GothamBold
icon.TextScaled = true
icon.TextColor3 = neon
icon.BackgroundColor3 = dark
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

-- Menu
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,340,0,380)
menu.Position = center(340,380)
menu.BackgroundColor3 = dark
menu.BackgroundTransparency = 0.25
menu.BorderColor3 = neon
menu.Visible = false
menu.Active = true
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,12)

local function newLabel(text, pos)
    local l = Instance.new("TextLabel", menu)
    l.Size = UDim2.new(1,-20,0,30)
    l.Position = UDim2.new(0,10,0,pos)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = neon
    l.Font = Enum.Font.Gotham
    l.TextScaled = true
    return l
end

local function newToggle(text, pos, key)
    local b = Instance.new("TextButton", menu)
    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,pos)
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.BorderColor3 = neon
    b.Text = text .. ": " .. (settings[key] and "ON" or "OFF")
    b.Font = Enum.Font.Gotham
    b.TextColor3 = neon
    b.TextScaled = true
    b.AutoButtonColor = false
    b.MouseButton1Click:Connect(function()
        settings[key] = not settings[key]
        b.Text = text .. ": " .. (settings[key] and "ON" or "OFF")
    end)
    return b
end

local title = newLabel("Custom Menu", 10)
title.Font = Enum.Font.GothamBlack
local close = Instance.new("TextButton", menu)
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-38,0,10)
close.Text = "X"
close.TextColor3 = neon
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(40,40,40)
close.BorderColor3 = neon
Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

local infB = newToggle("Infinite Jump", 60, "infJump")
local godB = newToggle("God Mode", 100, "god")
local noclipB = newToggle("Noclip", 140, "noclip")
local speedB = newToggle("Enable Speed", 180, "speedEnabled")
local speedLbl = newLabel("Speed: " .. settings.speed, 220)
local speedInput = Instance.new("TextBox", menu)
speedInput.Size = UDim2.new(0,60,0,30)
speedInput.Position = UDim2.new(0,10,0,260)
speedInput.BackgroundColor3 = Color3.fromRGB(30,30,30)
speedInput.TextColor3 = neon
speedInput.Text = tostring(settings.speed)
speedInput.Font = Enum.Font.Gotham
speedInput.TextScaled = true
speedInput.ClearTextOnFocus = false
speedInput.BorderColor3 = neon

local bar = Instance.new("Frame", menu)
bar.Size = UDim2.new(1,-90,0,20)
bar.Position = UDim2.new(0,80,0,270)
bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
bar.BorderColor3 = neon
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,10)

local handle = Instance.new("Frame", bar)
handle.Size = UDim2.new(settings.speed/MAX_SPEED,0,1,0)
handle.BackgroundColor3 = neon
handle.BorderColor3 = neon
handle.Active = true
Instance.new("UICorner", handle).CornerRadius = UDim.new(0,10)

local function setSpeed(v)
    v = tonumber(v) or settings.speed
    settings.speed = math.clamp(v,1,MAX_SPEED)
    speedLbl.Text = "Speed: " .. settings.speed
    speedInput.Text = tostring(settings.speed)
    handle.Size = UDim2.new(settings.speed/MAX_SPEED,0,1,0)
    if settings.speedEnabled then
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = settings.speed end
    end
end

speedInput.FocusLost:Connect(function() setSpeed(speedInput.Text) end)

local draggingSlider = false
bar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
    end
end)
bar.InputEnded:Connect(function() draggingSlider = false end)
handle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
    end
end)
handle.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

UIS.InputChanged:Connect(function(i)
    if draggingSlider then
        local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
        setSpeed(1 + math.floor(rel*(MAX_SPEED-1)))
    end
end)

icon.MouseButton1Click:Connect(function()
    menu.Position = center(340,380)
    menu.Visible = true
    icon.Visible = false
end)
close.MouseButton1Click:Connect(function()
    menu.Visible = false
    icon.Position = UDim2.new(1,-60,0.5,-25)
    icon.Visible = true
    TS:SetTeleportData(settings)
end)

UIS.JumpRequest:Connect(function()
    if settings.infJump then
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RS.Stepped:Connect(function()
    local c = player.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    local root = c:FindFirstChild("HumanoidRootPart")
    if settings.god and h then
        h.Health = h.MaxHealth
        h:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
    end
    if root and root.Position.Y < workspace.FallenPartsDestroyHeight then
        root.CFrame = CFrame.new(0,10,0)
        if h then h.Health = h.MaxHealth end
    end
    if settings.noclip then
        for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    else
        for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
    if h and settings.speedEnabled then
        h.WalkSpeed = settings.speed
    end
end)

player.CharacterAdded:Connect(function(c)
    c:WaitForChild("Humanoid").WalkSpeed = settings.speed
end)

game:BindToClose(function()
    TS:SetTeleportData(settings)
end)

setSpeed(settings.speed)
